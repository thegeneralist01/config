{ pkgs, lib, ...}: let
  inherit (lib) attrValues;
in {
  environment.systemPackages = attrValues {
    inherit (pkgs)
      wget
      zsh
      neovim
      vim
      home-manager

      gcc
      gnumake
      automake
    ;
  };
}
