inputs: self: super:
let
  system = import ./system.nix inputs self super;
  option = import ./option.nix inputs self super;
in
system // option
