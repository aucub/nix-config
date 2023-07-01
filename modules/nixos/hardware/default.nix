{ config, lib, pkgs, ... }:

{
  services = {
    tlp.enable = true;
    auto-cpufreq.enable = true;
  };

  hardware = {
    fs = {
      enable = true;
      ssd.enable = true;
    };
    nvidia = {
      package = pkgs.linuxKernel.packages.linux_lqx.nvidia_x11_vulkan_beta_open;
      powerManagement.enable = true;
      open = true;
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
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        libvdpau-va-gl
      ];
    };
    pulseaudio.support32Bit = true;
    ledger.enable = true;
    sensors.enable = true;
  };

  environment.systemPackages = [
    pkgs.linuxKernel.packages.linux_lqx.bbswitch
    pkgs.linuxKernel.packages.linux_lqx.acpi_call
  ];

  # Often used values: “ondemand”, “powersave”, “performance”
  powerManagement.cpuFreqGovernor = "“ondemand”";
  
}
