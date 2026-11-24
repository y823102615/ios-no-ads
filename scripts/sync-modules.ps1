<#
.SYNOPSIS
  Download the upstream community ad-block module, harden it, and write
  modules/blockAds.trimmed.sgmodule plus pinned copies of its scripts under js/.

.DESCRIPTION
  Upstream: fmz200/wool_scripts Shadowrocket/module/blockAds.srmodule

  Line patches (matching lines are dropped):
    1. "Safe browsing bypass" rules. Upstream rejects Apple/Google/QQ/Baidu safe-browsing
       domains, which disables Safari's fraudulent-website warning.
    2. Bilibili rewrites that fake VIP status (account/mine, account/myinfo).
    3. Other paid-feature unlocks (Spotify, Kuwo, 51job, xjsp).

  MITM hostname filtering (hosts are removed from the module's [MITM] hostname list,
  so their HTTPS traffic is never decrypted; rules/scripts for them become inert):
    - banks, payment, wallets, brokers, insurers, crypto exchanges
    - WeChat / QQ security, account and login endpoints
    - government, telecom-account and medical services
    - shopping main API gateways (Taobao/Goofish/Youku "acs" mtop gateways, JD api.m.jd.com,
      Pinduoduo, Xiaomi mall). These carry login, orders and addresses. Use
      -KeepShoppingGatewayMitm to keep them (better in-app ad removal, more exposure).
    - malformed or look-alike hostnames (e.g. "ailbaba.me")

  Script pinning:
    Every script-path URL is downloaded into js/ and the module is rewritten to load it
    from this repository, so upstream authors cannot change code running on the phone
    without a reviewed commit here. Each script is scanned for APIs that can send data
    off the device ($httpClient, $task.fetch, fetch, XMLHttpRequest) or run dynamic code
    (eval, new Function). Flagged scripts are disabled unless they are listed in
    $ReviewedScripts below with the SHA-256 of the reviewed content. A report is written
    to js/AUDIT.md.

  The script fails if a line patch matches nothing, so upstream format changes are
  noticed instead of silently ignored.

.EXAMPLE
  powershell -ExecutionPolicy Bypass -File scripts\sync-modules.ps1
.EXAMPLE
  powershell -ExecutionPolicy Bypass -File scripts\sync-modules.ps1 -KeepShoppingGatewayMitm
#>
[CmdletBinding()]
param(
    [string]$UpstreamUrl = 'https://raw.githubusercontent.com/fmz200/wool_scripts/main/Shadowrocket/module/blockAds.srmodule',
    [string]$RepoRawBase = 'https://raw.githubusercontent.com/y823102615/ios-no-ads/main',
    [switch]$KeepShoppingGatewayMitm
)

# Scripts that use network/eval APIs but were read and judged safe. Keyed by pinned file
# name; Sha256 is of the upstream content that was reviewed. If upstream changes, the hash
# no longer matches and the script is disabled until it is reviewed again.
$ReviewedScripts = @{
    'kokoryh__Sparkle__dist__bilibili.json.js' = @{
        Sha256 = '5B2E1A9C2B203648A75C1E7D1C8B20081005FCE6D909FB378AB2C3B5C3B8E4CB'
        Reason = '$httpClient only appears in the shared env wrapper; fetch() is never called.'
    }
    'kokoryh__Sparkle__dist__bilibili.protobuf.response.js' = @{
        Sha256 = '4A70452A6F6CA07F9D81069005075DBF2957C349CFE981D26AF2D295EBBC016E'
        Reason = 'fetch() is never called. SponsorBlock gate is patched off (see $JsPatches) so the player package (chronos) is never redirected to a third-party zip.'
    }
}

# Content patches applied to pinned scripts. A patch that matches nothing disables the script.
$JsPatches = @{
    'kokoryh__Sparkle__dist__bilibili.protobuf.response.js' = @(
        @{ Name    = 'disable SponsorBlock/chronos gate'
           Regex   = 'function\s+([\w$]+)\(([\w$]+)\)\{return!!\(\2&&\2!=="#"\)\}'
           Replace = 'function $1($2){return!1}' }
    )
}

$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
# Windows PowerShell 5.1 does not populate $PSScriptRoot inside param defaults.
$RepoRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$OutFile = Join-Path $RepoRoot 'modules\blockAds.trimmed.sgmodule'
$JsDir = Join-Path $RepoRoot 'js'
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

function Get-Utf8 ([string]$Url) {
    $bytes = (Invoke-WebRequest -UseBasicParsing -Uri $Url -TimeoutSec 120).RawContentStream.ToArray()
    return [Text.Encoding]::UTF8.GetString($bytes)
}

Write-Host "Downloading $UpstreamUrl"
$lines = (Get-Utf8 $UpstreamUrl) -split "`r?`n"
Write-Host "Upstream lines: $($lines.Count)"

# ---------------------------------------------------------------- 1. line patches
$patches = @(
    @{ Name = 'safe-browsing bypass rules';
       Regex = '^(DOMAIN|DOMAIN-SUFFIX),(lookup\.api\.bsb\.baidu\.com|proxy\.safebrowsing\.apple|safebrowsing\.g\.applimg\.com|safebrowsing\.googleapis\.com|safebrowsing\.urlsec\.qq\.com|token\.safebrowsing\.apple|safebrowsing\.apple|vs6\.bj2ct\.u3\.ucweb\.com|u3\.ucweb\.com),REJECT' },
    @{ Name = 'bilibili fake-VIP rewrites';
       Regex = '^http-response-jq \^https:\\/\\/app\\\.bilibili\\\.com\\/x\\/v2\\/account\\/(mine|myinfo)' }
    # Paid-feature unlocks bundled in upstream. Not ad blocking; they spoof paid rights.
    @{ Name = 'unlock: Spotify premium';
       Regex = 'Spotify\.Crack|artistview\\/v1\\/artist\\/\(\.\*\)&platform=iphone' }
    @{ Name = 'unlock: Kuwo VIP/paid songs';
       Regex = '^[^#].*pattern=\^https\?:\\/\\/(vip1|audiobookpay|musicpay)\\\.kuwo\\\.cn.*script-path=' }
    @{ Name = 'unlock: 51job VIP';
       Regex = 'script-path=\S*/AntiAd/51job\.js' }
    @{ Name = 'unlock: xjsp video VIP';
       Regex = 'script-path=\S*/xjsp\.js' }
)
$kept = New-Object System.Collections.Generic.List[string]
$removed = @{}
foreach ($p in $patches) { $removed[$p.Name] = 0 }
foreach ($line in $lines) {
    $drop = $false
    foreach ($p in $patches) {
        if ($line -match $p.Regex) { $removed[$p.Name]++; $drop = $true; break }
    }
    if (-not $drop) { $kept.Add($line) }
}
$missing = @()
foreach ($p in $patches) {
    Write-Host ("Removed {0,3} line(s): {1}" -f $removed[$p.Name], $p.Name)
    if ($removed[$p.Name] -eq 0) { $missing += $p.Name }
}
if ($missing.Count -gt 0) {
    throw "Patch matched nothing, upstream format may have changed: $($missing -join ', '). Review the upstream file before publishing."
}

# ---------------------------------------------------------------- 2. MITM hostname filter
$sensitiveRules = [ordered]@{
    'bank'          = 'bank|cmbchina|cmbc\.com|icbc|(^|\.)ccb\.com|abchina|(^|\.)boc\.cn|bankcomm|citicbank|ecitic|cebbank|psbc|spdb|(^|\.)cib|hxb\.com|jsbchina|grcbank|jlbank|95508|95504|95599|95588|95533|95566|cgbank|(^|\.)sdb\.com|z-bank'
    'payment'       = 'pay|tenpay|qianbao|wallet|lakala|helipay|cloudpnr|unionpay|95516|alipay'
    'finance'       = '(^|[.-])jr\.|finance|fintech|stock|credit|futunn|hstong|touker|10jqka|dfcfw|1234567\.com|yxzq|xyzq|gtja|htsc|cmschina|chinahxzq|cgws|hsbcfts|winbull|binance|u51\.com'
    'insurance'     = 'e-chinalife|epicc|cntaiping|aia\.com|pingan|fosunhanig'
    'wechat/qq-sec' = 'weixin|wechat|(^|\.)security\.'
    'account/login' = 'account|passport|login|(^|\.)sso\.|(^|\.)auth\.'
    'gov/telecom'   = '\.gov\.cn|nhsa|zjzwfw|10086|10010|10099|189\.cn|139\.com'
    'medical'       = 'patient|guahao|(^|\.)dxy\.'
    'malformed'     = 'ailbaba|hostname$|\s'
}
if (-not $KeepShoppingGatewayMitm) {
    $sensitiveRules['shopping-gateway'] = '(^|[.-])acs[.-]|^api\.m\.jd\.com$|^amdc\.m\.taobao\.com$|yangkeduo\.com$|^api\.pinduoduo\.com$|^api\.m\.mi\.com$'
}

$hostReport = [ordered]@{}
foreach ($k in $sensitiveRules.Keys) { $hostReport[$k] = New-Object System.Collections.Generic.List[string] }
$keptHostTotal = 0
for ($i = 0; $i -lt $kept.Count; $i++) {
    if ($kept[$i] -notmatch '^hostname\s*=\s*(%APPEND%)?\s*(.*)$') { continue }
    $prefix = if ($Matches[1]) { 'hostname = %APPEND% ' } else { 'hostname = ' }
    $hosts = $Matches[2] -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ }
    $keep = New-Object System.Collections.Generic.List[string]
    foreach ($h in $hosts) {
        $hit = $null
        foreach ($k in $sensitiveRules.Keys) {
            if ($h -match $sensitiveRules[$k]) { $hit = $k; break }
        }
        if ($hit) { $hostReport[$hit].Add($h) } else { $keep.Add($h) }
    }
    $kept[$i] = $prefix + ($keep -join ', ')
    $keptHostTotal += $keep.Count
}
$removedHostTotal = 0
foreach ($k in $hostReport.Keys) {
    $removedHostTotal += $hostReport[$k].Count
    Write-Host ("MITM removed {0,3} host(s): {1}" -f $hostReport[$k].Count, $k)
}
Write-Host "MITM hosts kept: $keptHostTotal, removed: $removedHostTotal"

# ---------------------------------------------------------------- 3. pin and audit scripts
function Get-PinnedName([string]$Url) {
    $u = [uri]$Url
    $seg = $u.AbsolutePath.Trim('/') -split '/'
    if ($u.Host -eq 'raw.githubusercontent.com' -and $seg.Count -ge 4) {
        # owner/repo/<ref>/path  or  owner/repo/refs/heads/<ref>/path
        $rest = if ($seg[2] -eq 'refs' -and $seg.Count -ge 6) { $seg[5..($seg.Count - 1)] } else { $seg[3..($seg.Count - 1)] }
        $name = "$($seg[0])__$($seg[1])__" + ($rest -join '__')
    } elseif ($u.Host -eq 'github.com' -and $seg.Count -ge 5 -and $seg[2] -in @('raw', 'blob')) {
        $name = "$($seg[0])__$($seg[1])__" + ($seg[4..($seg.Count - 1)] -join '__')
    } else {
        $name = $u.Host + '__' + ($seg -join '__')
    }
    $name = $name -replace '[^A-Za-z0-9._-]', '_'
    if ($name -notmatch '\.js$') { $name += '.js' }
    return $name
}

$riskApis = [ordered]@{
    'httpClient' = '\$httpClient'
    'task.fetch' = '\$task\s*\.\s*fetch'
    'fetch()'    = '(?<![\w$.])fetch\s*\('
    'XHR'        = 'XMLHttpRequest'
    'eval'       = '(?<![\w$.])eval\s*\('
    'Function()' = 'new\s+Function\s*\('
}

$scriptUrls = $kept | Select-String 'script-path\s*=\s*([^,\s]+)' -AllMatches |
    ForEach-Object { $_.Matches } | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique
Write-Host "Scripts referenced: $($scriptUrls.Count)"

if (Test-Path $JsDir) { Get-ChildItem $JsDir -File | Remove-Item }
else { New-Item -ItemType Directory -Path $JsDir | Out-Null }

$pinMap = @{}      # upstream url -> pinned url, or $null when the script lines must be disabled
$audit = New-Object System.Collections.Generic.List[object]
foreach ($url in $scriptUrls) {
    $name = Get-PinnedName $url
    $entry = [ordered]@{ Name = $name; Url = $url; Size = 0; Flags = @(); Status = '' }
    try {
        $code = Get-Utf8 $url
    } catch {
        $entry.Status = 'DISABLED (download failed)'
        $pinMap[$url] = $null
        $audit.Add([pscustomobject]$entry)
        continue
    }
    $sha = [BitConverter]::ToString(
        [Security.Cryptography.SHA256]::Create().ComputeHash([Text.Encoding]::UTF8.GetBytes($code))) -replace '-', ''
    $entry.Size = $code.Length
    $flags = @()
    foreach ($k in $riskApis.Keys) { if ($code -match $riskApis[$k]) { $flags += $k } }
    $entry.Flags = $flags

    $status = 'pinned'
    if ($flags.Count -gt 0) {
        $rev = $ReviewedScripts[$name]
        if (-not $rev) { $status = 'DISABLED (network/eval API, not reviewed)' }
        elseif ($rev.Sha256 -ne $sha) { $status = "DISABLED (changed since review, sha256 $sha)" }
        else { $status = 'pinned (reviewed)' }
    }
    if ($status -like 'pinned*' -and $JsPatches[$name]) {
        foreach ($jp in $JsPatches[$name]) {
            if ($code -notmatch $jp.Regex) { $status = "DISABLED (patch '$($jp.Name)' did not match)"; break }
            $code = [regex]::Replace($code, $jp.Regex, $jp.Replace)
            $status += ", patched: $($jp.Name)"
        }
    }
    $entry.Status = $status
    if ($status -like 'pinned*') {
        [IO.File]::WriteAllText((Join-Path $JsDir $name), $code, $utf8NoBom)
        $pinMap[$url] = "$RepoRawBase/js/$name"
    } else {
        $pinMap[$url] = $null
    }
    $audit.Add([pscustomobject]$entry)
}

$disabledLines = 0
for ($i = 0; $i -lt $kept.Count; $i++) {
    $line = $kept[$i]
    if ($line -match '^\s*#' -or $line -notmatch 'script-path\s*=\s*([^,\s]+)') { continue }
    $src = $Matches[1]
    $dst = $pinMap[$src]
    if ($null -eq $dst) {
        $kept[$i] = '# [disabled by sync-modules.ps1] ' + $line
        $disabledLines++
    } else {
        $kept[$i] = $line.Replace($src, $dst)
    }
}
$pinned = @($audit | Where-Object { $_.Status -like 'pinned*' }).Count
Write-Host "Scripts pinned: $pinned, disabled: $($audit.Count - $pinned) ($disabledLines module line(s) commented out)"

# ---------------------------------------------------------------- 4. metadata and output
for ($i = 0; $i -lt $kept.Count; $i++) {
    # Kept ASCII: PowerShell 5.1 reads BOM-less scripts as ANSI.
    if ($kept[$i] -match '^#!name=') { $kept[$i] = '#!name=AdBlock (fmz200, hardened)' }
    # Point any self-update metadata at this repo, never at upstream.
    if ($kept[$i] -match '^#!raw-url=') { $kept[$i] = "#!raw-url=$RepoRawBase/modules/blockAds.trimmed.sgmodule" }
}
$mode = if ($KeepShoppingGatewayMitm) { 'shopping gateways decrypted' } else { 'shopping gateways NOT decrypted' }
$header = "# Generated by scripts/sync-modules.ps1 on $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') from $UpstreamUrl ($mode)"
$insertAt = 0
while ($insertAt -lt $kept.Count -and $kept[$insertAt] -match '^#!') { $insertAt++ }
$kept.Insert($insertAt, $header)

$outDir = Split-Path -Parent $OutFile
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }
[IO.File]::WriteAllText($OutFile, ($kept -join "`n"), $utf8NoBom)
Write-Host "Wrote $OutFile ($($kept.Count) lines)"

# ---------------------------------------------------------------- 5. audit report
$md = New-Object System.Collections.Generic.List[string]
$md.Add('# Module audit')
$md.Add('')
$md.Add("Generated $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') from $UpstreamUrl. Mode: $mode.")
$md.Add('')
$md.Add("MITM hosts kept: $keptHostTotal. Removed: $removedHostTotal.")
$md.Add('')
$md.Add('## MITM hosts removed')
$md.Add('')
foreach ($k in $hostReport.Keys) {
    if ($hostReport[$k].Count -eq 0) { continue }
    $md.Add("- **$k** ($($hostReport[$k].Count)): " + (($hostReport[$k] | Sort-Object) -join ', '))
}
$md.Add('')
$md.Add('## Scripts')
$md.Add('')
$md.Add('Flags list APIs that can send data off the device or run dynamic code. Flagged scripts are disabled unless listed in $ReviewedScripts with the SHA-256 of the reviewed upstream content. Disabled scripts are not stored in js/.')
$md.Add('')
foreach ($k in ($ReviewedScripts.Keys | Sort-Object)) { $md.Add("- Reviewed ``$k``: $($ReviewedScripts[$k].Reason)") }
$md.Add('')
$md.Add('| Status | File | Flags | Size | Upstream |')
$md.Add('|---|---|---|---|---|')
foreach ($a in ($audit | Sort-Object Status, Name)) {
    $md.Add("| $($a.Status) | $($a.Name) | $(($a.Flags) -join ', ') | $($a.Size) | $($a.Url) |")
}
[IO.File]::WriteAllText((Join-Path $JsDir 'AUDIT.md'), ($md -join "`n"), $utf8NoBom)
Write-Host "Wrote js\AUDIT.md"
