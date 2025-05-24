# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ self, config, pkgs, lib, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      inputs.agenix.darwinModules.default
      # inputs.home-manager.darwinModules.default
    ];

  # age.secrets.hostkey.file = ./hostkey.age;
  # services.openssh.hostKeys = [{
  #   type = "ed25519";
  #   path = config.age.secrets.hostkey.path;
  # }];

  users.users.thegeneralist = {
    name = "thegeneralist";
    home = "/Users/thegeneralist";
    shell = pkgs.nushell;
    # openssh.authorizedKeys.keys = let
    #   inherit (import ../../keys.nix) thegeneralist;
    # in [ thegeneralist ];
  };

  # home-manager.users.thegeneralist.home = {
  #   stateVersion = "24.11";
  #   homeDirectory = "/Users/thegeneralist";
  # };

  system.stateVersion = 6;
}

