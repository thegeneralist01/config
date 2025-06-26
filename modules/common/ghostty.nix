{ pkgs, config, ... }: {
  environment.variables = {
    TERMINAL = "ghostty";
  };

  home-manager.sharedModules = [{
    programs.ghostty = {
      enable = true;
      package = if config.onLinux then pkgs.ghostty else null;

      clearDefaultKeybinds = false;
      settings = {
        theme = "tokyonight";
        font-family = "JetBrainsMono NL NFM Medium";
        font-size = 16;

        shell-integration-features = "no-cursor";

        cursor-style = "block";
        background-opacity = 1;

        background-blur-radius = 0;

        gtk-titlebar = false;
        mouse-hide-while-typing = true;
      };
    };
  }];
}
