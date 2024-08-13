{ pkgs, ... }:
{
  services.xserver.videoDrivers = [ "nvidia" ];
  environment.variables = {
    __EGL_VENDOR_LIBRARY_FILENAMES = "${pkgs.mesa.drivers}/share/glvnd/egl_vendor.d/50_mesa.json";
    __GLX_VENDOR_LIBRARY_NAME = "mesa";
  };
  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    nvidiaSettings = false;
    powerManagement = {
      enable = true;
      finegrained = true;
    };
    prime = {
      amdgpuBusId = "PCI:5:0:0";
      nvidiaBusId = "PCI:1:0:0";
      offload = {
        enable = true; # 默认使 Nvidia GPU 进入睡眠状态
        enableOffloadCmd = true;
      };
    };
  };
}
