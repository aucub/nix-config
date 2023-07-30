{ config, lib, pkgs, ... }:

{
  services = {
    tlp.enable = true;
    auto-cpufreq.enable = true;
  };

  hardware = {
    nvidia = {
      package = pkgs.linuxKernel.packages.linux_lqx.nvidia_x11_vulkan_beta_open;
      powerManagement.enable = true;
      open = true;
      nvidiaSettings = true;
      modesetting.enable = true;
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
      };
    };
    opengl = {
      enable = true;
      driSupport = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        nvidia-vaapi-driver
        libvdpau-va-gl
      ];
    };
    # 平滑背光控制
    brillo.enable = true;
    cpu.amd.updateMicrocode = true;
    pulseaudio.enable = false;
    bluetooth.enable = true;
    # 禁用nvidia
    nvidiaOptimus.disable = false;
  };

  # Often used values: “ondemand”, “powersave”, “performance”
  powerManagement.cpuFreqGovernor = "“ondemand”";

}
