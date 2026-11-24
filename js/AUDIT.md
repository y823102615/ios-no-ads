# Module audit

Generated 2026-11-24 16:57:54 from https://raw.githubusercontent.com/fmz200/wool_scripts/main/Shadowrocket/module/blockAds.srmodule. Mode: shopping gateways NOT decrypted.

MITM hosts kept: 818. Removed: 146.

## MITM hosts removed

- **bank** (48): cdn.jlbank.com.cn, cdn.sdb.com.cn, cdnmobibank.bankofbeijing.com.cn, cdn-xyk-app.bankofbeijing.com.cn, cgbank.oss-cn-shenzhen.aliyuncs.com, creditcard.bankcomm.cn, creditcard.bankcomm.com, creditcardapp.bankcomm.cn, creditcardapp.bankcomm.com, d.psbc.com, direct.z-bank.com, elife.icbc.com.cn, enjoy.cdn-static.abchina.com, file.cibfintech.com, image.spdbccc.com.cn, imcs.citicbank.com, intellicc.bas.cmbchina.com, intellicc.bcs.cmbchina.com, lban.spdb.com.cn, m.creditcard.ecitic.com, mbank.grcbank.com, mbank5.jsbchina.cn, mbasecc.bas.cmbchina.com, mbasecc.bcs.cmbchina.com, mbmodule-openapi.paas.cmbchina.com, mcc.psbc.com, midc.cdn-static.abchina.com.cn, minipro.95504.net, mlife.jf365.boc.cn, mobile.cebbank.com, mps.95508.com, mres.aibank.com, openapi.boc.cn, pv.elife.icbc.com.cn, rs.creditcard.cmbc.com.cn, sichuan.95504.net, static.95508.com, static.creditcard.hxb.com.cn, static.mobile-bank.psbc.com, static.psbc.com, ump.sz.creditcard.ecitic.com, v.icbc.com.cn, wap.bank.ecitic.com, wap.spdb.com.cn, webappcfg.paas.cmbchina.com, www.cmbc.com.cn, yghsh.cebbank.com, yunbusiness.ccb.com
- **payment** (17): ad.ysepay.com, ads.ysepay.com, api-pay.soulapp.cn, app.95598pay.com, audiobookpay.kuwo.cn, ccmsupport-sz.tenpay.com, gmp.lakala.com, m.qianbao.qq.com, mapi-app.bestpay.com.cn, mcsp.cloudpnr.com, mobile.1qianbao.com, mpos-pic.helipay.com, musicpay.kuwo.cn, promote-trx.helipay.com, qianbao.smzdm.com, saas-ad.cloudpnr.com, wallet.lakala.com
- **finance** (26): adm.10jqka.com.cn, api*.futunn.com, api.51credit.com, api.jr.mi.com, api.touker.com, api.u51.com, api.winbull8.com, app.chinahxzq.com.cn, appactive.1234567.com.cn, dl*.app.gtja.com, dl.app.gtja.com, fintechappdr.cgws.com, geetest.htsc.com, hz.yxzq.com, interface.hstong.com, j5.dfcfw.com, live.inst-service.htsc.com, m.prod.app.hsbcfts.com.cn, marketing.cmschina.com, ms.jr.jd.com, pacdn.m.stock.pingan.com, stat.10jqka.com.cn, static.xyzq.cn, stock.xueqiu.com, www.binance.com, www.binance.info
- **insurance** (7): ecloud.tppension.cntaiping.com, ecssmobile.e-chinalife.com, e-static.aia.com.cn, hcz-member.pingan.com.cn, iobs.pingan.com.cn, operationapi.fosunhanig.com, zgrb.epicc.com.cn
- **wechat/qq-sec** (5): mp.weixin.qq.com, security.wechat.com, wechat.tf.cn, weixin110.qq.com, wxs-weixin.sd.zhumanggroup.com
- **account/login** (2): api-account.soulapp.cn, sso.ifanr.com
- **gov/telecom** (19): ad.mcloud.139.com, api.cloud.189.cn, app.10086.cn, app.10099.com.cn, app-izz.zhengzhou.gov.cn, client.app.coc.10086.cn, cloud.189.cn, fuwu.nhsa.gov.cn, gab.122.gov.cn, m.client.10010.com, m1.ad.10010.com, mcmm.caiyun.feixin.10086.cn, middle.yun.139.com, mrp.mcloud.139.com, portal.zjzwfw.gov.cn, res.mall.10010.cn, szdmobile.suzhou.gov.cn, tfsmy.chengdu.gov.cn, zt-app.go189.cn
- **medical** (5): app.wy.guahao.com, dq.dxy.cn, dxy.com, kano.guahao.cn, patient-api.suh.cn
- **malformed** (3): cupid.51job*.comhostname, res1.hubcloud.com.cnhostname, sdk.alibaba.com.ailbaba.me
- **shopping-gateway** (14): acs.m.goofish.com, acs.m.taobao.com, acs.youku.com, acs-m.freshippo.com, amdc.m.taobao.com, api.m.jd.com, api.m.mi.com, api.pinduoduo.com, api.yangkeduo.com, cn-acs.m.cainiao.com, g-acs.m.goofish.com, guide-acs.m.taobao.com, mobile.yangkeduo.com, un-acs.youku.com

## Scripts

Flags list APIs that can send data off the device or run dynamic code. Flagged scripts are disabled unless listed in $ReviewedScripts with the SHA-256 of the reviewed upstream content. Disabled scripts are not stored in js/.

- Reviewed `kokoryh__Sparkle__dist__bilibili.json.js`: $httpClient only appears in the shared env wrapper; fetch() is never called.
- Reviewed `kokoryh__Sparkle__dist__bilibili.protobuf.response.js`: fetch() is never called. SponsorBlock gate is patched off (see $JsPatches) so the player package (chronos) is never redirected to a third-party zip.

| Status | File | Flags | Size | Upstream |
|---|---|---|---|---|
| DISABLED (network/eval API, not reviewed) | fmz200__wool_scripts__Scripts__baidumap.js | XHR, eval | 80146 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/baidumap.js |
| DISABLED (network/eval API, not reviewed) | fmz200__wool_scripts__Scripts__meiyou__meiyou_ads.js | httpClient, task.fetch | 13643 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/meiyou/meiyou_ads.js |
| DISABLED (network/eval API, not reviewed) | fmz200__wool_scripts__Scripts__miguvideo__miguvideo_ads.js | httpClient, task.fetch | 13117 | https://raw.githubusercontent.com/fmz200/wool_scripts/refs/heads/main/Scripts/miguvideo/miguvideo_ads.js |
| DISABLED (network/eval API, not reviewed) | fmz200__wool_scripts__Scripts__rrtv_json.js | httpClient, task.fetch, XHR | 25566 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/rrtv_json.js |
| DISABLED (network/eval API, not reviewed) | fmz200__wool_scripts__Scripts__soul__soul_ads.js | httpClient, task.fetch | 14875 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/soul/soul_ads.js |
| DISABLED (network/eval API, not reviewed) | fmz200__wool_scripts__Scripts__xiaohongshu__xiaohongshu.js | httpClient, task.fetch | 27135 | https://github.com/fmz200/wool_scripts/raw/main/Scripts/xiaohongshu/xiaohongshu.js |
| DISABLED (network/eval API, not reviewed) | kokoryh__Sparkle__dist__bilibili.protobuf.request.js | httpClient, fetch() | 76924 | https://raw.githubusercontent.com/kokoryh/Sparkle/refs/heads/master/dist/bilibili.protobuf.request.js |
| DISABLED (network/eval API, not reviewed) | Maasea__sgmodule__Script__Youtube__youtube.response.js | httpClient, task.fetch, fetch() | 132973 | https://raw.githubusercontent.com/Maasea/sgmodule/refs/heads/master/Script/Youtube/youtube.response.js |
| DISABLED (network/eval API, not reviewed) | NobyDa__Script__Bahamut__BahamutAnimeAds.js | httpClient, task.fetch | 1716 | https://raw.githubusercontent.com/NobyDa/Script/master/Bahamut/BahamutAnimeAds.js |
| DISABLED (network/eval API, not reviewed) | zZPiglet__Task__asset__UnblockURLinWeChat.js | httpClient, task.fetch | 79529 | https://raw.githubusercontent.com/zZPiglet/Task/master/asset/UnblockURLinWeChat.js |
| pinned | app2smile__rules__js__adsense.js |  | 2072 | https://raw.githubusercontent.com/app2smile/rules/master/js/adsense.js |
| pinned | app2smile__rules__js__qq-news.js |  | 2059 | https://raw.githubusercontent.com/app2smile/rules/master/js/qq-news.js |
| pinned | app2smile__rules__js__tieba-json.js |  | 9173 | https://raw.githubusercontent.com/app2smile/rules/master/js/tieba-json.js |
| pinned | app2smile__rules__js__tieba-proto.js |  | 96737 | https://raw.githubusercontent.com/app2smile/rules/master/js/tieba-proto.js |
| pinned | app2smile__rules__js__vgtime.js |  | 274 | https://raw.githubusercontent.com/app2smile/rules/master/js/vgtime.js |
| pinned | fmz200__wool_scripts__Scripts__51card.js |  | 478 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/51card.js |
| pinned | fmz200__wool_scripts__Scripts__555Ad.js |  | 310 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/555Ad.js |
| pinned | fmz200__wool_scripts__Scripts__adrive__adrive.js |  | 1049 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/adrive/adrive.js |
| pinned | fmz200__wool_scripts__Scripts__blued.js |  | 246 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/blued.js |
| pinned | fmz200__wool_scripts__Scripts__bohe__bohe_ads.js |  | 870 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/bohe/bohe_ads.js |
| pinned | fmz200__wool_scripts__Scripts__cainiao__cainiao.js |  | 4449 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/cainiao/cainiao.js |
| pinned | fmz200__wool_scripts__Scripts__caixin__caixinAd.js |  | 1706 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/caixin/caixinAd.js |
| pinned | fmz200__wool_scripts__Scripts__ccbLife__ccbLifeAds.js |  | 656 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/ccbLife/ccbLifeAds.js |
| pinned | fmz200__wool_scripts__Scripts__cmschina__cmschina.js |  | 348 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/cmschina/cmschina.js |
| pinned | fmz200__wool_scripts__Scripts__cnftp.js |  | 28454 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/cnftp.js |
| pinned | fmz200__wool_scripts__Scripts__coolapk.js |  | 2393 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/coolapk.js |
| pinned | fmz200__wool_scripts__Scripts__dianyinglieshou.js |  | 999 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/dianyinglieshou.js |
| pinned | fmz200__wool_scripts__Scripts__didi__didiAds.js |  | 2641 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/didi/didiAds.js |
| pinned | fmz200__wool_scripts__Scripts__fenbi.js |  | 814 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/fenbi.js |
| pinned | fmz200__wool_scripts__Scripts__fly.js |  | 488 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/fly.js |
| pinned | fmz200__wool_scripts__Scripts__header.js |  | 2715 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/header.js |
| pinned | fmz200__wool_scripts__Scripts__huifutianxia_ads.js |  | 314 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/huifutianxia_ads.js |
| pinned | fmz200__wool_scripts__Scripts__ithome__ithome.js |  | 1283 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/ithome/ithome.js |
| pinned | fmz200__wool_scripts__Scripts__jingdong__jingdong.js |  | 9379 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/jingdong/jingdong.js |
| pinned | fmz200__wool_scripts__Scripts__jingxiAd.js |  | 281 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/jingxiAd.js |
| pinned | fmz200__wool_scripts__Scripts__keep.js |  | 12218 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/keep.js |
| pinned | fmz200__wool_scripts__Scripts__kuwo__kuwo.js |  | 4632 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/kuwo/kuwo.js |
| pinned | fmz200__wool_scripts__Scripts__lawson.js |  | 1553 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/lawson.js |
| pinned | fmz200__wool_scripts__Scripts__lvtusuishenting__ltsst-ad.js |  | 771 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/lvtusuishenting/ltsst-ad.js |
| pinned | fmz200__wool_scripts__Scripts__maimai__maimai_ads.js |  | 801 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/maimai/maimai_ads.js |
| pinned | fmz200__wool_scripts__Scripts__mlxx__mlxx.js |  | 2177 | https://github.com/fmz200/wool_scripts/raw/main/Scripts/mlxx/mlxx.js |
| pinned | fmz200__wool_scripts__Scripts__myBlockAds.js |  | 7220 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/myBlockAds.js |
| pinned | fmz200__wool_scripts__Scripts__PupuSplashAds.js |  | 1695 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/PupuSplashAds.js |
| pinned | fmz200__wool_scripts__Scripts__quark.js |  | 14279 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/quark.js |
| pinned | fmz200__wool_scripts__Scripts__QuDa.js |  | 251 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/QuDa.js |
| pinned | fmz200__wool_scripts__Scripts__reddit.js |  | 726 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/reddit.js |
| pinned | fmz200__wool_scripts__Scripts__smzdm__Smzdm.js |  | 3214 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/smzdm/Smzdm.js |
| pinned | fmz200__wool_scripts__Scripts__smzdm__smzdm_ads.js |  | 1090 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/smzdm/smzdm_ads.js |
| pinned | fmz200__wool_scripts__Scripts__soda.js |  | 220 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/soda.js |
| pinned | fmz200__wool_scripts__Scripts__template__req_replace_body.js |  | 311 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/template/req_replace_body.js |
| pinned | fmz200__wool_scripts__Scripts__umetrip__umetrip_ads.js |  | 207 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/umetrip/umetrip_ads.js |
| pinned | fmz200__wool_scripts__Scripts__xiaotucc.js |  | 340 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/xiaotucc.js |
| pinned | fmz200__wool_scripts__Scripts__youdao__dict-youdao-ad.js |  | 1084 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/youdao/dict-youdao-ad.js |
| pinned | fmz200__wool_scripts__Scripts__yx.js |  | 130 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/yx.js |
| pinned | fmz200__wool_scripts__Scripts__zhangshanggongjiao.js |  | 528 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/zhangshanggongjiao.js |
| pinned | fmz200__wool_scripts__Scripts__zhihu__zhihu.js |  | 7054 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/zhihu/zhihu.js |
| pinned | fmz200__wool_scripts__Scripts__zhuanzhuan__zhuanzhuan.js |  | 852 | https://raw.githubusercontent.com/fmz200/wool_scripts/main/Scripts/zhuanzhuan/zhuanzhuan.js |
| pinned | ishowshu__qx__script__goofish.js |  | 7134 | https://raw.githubusercontent.com/ishowshu/qx/refs/heads/main/script/goofish.js |
| pinned | Keywos__rule__script__wy__js__wyres.js |  | 17300 | https://raw.githubusercontent.com/Keywos/rule/main/script/wy/js/wyres.js |
| pinned | kokoryh__Script__js__12306.js |  | 347 | https://raw.githubusercontent.com/kokoryh/Script/master/js/12306.js |
| pinned | Sliverkiss__QuantumultX__AdBlock__xmApp__wnbz.js |  | 590 | https://raw.githubusercontent.com/Sliverkiss/QuantumultX/main/AdBlock/xmApp/wnbz.js |
| pinned | Sliverkiss__QuantumultX__AdBlock__xmApp__xmApp.js |  | 340 | https://raw.githubusercontent.com/Sliverkiss/QuantumultX/main/AdBlock/xmApp/xmApp.js |
| pinned | VenenoSix24__Ivy-Script__Loon__script__Coolapk_Redirect.js |  | 369 | https://raw.githubusercontent.com/VenenoSix24/Ivy-Script/refs/heads/main/Loon/script/Coolapk_Redirect.js |
| pinned | zirawell__R-Store__Res__Scripts__AntiAd__airchina.js |  | 784 | https://raw.githubusercontent.com/zirawell/R-Store/main/Res/Scripts/AntiAd/airchina.js |
| pinned | zirawell__R-Store__Res__Scripts__AntiAd__alicdn.js |  | 588 | https://raw.githubusercontent.com/zirawell/R-Store/main/Res/Scripts/AntiAd/alicdn.js |
| pinned | zirawell__R-Store__Res__Scripts__AntiAd__bilibiliManga.js |  | 2123 | https://raw.githubusercontent.com/zirawell/R-Store/main/Res/Scripts/AntiAd/bilibiliManga.js |
| pinned | zirawell__R-Store__Res__Scripts__AntiAd__ddxq.js |  | 1712 | https://raw.githubusercontent.com/zirawell/R-Store/main/Res/Scripts/AntiAd/ddxq.js |
| pinned | zirawell__R-Store__Res__Scripts__AntiAd__dianping.js |  | 2241 | https://raw.githubusercontent.com/zirawell/R-Store/main/Res/Scripts/AntiAd/dianping.js |
| pinned | zirawell__R-Store__Res__Scripts__AntiAd__flyert.js |  | 834 | https://raw.githubusercontent.com/zirawell/R-Store/main/Res/Scripts/AntiAd/flyert.js |
| pinned | zirawell__R-Store__Res__Scripts__AntiAd__foliday.js |  | 942 | https://raw.githubusercontent.com/zirawell/R-Store/main/Res/Scripts/AntiAd/foliday.js |
| pinned | zirawell__R-Store__Res__Scripts__AntiAd__freshippo.js |  | 1976 | https://raw.githubusercontent.com/zirawell/R-Store/main/Res/Scripts/AntiAd/freshippo.js |
| pinned | zirawell__R-Store__Res__Scripts__AntiAd__mafengwo.js |  | 1010 | https://raw.githubusercontent.com/zirawell/R-Store/main/Res/Scripts/AntiAd/mafengwo.js |
| pinned | zirawell__R-Store__Res__Scripts__AntiAd__mdb.js |  | 712 | https://raw.githubusercontent.com/zirawell/R-Store/main/Res/Scripts/AntiAd/mdb.js |
| pinned | zirawell__R-Store__Res__Scripts__AntiAd__qmai.js |  | 2020 | https://raw.githubusercontent.com/zirawell/R-Store/main/Res/Scripts/AntiAd/qmai.js |
| pinned | zirawell__R-Store__Res__Scripts__AntiAd__tuhu.js |  | 2356 | https://raw.githubusercontent.com/zirawell/R-Store/main/Res/Scripts/AntiAd/tuhu.js |
| pinned | zirawell__R-Store__Res__Scripts__AntiAd__usmile.js |  | 727 | https://raw.githubusercontent.com/zirawell/R-Store/main/Res/Scripts/AntiAd/usmile.js |
| pinned (reviewed) | kokoryh__Sparkle__dist__bilibili.json.js | httpClient, fetch() | 19346 | https://raw.githubusercontent.com/kokoryh/Sparkle/refs/heads/master/dist/bilibili.json.js |
| pinned (reviewed), patched: disable SponsorBlock/chronos gate | kokoryh__Sparkle__dist__bilibili.protobuf.response.js | httpClient, fetch() | 103844 | https://raw.githubusercontent.com/kokoryh/Sparkle/refs/heads/master/dist/bilibili.protobuf.response.js |