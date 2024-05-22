{pkgs ? import <nixpkgs> {}}:
(pkgs.buildFHSUserEnv {
  name = "pipzone";
  targetPkgs = pkgs: (with pkgs; [
    libGL
    glib
    python311Full
    python311Packages.pip
    python311Packages.virtualenv
    uv
  ]);
  runScript = "fish";
})
.env
