{ inputs, pkgs, lib, config,  ...}: let
  inherit (lib) attrValues;
in {
  environment.systemPackages = attrValues {
    inherit (pkgs)
      pipewire
      pwvucontrol
      wireplumber
      playerctl
      ntfs3g;
  } ++ (if (!config.isServer) then (attrValues {
      inherit (pkgs) protonup-qt
      xsane
      simple-scan

      obsidian
      tor-browser;
  }) else []) ++ (if (!config.isServer) then [
      inputs.helium.packages.${pkgs.system}.default
  ] else []);
}
