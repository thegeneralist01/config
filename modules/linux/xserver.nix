{ inputs, pkgs, ... }:
{
  imports = [
    ./noctalia.nix
  ];

  # May God help us
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
    config.common.default = "*";
  };

  home-manager.sharedModules = [
    inputs.niri.homeModules.niri

    {
      gtk = {
        enable = true;
        theme = {
          name = "adw-gtk3-dark";
          package = pkgs.adw-gtk3;
        };
        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.papirus-icon-theme;
        };
        cursorTheme = {
          name = "Adwaita";
          package = pkgs.adwaita-icon-theme;
          size = 24;
        };
      };

      home.pointerCursor = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
        size = 24;
        gtk.enable = true;
      };

      home.sessionVariables = {
        GTK_THEME = "adw-gtk3-dark";
        XCURSOR_THEME = "Adwaita";
        XCURSOR_SIZE = "24";
      };

      xdg = {
        enable = true;
        mimeApps = {
          enable = true;
          defaultApplications = {
            # NOTE: replace "helium.desktop" with the actual .desktop filename
            # find it with: ls ~/.nix-profile/share/applications/ | grep -i helium
            "text/html" = "helium.desktop";
            "x-scheme-handler/http" = "helium.desktop";
            "x-scheme-handler/https" = "helium.desktop";
            "x-scheme-handler/about" = "helium.desktop";
            "x-scheme-handler/unknown" = "helium.desktop";
            "application/pdf" = "helium.desktop";
          };
        };
      };

      programs.niri = {
        enable = true;
        package = pkgs.niri;
        settings = {
          layout = {
            focus-ring = {
              enable = false;
            };
            tab-indicator = {
              enable = false;
            };
            border = {
              enable = false;
            };
            # border = "off";
          };
          spawn-at-startup = [
            {
              command = [ "noctalia-shell" ];
            }
          ];
          binds = {
            # Shortcuts Pane
            "Mod+Shift+Escape".action.show-hotkey-overlay = { };

            # Application Shortcuts
            "Mod+Return" = {
              hotkey-overlay.title = "Open Terminal: ghostty";
              action.spawn = [ "ghostty" ];
            };

            "Mod+B" = {
              hotkey-overlay.title = "Open Browser: helium";
              action.spawn = [ "helium" ];
            };

            "Mod+Alt+B" = {
              hotkey-overlay.title = "Open Secondary Browser: firefox";
              action.spawn = [ "firefox" ];
            };

            "Mod+Shift+Q" = {
              hotkey-overlay.title = "Lock Screen: gtklock";
              action.spawn = [ "gtklock" ];
            };

            "Mod+D" = {
              hotkey-overlay.title = "Open App Launcher: fuzzel";
              action.spawn = [
                "fuzzel"
                "toggle"
              ];
            };

            "Mod+E" = {
              hotkey-overlay.title = "File Manager: Thunar";
              action.spawn = [ "thunar" ];
            };

            "Mod+O" = {
              hotkey-overlay.title = "Obsidian";
              action.spawn = [ "sh" "-c" "obsidian" ];
            };

            "Mod+N" = {
              hotkey-overlay.title = "X Notifications";
              action.spawn = [ "helium" "https://x.com/i/notifications" ];
            };

            "Mod+Alt+E" = {
              hotkey-overlay.title = "File Manager: Yazi";
              action.spawn = [ "yazi" ];
            };

            # Media Keys
            "XF86AudioRaiseVolume" = {
              allow-when-locked = true;
              action.spawn = [
                "wpctl"
                "set-volume"
                "@DEFAULT_AUDIO_SINK@"
                "5%+"
              ];
            };

            "XF86AudioLowerVolume" = {
              allow-when-locked = true;
              action.spawn = [
                "wpctl"
                "set-volume"
                "@DEFAULT_AUDIO_SINK@"
                "5%-"
              ];
            };

            # "XF86MonBrightnessUp" = {
            #   allow-when-locked = true;
            #   action.spawn = [ "mediactl" "brightness_up" ];
            # };

            # "XF86MonBrightnessDown" = {
            #   allow-when-locked = true;
            #   action.spawn = [ "mediactl" "brightness_down" ];
            # };

            "XF86AudioMute" = {
              allow-when-locked = true;
              action.spawn = [
                "wpctl"
                "set-mute"
                "@DEFAULT_AUDIO_SINK@"
                "toggle"
              ];
            };

            "XF86AudioMicMute" = {
              allow-when-locked = true;
              action.spawn = [
                "wpctl"
                "set-mute"
                "@DEFAULT_AUDIO_SOURCE@"
                "toggle"
              ];
            };

            "XF86AudioNext" = {
              allow-when-locked = true;
              action.spawn = [
                "playerctl"
                "next"
              ];
            };

            "XF86AudioPause" = {
              allow-when-locked = true;
              action.spawn = [
                "playerctl"
                "play-pause"
              ];
            };

            "XF86AudioPlay" = {
              allow-when-locked = true;
              action.spawn = [
                "playerctl"
                "play-pause"
              ];
            };

            "XF86AudioPrev" = {
              allow-when-locked = true;
              action.spawn = [
                "playerctl"
                "previous"
              ];
            };

            # Window Management
            "Mod+Q".action.close-window = { };

            "Mod+H".action.focus-column-left = { };
            "Mod+J".action.focus-workspace-down = { };
            "Mod+K".action.focus-workspace-up = { };
            "Mod+L".action.focus-column-right = { };

            "Mod+Left".action.focus-column-left = { };
            "Mod+Down".action.focus-window-down = { };
            "Mod+Up".action.focus-window-up = { };
            "Mod+Right".action.focus-column-right = { };

            # Move windows within workspace
            "Mod+Shift+Left".action.move-column-left = { };
            "Mod+Shift+Down".action.move-window-down = { };
            "Mod+Shift+Up".action.move-window-up = { };
            "Mod+Shift+Right".action.move-column-right = { };

            "Mod+Shift+H".action.move-column-left = { };
            "Mod+Shift+J".action.move-column-to-workspace-down = { };
            "Mod+Shift+K".action.move-column-to-workspace-up = { };
            "Mod+Shift+L".action.move-column-right = { };

            # Move to workspace edges
            "Mod+Shift+Home".action.move-column-to-first = { };
            "Mod+Shift+End".action.move-column-to-last = { };

            "Mod+Home".action.focus-column-first = { };
            "Mod+End".action.focus-column-last = { };

            # Monitor Management - Move between monitors
            "Mod+Ctrl+Left".action.focus-monitor-left = { };
            "Mod+Ctrl+Right".action.focus-monitor-right = { };
            "Mod+Ctrl+Up".action.focus-monitor-up = { };
            "Mod+Ctrl+Down".action.focus-monitor-down = { };

            "Mod+Ctrl+H".action.focus-monitor-left = { };
            "Mod+Ctrl+L".action.focus-monitor-right = { };
            "Mod+Ctrl+K".action.focus-monitor-up = { };
            "Mod+Ctrl+J".action.focus-monitor-down = { };

            # Move windows to different monitors
            "Mod+Shift+Ctrl+Left".action.move-column-to-monitor-left = { };
            "Mod+Shift+Ctrl+Right".action.move-column-to-monitor-right = { };
            "Mod+Shift+Ctrl+Up".action.move-column-to-monitor-up = { };
            "Mod+Shift+Ctrl+Down".action.move-column-to-monitor-down = { };

            "Mod+Shift+Ctrl+H".action.move-column-to-monitor-left = { };
            "Mod+Shift+Ctrl+L".action.move-column-to-monitor-right = { };
            "Mod+Shift+Ctrl+K".action.move-column-to-monitor-up = { };
            "Mod+Shift+Ctrl+J".action.move-column-to-monitor-down = { };

            # Workspace Management
            "Mod+Escape" = {
              hotkey-overlay.title = "Open Overview";
              repeat = false;
              action.toggle-overview = { };
            };

            "Mod+WheelScrollDown" = {
              cooldown-ms = 100;
              action.focus-workspace-down = { };
            };

            "Mod+WheelScrollUp" = {
              cooldown-ms = 100;
              action.focus-workspace-up = { };
            };

            # Move windows to different workspaces
            "Mod+Shift+WheelScrollDown" = {
              cooldown-ms = 100;
              action.move-column-to-workspace-down = { };
            };

            "Mod+Shift+WheelScrollUp" = {
              cooldown-ms = 100;
              action.move-column-to-workspace-up = { };
            };

            # Column navigation with mouse
            "Mod+WheelScrollRight".action.focus-column-right = { };
            "Mod+WheelScrollLeft".action.focus-column-left = { };
            "Mod+Ctrl+WheelScrollRight".action.move-column-right = { };
            "Mod+Ctrl+WheelScrollLeft".action.move-column-left = { };

            # Numbered Workspaces
            "Mod+1".action.focus-workspace = 1;
            "Mod+2".action.focus-workspace = 2;
            "Mod+3".action.focus-workspace = 3;
            "Mod+4".action.focus-workspace = 4;
            "Mod+5".action.focus-workspace = 5;
            "Mod+6".action.focus-workspace = 6;
            "Mod+7".action.focus-workspace = 7;
            "Mod+8".action.focus-workspace = 8;
            "Mod+9".action.focus-workspace = 9;

            # Move windows to numbered workspaces
            "Mod+Shift+1".action.move-column-to-workspace = 1;
            "Mod+Shift+2".action.move-column-to-workspace = 2;
            "Mod+Shift+3".action.move-column-to-workspace = 3;
            "Mod+Shift+4".action.move-column-to-workspace = 4;
            "Mod+Shift+5".action.move-column-to-workspace = 5;
            "Mod+Shift+6".action.move-column-to-workspace = 6;
            "Mod+Shift+7".action.move-column-to-workspace = 7;
            "Mod+Shift+8".action.move-column-to-workspace = 8;
            "Mod+Shift+9".action.move-column-to-workspace = 9;

            "Mod+Tab".action.focus-workspace-previous = { };

            # Layout Controls
            "Mod+C".action.center-column = { };
            "Mod+Ctrl+C".action.center-visible-columns = { };
            "Mod+BracketLeft".action.set-column-width = "-10%";
            "Mod+BracketRight".action.set-column-width = "+10%";
            "Mod+Shift+BracketLeft".action.set-window-height = "-10%";
            "Mod+Shift+BracketRight".action.set-window-height = "+10%";

            # Window resizing with mouse
            "Mod+Ctrl+WheelScrollDown".action.set-window-height = "-5%";
            "Mod+Ctrl+WheelScrollUp".action.set-window-height = "+5%";

            # Window Modes
            "Mod+T".action.toggle-window-floating = { };
            "Mod+F".action.fullscreen-window = { };
            "Mod+M".action.maximize-column = { };

            # Utils
            "Mod+S".action.screenshot = { };

            "Mod+Shift+S".action.screenshot-screen = {
              write-to-disk = true;
            };

            "Mod+Ctrl+S".action.screenshot-window = {
              write-to-disk = true;
            };

            "Mod+P".action.spawn = [
              "sh"
              "-c"
              "pgrep -x hyprpicker >/dev/null || hyprpicker"
            ];
          };
        };
      };
    }
  ];
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
  virtualisation.vmware.guest.enable = true;

  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  environment.systemPackages = [
    pkgs.fuzzel
    pkgs.xfce.thunar
    pkgs.playerctl
    pkgs.wireplumber
  ];

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

    # windowManager.i3 = optionalAttrs (false) {
    #   enable = true;
    #   package = pkgs.i3;
    #   configFile = ../dotfiles/i3/config;
    #
    #   extraPackages = with pkgs; [
    #     i3
    #     i3status
    #     rofi
    #     dmenu
    #     feh
    #     picom # transparency effects compositor
    #     dunst # notification daemon
    #     xfce.thunar
    #     nemo
    #     arandr # screen conf
    #     lxappearance
    #   ];
    # };
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
