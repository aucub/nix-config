# 从锁文件中绑定的nixpkgs提交中获取的nixpkgs实例
# 这很有用，可以在使用传统nix命令时避免使用通道
let lock = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.nixpkgs.locked;
in
import (fetchTarball {
  url = "https://github.com/nixos/nixpkgs/archive/${lock.rev}.tar.gz";
  sha256 = lock.narHash;
})
