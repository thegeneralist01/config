{ pkgs, lib, config, ... }: let
  inherit (lib) optionalAttrs;
in {
  # TODO: write i3 and i3status here instead of stowing
  virtualisation.vmware.guest.enable = true;

  environment.systemPackages = [ pkgs.fuzzel ];
  programs.niri.enable = config.isServer;

  services.xserver = {
    enable = true;

    # Configure keymap in X11
    # services.xserver.xkb.options = "eurosign:e,caps:escape";
    xkb.layout = "us,ru";

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

    windowManager.i3 = optionalAttrs (!config.isServer) {
      enable = true;
      package = pkgs.i3;
      configFile = ../dotfiles/i3/config;

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

  # home.file.".xprofile".text = ''
  #   xrandr --output HDMI-0 --primary
  # '';
  # services.xserver.xrandrHeads = builtins.map (head:
  #   head // {
  #     primary = if head.output == "HDMI-0" then true else head.primary;
  #   }
  # ) options.services.xserver.xrandrHeads;
}
