{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  stylix = {
    image = "${pkgs.lib.file.mkHomePath ".config/background"}";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/da-one-paper.yaml";
  };
}
