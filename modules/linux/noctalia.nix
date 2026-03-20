{ pkgs, inputs, ... }:
{
  environment.systemPackages = [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  home-manager.sharedModules = [{
    imports = [
      inputs.noctalia.homeModules.default
    ];
  }];
}
