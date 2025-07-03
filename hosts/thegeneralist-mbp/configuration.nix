# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ./aerospace.nix ];

  users.knownUsers = [
    "thegeneralist"
  ];

  users.users.thegeneralist = {
    name = "thegeneralist";
    home = "/Users/thegeneralist";
    shell = pkgs.zsh;
    uid = 501;
    # openssh.authorizedKeys.keys = let
    #   inherit (import ../../keys.nix) thegeneralist;
    # in [ thegeneralist ];
  };

  home-manager = {
    backupFileExtension = "home.bak";
    users.thegeneralist.home = {
      stateVersion = "25.11";
      homeDirectory = "/Users/thegeneralist";
    };
  };

  system.stateVersion = 6;
}
