{
  inputs,
  config,
  pkgs,
  vars,
  ...
}: {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  stylix = {
    image = /home/${vars.users.users.username}/.config/background.jpg;
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/da-one-paper.yaml";
  };
}
