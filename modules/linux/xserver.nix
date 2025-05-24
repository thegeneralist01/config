{ pkgs, ... }: {
  # TODO: write i3 and i3status here instead of stowing
  services.xserver = {
    enable = true;

    displayManager = {
      lightdm = {
        enable = true;
        greeters = {
          gtk = {
            enable = true;
          };
        };
      };
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3;
      configFile = ../home/dotfiles/i3/config;

      extraPackages = with pkgs; [
        i3
        i3status
        rofi
        dmenu
        feh
        picom # transparency effects compositor
        dunst # notification daemon
        xfce.thunar
        nemo
        arandr # screen conf
        lxappearance
      ];
    };
  };

  # Configure keymap in X11
  services.xserver.xkb.layout = "us,ru";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # home.file.".xprofile".text = ''
  #   xrandr --output HDMI-0 --primary
  # '';
  # services.xserver.xrandrHeads = builtins.map (head:
  #   head // {
  #     primary = if head.output == "HDMI-0" then true else head.primary;
  #   }
  # ) options.services.xserver.xrandrHeads;
}
