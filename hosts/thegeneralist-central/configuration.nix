# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ self, config, pkgs, lib, inputs, ... }:

{
  imports = [ ./hardware-configuration.nix ./site.nix ./cache ];

  users.users.thegeneralist = {
    isNormalUser = true;
    description = "thegeneralist";
    extraGroups = [ "wheel" "audio" "video" "input" "scanner" ];
    shell = pkgs.zsh;
    home = "/home/thegeneralist";
    openssh.authorizedKeys.keys = let
      inherit (import ../../keys.nix) thegeneralist;
    in [ thegeneralist ];
  };

  home-manager = {
    backupFileExtension = "home.bak";
    extraSpecialArgs = { inherit inputs; };
    users.thegeneralist.home = {
      username = "thegeneralist";
      homeDirectory = "/home/thegeneralist";
      stateVersion = "25.11";
    };
  };

  age.secrets.hostkey.file = ./hostkey.age;
  services.openssh.hostKeys = [{
    type = "ed25519";
    path = config.age.secrets.hostkey.path;
  }];

  # Some programs
  services.libinput.enable = true;
  programs.firefox.enable = true;
  programs.zsh.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  system.stateVersion = "24.11";
}

