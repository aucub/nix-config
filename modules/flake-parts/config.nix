{ lib, ... }:
{
  config = {
    users = {
      root.initialHashedPassword = "$y$j9T$/qg2DYP0TOSZzSwlgs9mV/$uVAqBwhXEnwkMd0D4zKH9SSBQ4WzlGcnimnLrbyNwP4";
      uymi = {
        username = "uymi";
        uid = 1000;
        initialHashedPassword = "$y$j9T$XOU8eqbT/uiYRkLNMVma91$FpP9C3IIhl1t/i9LH0k5LxqwnRKH9baVotniFxx7vG4";
        cursorName = "Bibata-Modern-Classic";
        cursorPackage = pkgs: pkgs.bibata-cursors;
        cursorSize = 24;
      };
    };
    hosts.neko.defaultUserName = "uymi";
  };
  options = {
    users = lib.mkOption {
      type = lib.types.anything;
    };
    hosts = lib.mkOption {
      type = lib.types.anything;
    };
  };
}
