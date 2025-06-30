{ pkgs, lib, ...}: {
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

    extra-substituters = [
      "https://cache.thegeneralist01.com/"
    ];

    extra-trusted-public-keys = [
      "etc.thegeneralist01.com:BIhIf7HJ5xjFX+2e0WrGDQ4LdHeEEyQrtWBB1li2Ve8="
    ];
  };

  home-manager.sharedModules  = [{
    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "~/config";
    };
  }];
}
