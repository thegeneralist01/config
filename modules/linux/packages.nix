{ pkgs, lib, agenix, ...}: let
  inherit (lib) attrValues;
in {
  environment.systemPackages = attrValues {
    inherit (pkgs)
      wget
      zsh
      neovim
      vim
      home-manager
      protonup-qt
      pipewire
      pwvucontrol
      wireplumber
      playerctl

      xsane
      simple-scan
    ;
  };
}
