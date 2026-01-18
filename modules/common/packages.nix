{ pkgs, lib, ... }: let
  inherit (lib) optionals;
in {
  environment.systemPackages =
    (with pkgs; [
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
      ttfautohint

      pciutils
      usbutils

      nushell
      fish
      zoxide
      vivid
      ripgrep
      yazi
      jq
      yq-go
      eza
      fzf
      gh
      fastfetch
      carapace
      bat
    ])
    ++ optionals (pkgs ? bat-extras && pkgs.bat-extras ? core) [
      pkgs.bat-extras.core
    ];
}
