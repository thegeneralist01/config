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
        # theme = "tokyonight";
        theme = config.theme.ghosttyTheme;
        # theme = if config.onLinux then "GruvboxDarkHard" else "Gruvbox Dark Hard";
        font-family = "Berkeley Mono";
        font-size = 16;

        shell-integration-features = "no-cursor";

        cursor-style = "block";
        background-opacity = 1;

        background-blur-radius = 0;

        gtk-titlebar = false;
        mouse-hide-while-typing = true;
        custom-shader = "~/.config/ghostty-shaders/shader.glsl";
      };
    };
  }];
}
