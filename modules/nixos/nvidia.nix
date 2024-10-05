{
  pkgs,
  inputs,
  ...
}:
let
  nvidiaDriver = false;
  primeEnable = true && nvidiaDriver;
in
{
  imports =
    if !nvidiaDriver then [ inputs.nixos-hardware.nixosModules.common-gpu-nvidia-disable ] else [ ];
  services.xserver.videoDrivers = if nvidiaDriver then [ "nvidia" ] else [ ];
  environment.variables =
    if nvidiaDriver then
      {
        __EGL_VENDOR_LIBRARY_FILENAMES = "${pkgs.mesa.drivers}/share/glvnd/egl_vendor.d/50_mesa.json";
        __GLX_VENDOR_LIBRARY_NAME = "mesa";
      }
    else
      { };
  hardware.nvidia =
    if nvidiaDriver then
      {
        open = true;
        modesetting.enable = true;
        nvidiaSettings = false;
        powerManagement = {
          enable = true;
          finegrained = primeEnable;
        };
        prime =
          if primeEnable then
            {
              amdgpuBusId = "PCI:5:0:0";
              nvidiaBusId = "PCI:1:0:0";
              offload = {
                enable = true;
                enableOffloadCmd = true;
              };
            }
          else
            { };
      }
    else
      { };
}
