{
  inputs,
  outputs,
  vars,
  pkgs,
  ...
}:
{
  imports = [
    outputs.nixosModules.shared
    inputs.home-manager.nixosModules.home-manager
    inputs.nixos-wsl.nixosModules.default
  ];

  home-manager = {
    extraSpecialArgs = {
      inherit inputs vars outputs;
    };
    users."${vars.users.users.user.username}" = import ../home-manager/wsl.nix;
    backupFileExtension = "bak";
  };

  environment.systemPackages =
    (with pkgs; [
      difftastic
      sops
      helix
      gitleaks
      eza
      fzf
      bat
      fd
      ripgrep-all
      typos
      lnav
      uutils-coreutils-noprefix
    ])
    # Python Package
    ++ (with pkgs; [
      uv
      (python3.withPackages (
        ps: with ps; [
          requests
          python-dotenv
        ]
      ))
    ])
    # FHS
    ++ (with pkgs; [
      (
        let
          base = pkgs.appimageTools.defaultFhsEnvArgs;
        in
        pkgs.buildFHSEnv (
          base
          // {
            name = "fhs";
            targetPkgs =
              pkgs:
              (base.targetPkgs pkgs)
              ++ (with pkgs; [
                pkg-config
                python3
                uv
              ]);
            profile = "export FHS=1";
            runScript = "fish";
            extraOutputsToInstall = [ "dev" ];
            extraBwrapArgs = [ "--symlink /.host-etc/gitconfig /etc/gitconfig" ];
          }
        )
      )
    ]);

  wsl = {
    enable = true;
    startMenuLaunchers = true;
    defaultUser = vars.users.users.user.username;
    wslConf = {
      network.hostname = vars.networking.hostName;
      user.default = vars.users.users.user.username;
    };
  };
}
