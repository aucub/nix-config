{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  programs.chromium.commandLineArgs = [
    "--process-per-site"
    "--disable-reading-from-canvas"
    "--disable-breakpad"
    "--disable-crash-reporter"
    "--no-default-browser-check"
    "--webview-force-disable-3pcs"
    "--disable-gpu-driver-bug-workarounds"
    "--enable-gpu-rasterization"
    "--enable-zero-copy"
    "--use-angle=vulkan"
    "--use-gl=egl"
    "--use-cmd-decoder=passthrough"
    "--enable-wayland-ime"
    "--enable-quic"
    "--enable-smooth-scrolling"
    "--enable-webrtc-pipewire-capturer"
    "--disable-features=UseChromeOSDirectVideoDecoder,UseSkiaRenderer"
    "--enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoEncoder,VaapiVideoDecoder,VaapiIgnoreDriverChecks,TouchpadOverscrollHistoryNavigation,CanvasOopRasterization,OverlayScrollbar,ParallelDownloading,SystemNotifications,Vulkan,WebContentsCaptureHiDPI,FluentScrollbar,FluentOverlayScrollbar,WebRtcHideLocalIpsWithMdns,ChromeRefresh2023,ChromeRefresh2023NTB:Variation/GM3NewIconNoBackground,ChromeRefresh2023TopChromeFont,ChromeWebuiRefresh2023,GlobalMediaControlsUpdatedUI,NtpRealboxCr23All,NtpRealboxCr23ConsistentRowHeight,NtpRealboxCr23ExpandedStateIcons,NtpRealboxCr23ExpandedStateLayout,NtpRealboxCr23HoverFillShape,NtpRealboxCr23Theming"
    # "--ozone-platform=wayland"
    # "--gtk-version=4"
    # "--ozone-platform-hint=auto"
    "--top-chrome-touch-ui=enabled"
  ];
}
