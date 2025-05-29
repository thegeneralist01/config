{ lib, pkgs, ... }:

{
  options = {
    onLinux = lib.mkOption {
      type = lib.types.bool;
      default = pkgs.stdenv.isLinux;
      description = "Whether the system is running on Linux";
    };
  };
}
