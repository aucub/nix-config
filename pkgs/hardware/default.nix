{ config, lib, pkgs, ... }:

{
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services = {
    tlp.enable = true;
    auto-cpufreq.enable = true;
    xserver.videoDrivers = [ "nvidia" ];
  };
  hardware = {
    nvidia = {
      powerManagement.enable = true;
      open = true;
      modesetting.enable = true;
      prime = {
        offload.enable = true;
      };

    };
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    pulseaudio.support32Bit = true;
  };
  environment = {
    systemPackages = with pkgs; [
      nvidia-offload
      libva
      libva-utils
      glxinfo
      vulkan-loader
      vulkan-validation-layers
      vulkan-tools
    ];
  };
}