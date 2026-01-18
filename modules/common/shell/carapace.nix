{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.carapace
    pkgs.fish
    pkgs.zsh
    pkgs.inshellisense
  ];

  home-manager.sharedModules = [{
    programs.carapace.enable = true;
  }];
}
