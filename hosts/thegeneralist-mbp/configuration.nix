# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ self, config, pkgs, lib, inputs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  users.users.thegeneralist = {
    name = "thegeneralist";
    home = "/Users/thegeneralist";
    shell = pkgs.zsh;
    # openssh.authorizedKeys.keys = let
    #   inherit (import ../../keys.nix) thegeneralist;
    # in [ thegeneralist ];
  };

  # home-manager = {
  #   extraSpecialArgs = { inherit inputs; };
  #   users = {
  #     thegeneralist = import (self + /modules/home);
  #   };
  # };

  # home-manager.users.thegeneralist.home = {
  #   stateVersion = "24.11";
  #   homeDirectory = "/Users/thegeneralist";
  # };

  system.stateVersion = 6;
}

