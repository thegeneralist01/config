{ config, pkgs, ...}: let
  subs = [
    "https://cache.thegeneralist01.com/"
    "https://cache.nixos.org/"
    "https://niri.cachix.org"
  ];
in {
  # todo: gc
  environment.systemPackages = with pkgs; [
    nh
  ];

  nix.settings = {
    experimental-features = [
      "flakes"
      "nix-command"
      "pipe-operators"
    ];

    extra-substituters = subs;
    trusted-substituters = subs;

    extra-trusted-public-keys = [
      "cache.thegeneralist01.com:jkKcenR877r7fQuWq6cr0JKv2piqBWmYLAYsYsSJnT4="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
    ];

    trusted-users = [ "thegeneralist" "root" "@wheel" "@admin" "jellyfin" "git" ];

    builders-use-substitutes = true;
  };

  nix.package = pkgs.nixVersions.latest;


  home-manager.sharedModules  = [{
    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "~/config";
    };
  }];
}
