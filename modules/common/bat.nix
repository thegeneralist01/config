{ config, ... }: {
  environment.variables = {
    MANPAGER = "bat --plain";
    PAGER = "bat --plain";
  };

  environment.shellAliases = {
    cat = "bat";
    less = "bat --plain";
  };

  home-manager.sharedModules = [{
    programs.bat = {
      enable = true;
      config = {
        theme = config.theme.batTheme;
        pager = "less --quit-if-one-screen --RAW-CONTROL-CHARS";
      };
    };
  }];
}
