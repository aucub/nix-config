{ lib, ... }:
{
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    nvidia = {
      nvidiaSettings = false;
      open = true;
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
  };
}
