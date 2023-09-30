# 定义overlays
{ inputs, ... }: {
  # 将自定义的软件包从 'pkgs' 目录添加进来
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # 包含任何想要叠加的东西,可以更改版本，添加补丁，设置编译标志，任何你想做的事情https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    clash-verge = prev.clash-verge.overrideAttrs (oldAttrs: rec {
      version = "1.3.7";
      src = prev.fetchurl {
        url =
          "https://github.com/zzzgydi/clash-verge/releases/download/v${version}/clash-verge_${version}_amd64.deb";
        hash = "sha256-+RYfGLa4d5JkLWnlYfhjCOSREVJ4ad/R36eSiNj3GIA=";
      };
    });
    vscode = prev.vscode.override {
      commandLineArgs = "--disable-gpu-shader-disk-cache";
    };
  };

  # 应用不稳定的 nixpkgs 集合（在 flake 输入中声明）,可通过 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
