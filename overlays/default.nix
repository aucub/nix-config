# 定义了覆盖（overlays）
{ inputs, ... }:
{
  # 将我们自定义的软件包从 'pkgs' 目录添加进来
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # 包含任何你想要叠加的东西
  # 你可以更改版本，添加补丁，设置编译标志，任何你想做的事情
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };

  # 应用不稳定的 nixpkgs 集合（在 flake 输入中声明）
  # 可通过访问 through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
