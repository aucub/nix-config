{
  pkgs,
  config,
  lib,
  ...
}:
{
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
    protontricks.enable = true;
    extest.enable = true;
    gamescopeSession = {
      enable = true;
      env =
        lib.optionalAttrs
          (
            (lib.elem "nvidia" config.services.xserver.videoDrivers)
            && (config.hardware.nvidia.prime.offload.enable)
          )
          {
            __NV_PRIME_RENDER_OFFLOAD = "1";
            __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
            __GLX_VENDOR_LIBRARY_NAME = "nvidia";
            __VK_LAYER_NV_optimus = "NVIDIA_only";
          };
    };
  };
}
