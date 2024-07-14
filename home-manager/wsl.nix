{
  inputs,
  outputs,
  vars,
  pkgs,
  ...
}:
{
  imports = [ outputs.homeManagerModules.shared ];
}
