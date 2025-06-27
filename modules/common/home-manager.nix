{
  home-manager = {
    useGlobalPkgs   = true;
    useUserPackages = true;
  };

  home-manager.sharedModules = [{
    programs.home-manager.enable = true;
  }];
}
