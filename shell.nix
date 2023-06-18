# 用于启动 flake-enabled nix 和 home-manager 的 Shell
# 您可以通过'nix develop'或'nix-shell'进入它
{ pkgs ? (import ./nixpkgs.nix) { } }: {
  default = pkgs.mkShell {
    # 启用实验性特性
    NIX_CONFIG = "experimental-features = nix-command flakes";
    nativeBuildInputs = with pkgs; [ nix home-manager git ];
  };
}
