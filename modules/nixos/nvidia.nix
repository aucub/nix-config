{
  flake,
  pkgs,
  lib,
  ...
}:
let
  inherit (flake) inputs;
  nvidiaDriver = false;
  primeEnable = true && nvidiaDriver;
in
{
  imports = lib.optionals (!nvidiaDriver) [
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-disable
  ];
  services.xserver.videoDrivers = lib.optionals nvidiaDriver [ "nvidia" ];
  environment.variables = lib.optionalAttrs nvidiaDriver {
    __EGL_VENDOR_LIBRARY_FILENAMES = "${pkgs.mesa.drivers}/share/glvnd/egl_vendor.d/50_mesa.json";
    __GLX_VENDOR_LIBRARY_NAME = "mesa";
  };
  hardware.nvidia = lib.optionalAttrs nvidiaDriver {
    open = true;
    modesetting.enable = true;
    nvidiaSettings = false;
    powerManagement = {
      enable = true;
      finegrained = primeEnable;
    };
    prime = lib.optionalAttrs primeEnable {
      amdgpuBusId = "PCI:5:0:0";
      nvidiaBusId = "PCI:1:0:0";
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };
}
