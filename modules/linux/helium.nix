{ inputs, pkgs, ... }: {
  environment.systemPackages = [
    # inputs.helium.defaultPackage.${pkgs.system}
    inputs.helium.packages.${pkgs.system}.default
  ];
}
