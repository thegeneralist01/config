{
  home-manager.sharedModules = [{
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autocd = true;
      autosuggestion.enable = true;
    };
  }];
  environment.pathsToLink = [ "/share/zsh" ];
}
