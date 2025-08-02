inputs: self: super:
let
  system = import ./system.nix inputs self super;
in
system
