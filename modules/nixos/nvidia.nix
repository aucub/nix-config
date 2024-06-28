{
  pkgs,
  outputs,
  config,
  ...
}:
{
  boot = {
    kernelParams = outputs.vars.boot.kernelParams ++ [
      "nvidia-drm.modeset=1"
      "NVreg_PreserveVideoMemoryAllocations=1"
      "nvidia_drm.fbdev=1"
    ];
    kernelModules = outputs.vars.boot.kernelModules ++ [
      "bbswitch"
      "nvidia"
      "nvidia_drm"
      "nvidia_uvm"
      "nvidia_modeset"
    ];
    extraModulePackages =
      (outputs.vars.boot.extraModulePackages config.boot.kernelPackages)
      ++ (with config.boot.kernelPackages; [ bbswitch ]);
  };
  hardware = {
    nvidia = {
      open = true;
      modesetting.enable = true;
      dynamicBoost.enable = true;
      package = config.boot.kernelPackages.nvidia_x11_vulkan_beta_open;
      powerManagement = {
        enable = true;
        finegrained = true;
      };
      prime = {
        sync.enable = true;
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
      };
    };
    graphics.extraPackages =
      (outputs.vars.hardware.graphics.extraPackages pkgs) ++ (with pkgs; [ nvidia-vaapi-driver ]);
  };
  environment.variables.NVD_BACKEND = "direct";
  services.xserver.videoDrivers = outputs.vars.services.xserver.videoDrivers ++ [ "nvidia" ];
}
