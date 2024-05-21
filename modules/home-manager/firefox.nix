{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: {
  programs.firefox = {
    enable = true;
    profiles.default = {
      id = 0;
      isDefault = true;
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        floccus
        bitwarden
        violentmonkey
        videospeed
        user-agent-string-switcher
        immersive-translate
        # single-file
      ];
      settings = {
        # 启用 VAAPI 硬件加速
        "media.ffmpeg.vaapi.enabled" = true;
        # 禁用 FFVpx
        "media.ffvpx.enabled" = false;
        # 启用 WebRender
        "gfx.webrender.all" = true;
        # 禁用电池指纹识别
        "dom.battery.enabled" = false;
        # 启用追踪保护
        "privacy.trackingprotection.enabled" = true;
        # 禁用安全浏览
        "browser.safebrowsing.malware.enabled" = false;
        "browser.safebrowsing.phishing.enabled" = false;
        "browser.safebrowsing.downloads.enabled" = false;
        # 禁用保存密码
        "signon.rememberSignons" = false;
        # 设置 referer 策略为 0
        "network.http.referer.XOriginPolicy" = 0;
        # 启用搜索建议
        "browser.search.suggest.enabled" = true;
        "browser.urlbar.suggest.searches" = true;
        # 设置浏览器地区
        "browser.search.region" = "CN";

        # user.js 转换部分
        # 禁用 about:config 警告
        "browser.aboutConfig.showWarning" = false;

        # 启动设置
        # 设置启动页为主页
        "browser.startup.page" = 1;
        # 设置主页和新窗口页
        "browser.startup.homepage" = "about:home";
        # 设置新标签页为启用
        "browser.newtabpage.enabled" = true;
        # 禁用 Firefox 主页上的赞助内容
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = true;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
        # 清除默认的热门网站
        "browser.newtabpage.activity-stream.default.sites" = "";

        # 更安静的 Fox
        # 禁用 about:addons 中的推荐面板
        "extensions.getAddons.showPane" = false;
        # 禁用 about:addons 中的扩展和主题面板中的推荐
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        # 禁用 about:addons 和 AMO 中的个性化扩展推荐
        "browser.discovery.enabled" = false;
        # 禁用购物体验
        "browser.shopping.experience2023.enabled" = false;

        # 遥测设置
        # 禁用新数据提交
        "datareporting.policy.dataSubmissionEnabled" = false;
        # 禁用健康报告上传
        "datareporting.healthreport.uploadEnabled" = false;
        # 禁用遥测
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.server" = "data:,";
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        # 禁用 Telemetry Coverage
        "toolkit.telemetry.coverage.opt-out" = true;
        "toolkit.coverage.opt-out" = true;
        "toolkit.coverage.endpoint.base" = "";
        # 禁用 PingCentre 遥测
        "browser.ping-centre.telemetry" = false;
        # 禁用 Firefox Home 遥测
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;

        # Studies 设置
        # 禁用 Studies
        "app.shield.optoutstudies.enabled" = false;
        # 禁用 Normandy/Shield
        "app.normandy.enabled" = false;
        "app.normandy.api_url" = "";

        # 崩溃报告设置
        # 禁用崩溃报告
        "breakpad.reportURL" = "";
        "browser.tabs.crashReporting.sendReport" = false;
        "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;

        # 其他设置
        # 禁用 Captive Portal 检测
        "captivedetect.canonicalURL" = "";
        "network.captive-portal-service.enabled" = false;
        # 禁用网络连接检查
        "network.connectivity-service.enabled" = false;

        # 阻止隐式出站连接设置
        # 禁用链接预取
        "network.prefetch-next" = false;
        # 禁用 DNS 预取
        "network.dns.disablePrefetch" = true;
        # 禁用预测器/预取
        "network.predictor.enabled" = false;
        "network.predictor.enable-prefetch" = false;
        # 禁用通过链接的鼠标悬停打开到链接服务器的连接
        "network.http.speculative-parallel-limit" = 0;
        # 禁用书签和历史记录上的鼠标按下推测性连接
        "browser.places.speculativeConnect.enabled" = false;

        # 密码设置
        # 禁用自动填充用户名和密码表单字段
        "signon.autofillForms" = false;
        # 限制（或禁用）由子资源触发的 HTTP 认证凭据对话框
        "network.auth.subresource-http-auth-allow" = 1;

        # HTTPS (SSL/TLS / OCSP / CERTS / HPKP)
        # 要求安全协商
        "security.ssl.require_safe_negotiation" = true;
        # 禁用 TLS1.3 0-RTT
        "security.tls.enable_0rtt_data" = false;

        # OCSP (在线证书状态协议) 设置
        # 强制执行 OCSP 获取以确认证书的当前有效性
        "security.OCSP.enabled" = 1;
        # 将 OCSP 获取失败设置为硬失败
        "security.OCSP.require" = false;

        # 证书设置
        # 启用严格的 PKP
        "security.cert_pinning.enforcement_level" = 2;
        # 启用 CRLite
        "security.remote_settings.crlite_filters.enabled" = true;
        "security.pki.crlite_mode" = 2;

        # 混合内容设置
        # 在所有窗口中启用 HTTPS-Only 模式
        "dom.security.https_only_mode" = true;
        # 禁用 HTTP 后台请求
        "dom.security.https_only_mode_send_http_background_request" = false;

        # UI 设置
        # 在挂锁上显示“安全性受损”的警告
        "security.ssl.treat_unsafe_negotiation_as_broken" = true;
        # 在不安全连接警告页面上显示高级信息
        "browser.xul.error_pages.expert_bad_cert" = true;

        # 引荐者设置
        # 控制要发送的跨源信息的数量
        "network.http.referer.XOriginTrimmingPolicy" = 2;

        # 插件/媒体/WebRTC 设置
        # 强制 WebRTC 在代理内部使用
        "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
        # 强制 ICE 候选项生成使用单一网络接口
        "media.peerconnection.ice.default_address_only" = true;

        # DOM 设置
        # 防止脚本移动和调整打开的窗口
        "dom.disable_window_move_resize" = true;

        # 杂项设置
        # 禁用 UITour 后端
        "browser.uitour.enabled" = false;
        # 重置远程调试为禁用状态
        "devtools.debugger.remote-enabled" = false;
      };
    };
  };
}
