{ pkgs, lib, ...}: {
  # todo: gc
  # todo: cache
  environment.systemPackages = with pkgs; [
    nh
  ];

  lib.debug.traceVal = pkgs.nh;

  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
    "pipe-operators"
  ];

  home-manager.sharedModules  = [{
    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "~/config";
    };
  }];
}
