{ config, pkgs, ...}: let
  subs = [
    "https://cache.thegeneralist01.com/"
    "https://cache.garnix.io/"
    "https://cache.nixos.org/"
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
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];

    trusted-users = [ "thegeneralist" "central" "root" "@build" "@wheel" "@admin" ];

    builders-use-substitutes = true;
  };

  nix.distributedBuilds = true;
  nix.buildMachines     = if (config.networking.hostName != "thegeneralist-central") then [{
    hostName            = "thegeneralist-central";
    maxJobs             = 20;
    protocol            = "ssh-ng";
    sshUser             = "build";
    supportedFeatures   = [ "benchmark" "big-parallel" "kvm" "nixos-test" ];
    system              = "aarch64-linux";
  }] else [];

  home-manager.sharedModules  = [{
    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "~/config";
    };
  }];
}
