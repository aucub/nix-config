{ lib, ... }:
let
  gpuIDs = [
    "10de:1f99" # Graphics
    "10de:10fa" # Audio
  ];
in
{
  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };
  programs.virt-manager.enable = true;
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };
  boot = {
    kernelParams = [ "amd_iommu=on" ];
    initrd.kernelModules = [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
      "vfio_virqfd"

      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
      ("vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs)
    ];
  };
}
