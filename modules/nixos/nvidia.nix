{ ... }:
{
  hardware = {
    nvidia = {
      open = true;
      modesetting.enable = true;
      dynamicBoost.enable = true;
      powerManagement = {
        enable = true;
        finegrained = true;
      };
      prime = {
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
