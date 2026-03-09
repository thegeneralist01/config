{ lib, config, ... }: {
  options.theme = {
    batTheme = lib.mkOption {
      type = lib.types.str;
      default = "gruvbox-dark";
      description = "Theme name for bat.";
    };

    ghosttyTheme = lib.mkOption {
      type = lib.types.str;
      default = if config.onLinux then "GruvboxDarkHard" else "Gruvbox Dark Hard";
      description = "Theme name for Ghostty.";
    };
  };
}
