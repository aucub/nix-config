# 用于启动 flake 和 home-manager 的 Shell,可以通过'nix develop'或'nix-shell'进入
{ pkgs ? (import ./nixpkgs.nix) { } }: {
  default = pkgs.mkShell {
    # 启用实验性特性
    NIX_CONFIG = "experimental-features = nix-command flakes";
    nativeBuildInputs = with pkgs; [ nix home-manager git ];
  };
}
