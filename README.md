# ios-no-ads

个人自用的 iOS 去广告配置。工具：Shadowrocket（MITM + 规则）+ 过滤型 DoH，Safari 另加内容拦截器。

## 文件

| 文件 | 用途 | 手机上怎么用 |
|---|---|---|
| `noads.conf` | 主配置：DoH、QUIC 阻断、广告域名规则集、MITM 开关 | 「配置」页 `+` 填 raw 地址，选中后“使用配置” |
| `modules/blockAds.trimmed.sgmodule` | App 去广告模块，由脚本从 fmz200 生成并加固 | 「配置 → 模块」`+` 填 raw 地址 |
| `js/*.js` | 模块用到的脚本，固定在本仓库 | 模块自动加载，不用手动添加 |
| `js/AUDIT.md` | 每次同步的审计报告：移除了哪些解密域名、哪些脚本被停用 | 看一眼即可 |
| `scripts/sync-modules.ps1` | 拉取上游模块、加固、固定脚本 | 在电脑上运行 |

模块上游：[fmz200/wool_scripts blockAds.srmodule](https://github.com/fmz200/wool_scripts/blob/main/Shadowrocket/module/blockAds.srmodule)，覆盖约 730 款 App，包括 B 站、京东、淘宝、酷安和 Apple 广告域名。

脚本对上游做的修改：
- 删除“安全浏览限制解除”规则。上游会拒绝 Apple、Google、QQ、百度的安全浏览域名，这会关掉 Safari 的欺诈网站警告，和去广告无关。
- 删除 B 站伪造大会员状态的两条改写（`account/mine`、`account/myinfo`）。
- 删除上游夹带的付费功能破解：Spotify 高级版、酷我音乐 VIP 和付费歌曲、51job 会员、某视频 App 的会员播放。这些和去广告无关。
- 补丁一旦匹配不到内容，脚本就报错退出，防止上游改了格式后补丁悄悄失效。

## 安全加固

**1. 敏感域名不解密。** 同步时从模块的 MITM 域名名单里删掉下面这些类别，它们的 HTTPS 流量不会被 Shadowrocket 解密：

| 类别 | 例子 |
|---|---|
| 银行、支付、钱包 | 招行、工行、建行、中行、交行、财付通、翼支付、拉卡拉 |
| 证券、金融、保险、加密货币 | 京东金融、小米金融、同花顺、富途、平安、币安 |
| 微信安全、账号登录 | `mp.weixin.qq.com`、`weixin110.qq.com`、`sso.*` |
| 政务、运营商、医疗 | `*.gov.cn`、10086、10010、天翼云、挂号类 |
| 购物主网关 | 淘宝/闲鱼/优酷 `acs` 网关、`api.m.jd.com`、拼多多、小米商城 |
| 格式错误或仿冒的域名 | `sdk.alibaba.com.ailbaba.me` |

代价：这些 App 只剩域名层拦截。淘宝、京东的开屏广告大多还能挡，首页信息流和弹窗广告会回来。想换回去广告效果：
```powershell
powershell -ExecutionPolicy Bypass -File scripts\sync-modules.ps1 -KeepShoppingGatewayMitm
```
这样做会解密这些购物网关上的登录、订单、地址请求。

**2. 脚本固定在本仓库。** 模块引用的脚本全部下载到 `js/`，模块改成从本仓库加载。上游作者改代码后，要等你运行同步脚本、看过 `git diff` 并提交，手机上才会用到新代码。

**3. 能联网的脚本默认停用。** 脚本里出现 `$httpClient`、`$task.fetch`、`fetch`、`XMLHttpRequest`、`eval`、`new Function` 时，对应的模块行会被注释掉。只有读过代码、登记在 `sync-modules.ps1` 的 `$ReviewedScripts` 里的才保留，而且登记的是内容的 SHA-256，上游一改就重新停用。目前登记的两个：
- `bilibili.json.js`：联网代码只在通用封装里，从未调用。
- `bilibili.protobuf.response.js`：同上。它还有一个“空降助手”功能，会把 B 站播放器的组件包换成作者 GitHub 上的 zip。同步脚本把这个功能的开关改成恒为关闭。

被停用的 `bilibili.protobuf.request.js` 会把你看的视频 ID 发给第三方服务 `bsbsb.top`（SponsorBlock），所以没有放行。B 站的开屏和推荐流广告由不联网的规则和响应改写处理，不受影响。

**这套检查的局限：** 联网 API 扫描是按关键字匹配的，故意混淆的代码可以绕过。真正的保护来自第 2 条：每次更新前看 `git diff`，再决定是否提交。

**使用习惯：**
- 只用 `noads.conf` 连接。不要在开着 HTTPS 解密时切到带陌生节点的配置。
- 登录、付款、改密码前，可以先关掉模块或断开 Shadowrocket，用完再开。

## 首次部署

1. 在电脑上：
   ```powershell
   powershell -ExecutionPolicy Bypass -File scripts\sync-modules.ps1
   git init; git add .; git commit -m "init"
   # 推到你的 GitHub 私有仓库或公开仓库
   ```
   私有仓库的 raw 地址需要 token，Shadowrocket 不方便用。可以改用公开仓库，或者把两个文件放进 secret gist。
2. 在 GitHub 上新建公开仓库 `y823102615/ios-no-ads`，把本目录推上去：
   ```powershell
   git branch -M main
   git remote add origin https://github.com/y823102615/ios-no-ads.git
   git push -u origin main
   ```
   推送后，手机上要填的两个地址：
   - 配置：`https://raw.githubusercontent.com/y823102615/ios-no-ads/main/noads.conf`
   - 模块：`https://raw.githubusercontent.com/y823102615/ios-no-ads/main/modules/blockAds.trimmed.sgmodule`
3. 在手机上按顺序做：
   1. 用外区 Apple ID 下载 Shadowrocket。
   2. 导入 `noads.conf`，首页“全局路由”设为“配置”。
   3. 进入“配置 → ⓘ → HTTPS 解密”：生成 CA 证书，安装，再到“设置 → 通用 → 关于本机 → 证书信任设置”里打开完全信任。最后打开“HTTPS 解密”开关。
   4. 在“配置 → 模块”里添加 `blockAds.trimmed.sgmodule` 的 raw 地址。
   5. 在“设置”里打开“按需连接”。
4. 清理 B 站、京东、淘宝、酷安的缓存，或者卸载重装，然后冷启动验证。

## 系统层面的补充设置

| 项目 | 设置位置 | 效果 |
|---|---|---|
| Apple 个性化广告 | 设置 → 隐私与安全性 → Apple 广告 → 关闭“个性化广告” | 只减少个性化，App Store 广告位仍然会显示 |
| Safari 网页广告 | 安装 AdGuard for iOS（免费版），在“设置 → Safari → 扩展”里启用 | 能隐藏网页元素，这一点是 Shadowrocket 做不到的 |
| 垃圾短信 | 设置 → 信息 → 未知与过滤信息 → 打开“过滤未知发件人”，可再装一个短信过滤 App | 营销短信归入单独列表 |
| App 推送广告 | 设置 → 通知 → 各 App，关闭营销类通知；App 内关闭“活动推荐”类推送 | 推送是 Apple 服务器下发的，代理拦不到 |

## 验证

- **MITM 生效：** 在 Shadowrocket 的“最近请求”里，能看到 `app.bilibili.com`、`api.coolapk.com` 等域名的完整请求路径。`acs.m.taobao.com`、`api.m.jd.com` 默认不解密，看不到路径是正常的。
- **规则命中：** 打开各个 App 时，日志里有 REJECT 记录。
- **DoH 生效：** 用 NextDNS 时，后台能看到这台手机的查询。
- **App 效果：** 每个 App 冷启动 3 次没有开屏广告，信息流里刷 50 条没有广告卡片，支付、登录、播放都正常。

## 排错

| 现象 | 处理 |
|---|---|
| 某个 App 打不开或白屏 | 先关掉模块，确认是不是模块造成的。是的话，在 `scripts/sync-modules.ps1` 里加补丁，删掉这个 App 的 hostname 或规则，重新生成 |
| 酷安卡在启动页 | 有其他模块作者报告：拒绝穿山甲、友盟等 SDK 的初始化域名会让酷安卡死。到日志里找被拒绝的 SDK 域名，在补丁里去掉对应规则 |
| 某个 App 提示网络异常 | 这个 App 可能做了证书绑定，从模块的 hostname 中去掉它的域名 |
| Shadowrocket 频繁断开 | 规则太多，内存不够。在 `noads.conf` 里注释掉 AdvertisingLite |
| 装了系统 DNS 描述文件后规则不再命中 | Shadowrocket 开启时停用描述文件（设置 → 通用 → VPN 与设备管理 → DNS） |

## 维护

- 每 2–4 周运行一次 `sync-modules.ps1`，用 `git diff` 看一下上游改了什么，尤其是 `js/` 下的脚本和 `js/AUDIT.md`，再提交。如果某个已登记的脚本变成 “changed since review”，读过新代码后更新 `$ReviewedScripts` 里的 SHA-256。
- 回滚：关掉 Shadowrocket 开关，所有改动立即失效。要彻底清理，再关闭证书信任并删除描述文件。

## 做不到的部分

- iOS 没有类似安卓 ROM 那样的系统广告。和系统相关的广告主要是 App Store 的搜索广告和推荐位。App Store 是 Apple 自家的 App，用了证书绑定，没法 MITM。屏蔽 Apple 广告域名只能挡掉一部分广告请求和归因统计，广告位本身可能还在。
- 证书绑定的接口、走自定义协议的长连接（淘宝的部分 ACCS/SPDY 通道）、内置在安装包里的素材，代理都处理不了。
- App 改版后，模块要等上游跟进，一般需要几天。
