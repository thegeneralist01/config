{ inputs, lib, os, ... }:
let
  isDarwin = os == "darwin";
  isLinux = os == "linux";
in {
  imports =
    lib.optional isDarwin inputs.home-manager.darwinModules.home-manager
    ++ lib.optional isLinux inputs.home-manager.nixosModules.home-manager;

  home-manager = {
    useGlobalPkgs   = true;
    useUserPackages = true;
    backupFileExtension = lib.mkDefault "home.bak";
  };

  home-manager.sharedModules = [{
    programs.home-manager.enable = true;
  }];
}
