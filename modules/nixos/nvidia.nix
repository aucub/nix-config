{
  pkgs,
  vars,
  ...
}: {
  boot.kernelParams =
    vars.boot.kernelParams
    ++ [
      "nvidia-drm.modeset=1"
      "NVreg_PreserveVideoMemoryAllocations=1"
      "nvidia_drm.fbdev=1"
    ];
  boot.kernelModules =
    vars.boot.kernelModules
    ++ [
      "bbswitch"
      "nvidia"
      "nvidia_drm"
      "nvidia_uvm"
      "nvidia_modeset"
    ];
  boot.extraModulePackages =
    (vars.boot.extraModulePackages pkgs)
    ++ (with pkgs; [
      linuxKernel.packages.linux_zen.bbswitch
    ]);
  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    dynamicBoost.enable = true;
    prime.sync.enable = true;
    package = pkgs.linuxKernel.packages.linux_zen.nvidia_x11_vulkan_beta_open;
    powerManagement = {
      enable = true;
      finegrained = true;
    };
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };
  hardware.opengl.extraPackages =
    (vars.hardware.opengl.extraPackages pkgs)
    ++ (with pkgs; [
      nvidia-vaapi-driver
    ]);
}
