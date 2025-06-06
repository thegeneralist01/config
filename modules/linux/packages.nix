{ pkgs, lib, ...}: let
  inherit (lib) attrValues;
in {
  environment.systemPackages = attrValues {
    inherit (pkgs)
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
