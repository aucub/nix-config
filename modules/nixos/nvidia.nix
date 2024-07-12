{ lib, pkgs, ... }:
{
  services.xserver.videoDrivers = [ "nvidia" ];
  environment.variables = {
    __EGL_VENDOR_LIBRARY_FILENAMES = "${pkgs.mesa.drivers}/share/glvnd/egl_vendor.d/50_mesa.json";
    __GLX_VENDOR_LIBRARY_NAME = "mesa";
  };
  hardware.nvidia = {
    nvidiaSettings = false;
    open = true;
    modesetting.enable = true;
    powerManagement = {
      enable = true;
      finegrained = true;
    };
    prime = {
      amdgpuBusId = lib.mkForce "PCI:5:0:0";
      nvidiaBusId = "PCI:1:0:0";
      # sync.enable = true; # 减少屏幕撕裂,更高的功耗,Nvidia GPU 不会完全进入睡眠状态
      offload = {
        # 默认使 Nvidia GPU 进入睡眠状态
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };
}
