{ ... }:
{
  programs.chromium = {
    enable = true;
    commandLineArgs = [
      "--process-per-site"
      "--disable-reading-from-canvas"
      "--disable-breakpad"
      "--disable-crash-reporter"
      "--no-default-browser-check"
      "--disable-gpu-driver-bug-workarounds"
      "--enable-gpu-rasterization"
      "--enable-zero-copy"
      "--ignore-gpu-blocklist"
      "--use-cmd-decoder=passthrough"
      "--enable-wayland-ime"
      "--enable-quic"
      "--enable-smooth-scrolling"
      "--enable-webrtc-pipewire-capturer"
      "--disable-features=UseChromeOSDirectVideoDecoder,UseSkiaRenderer,ChromeLabs"
      "--enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoEncoder,VaapiVideoDecoder,VaapiIgnoreDriverChecks,TouchpadOverscrollHistoryNavigation,CanvasOopRasterization,OverlayScrollbar,ParallelDownloading,SystemNotifications,Vulkan,DefaultANGLEVulkan,VulkanFromANGLE,WebContentsCaptureHiDPI,WebRtcHideLocalIpsWithMdns"
    ];
  };
}
