# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ self, config, pkgs, lib, inputs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  users.knownUsers = [
    "central"
  ];

  users.users.central = {
    name = "central";
    home = "/Users/central";
    shell = pkgs.zsh;
    uid = 502;
    openssh.authorizedKeys.keys = let
      inherit (import ../../keys.nix) thegeneralist;
    in [ thegeneralist ];
  };

  home-manager = {
    backupFileExtension = "home.bak";
    users.central.home = {
      stateVersion = "25.11";
      homeDirectory = "/Users/central";
    };
  };

  system.stateVersion = 6;
}
