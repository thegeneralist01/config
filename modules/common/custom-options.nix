{ config, lib, pkgs, ... }: let
  inherit (lib) mkOption types;
in {
  options = {
    onLinux = mkOption {
      type = types.bool;
      default = pkgs.stdenv.isLinux;
      description = "Whether the system is running on Linux";
    };

    isServer = mkOption {
      type = types.bool;
      default = config.nixpkgs.hostPlatform.isAarch64;
      description = "Whether the system is a server. Determined by the processor architecture.";
    };
  };
}
