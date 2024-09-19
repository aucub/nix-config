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
      "--enable-gpu-rasterization"
      "--enable-zero-copy"
      "--ignore-gpu-blocklist"
      "--use-cmd-decoder=passthrough"
      "--enable-quic"
      "--enable-smooth-scrolling"
      "--enable-webrtc-pipewire-capturer"
      "--disable-features=ChromeLabs,LensOverlay,ShowSuggestionsOnAutofocus"
      "--enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoEncoder,VaapiVideoDecoder,CanvasOopRasterization,OverlayScrollbar,ParallelDownloading,WebContentsCaptureHiDPI,WebRtcHideLocalIpsWithMdns,FluentOverlayScrollbar,FluentScrollbar,UseGpuSchedulerDfs"
      "--ozone-platform-hint=auto"
      "--enable-wayland-ime"
      "--wayland-text-input-version=3"
    ];
  };
}
