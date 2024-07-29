{ lib, ... }:
let
  gpuIDs = [
    "10de:1f99" # Graphics
    "10de:10fa" # Audio
  ];
in
{
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  boot = {
    kernelParams = [
      "amd_iommu=on"
      ("vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs)
    ];
    initrd.kernelModules = [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
      "vfio_virqfd"
    ];
  };
}
