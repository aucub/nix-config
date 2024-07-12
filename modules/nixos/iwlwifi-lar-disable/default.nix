{ ... }:
{
  boot.kernelPatches = [
    {
      name = "iwlwifi-lar-disable";
      patch = ./c545b26dd567a638d62ca29490e9e2e6d04a8b6b.patch;
    }
  ];
}
