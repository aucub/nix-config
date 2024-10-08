{ ... }:
{
  additions = final: _prev: import ../pkgs final.pkgs;
  modifications = final: prev: {
    orchis-theme = prev.orchis-theme.overrideAttrs (oldAttrs: {
      installPhase = ''
        runHook preInstall

        bash install.sh -d $out/share/themes -t default green --tweaks solid macos compact black primary submenu nord

        runHook postInstall
      '';
      src = prev.fetchFromGitHub {
        repo = "Orchis-theme";
        owner = "vinceliuice";
        rev = "6cda1476f059a0f96b475e80112f333e1ba66a80";
        hash = "sha256-Oxtlu67OFGdj1GkYiGcUdsdvt/KWyuAhsABzBTOkBes=";
      };
    });
    nix-search-cli = prev.nix-search-cli.overrideAttrs (oldAttrs: {
      version = "0.2-unstable-2024-09-24";
      src = prev.fetchFromGitHub {
        owner = "peterldowns";
        repo = "nix-search-cli";
        rev = "7d6b4c501ee448dc2e5c123aa4c6d9db44a6dd12";
        hash = "sha256-YM1Lf7py79rU8aJE0PfQaMr5JWx5J1covUf1aCjRkc8=";
      };
    });
    nautilus = prev.nautilus.overrideAttrs (oldAttrs: {
      postPatch =
        (oldAttrs.postPatch or "")
        + ''
          sed -i '/static void\s*action_send_email/,/^\}/d' src/nautilus-files-view.c
          sed -i '/\.name = "send-email"/d' src/nautilus-files-view.c
          sed -i '/action = g_action_map_lookup_action.*(view_action_group, "send-email");/,/^\s*}$/d' src/nautilus-files-view.c
        '';
    });
  };
}
