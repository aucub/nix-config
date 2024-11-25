{ pkgs, ... }:
{
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
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
      "--use-vulkan"
      "--enable-smooth-scrolling"
      "--enable-webrtc-pipewire-capturer"
      "--disable-features=ChromeLabs,LensOverlay,ShowSuggestionsOnAutofocus"
      "--enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoEncoder,VaapiVideoDecoder,VaapiIgnoreDriverChecks,CanvasOopRasterization,ParallelDownloading,WebContentsCaptureHiDPI,WebRtcHideLocalIpsWithMdns,FluentOverlayScrollbar,UseGpuSchedulerDfs,BackForwardCache,FontationsFontBackend,GlobalMediaControlsUpdatedUI,WebRtcPipeWireCamera,OverlayScrollbar,WebRTCPipeWireCapturer,UseOzonePlatform,WaylandWindowDecorations,Vulkan,DefaultANGLEVulkan,VulkanFromANGLE"
      "--ozone-platform-hint=auto"
      "--enable-wayland-ime"
      "--wayland-text-input-version=3"
      "--disable-gpu-memory-buffer-video-frames" # Wayland hardware acceleration buffer handle is null errors
    ];
  };
}
