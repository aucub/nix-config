{ inputs, lib, ... }: {
  imports = [ inputs.nixos-hardware.nixosModules.common-gpu-nvidia-disable ];
  hardware.nvidia.prime = {
    nvidiaBusId = lib.mkForce "";
    amdgpuBusId = lib.mkForce "";
    offload = {
      enable = lib.mkForce false;
      enableOffloadCmd = lib.mkForce false;
    };
  };
}
