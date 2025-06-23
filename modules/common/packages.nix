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

      zip
      xz
      unzip

      mtr
      iperf3
      dnsutils
      ldns
      nmap

      file
      which
      tree
      gnupg
      btop

      pciutils
      usbutils
    ;
  };
}
