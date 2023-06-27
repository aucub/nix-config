{ config, lib, pkgs, ... }:

{
  services = {
    tlp.enable = true;
    auto-cpufreq.enable = true;
    xserver.videoDrivers = [ "amdgpu-pro" "nvidia" ];
  };

  hardware = {
    nvidia = {
      package = linuxKernel.packages.linux_lqx.nvidia_x11_production_open;
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
  };
  environment = {
    systemPackages = with pkgs; [
      nvidia-offload
    ];
  };
}