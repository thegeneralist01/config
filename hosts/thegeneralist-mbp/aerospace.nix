{ inputs, pkgs, ... }:

{
  system.primaryUser = "thegeneralist";

  # Left Option drives AeroSpace; right Option remains available for typing.
  services.aerospace = {
    enable = true;
    package = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.aerospace;
    settings = {
      config-version = 2;
      # Keep the workspaces that version 1 inferred from the bindings.
      persistent-workspaces = [
        "1" "2" "3" "4" "5" "6" "7" "8" "9" "10"
        "A" "B" "C" "D" "E" "F" "G" "I" "M" "N" "O"
        "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z"
      ];

      # Normalizations. See: https://nikitabobko.github.io/AeroSpace/guide#normalization
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;

      # See: https://nikitabobko.github.io/AeroSpace/guide#layouts
      # The 'accordion-padding' specifies the size of accordion padding
      # You can set 0 to disable the padding feature
      accordion-padding = 30;

      # Possible values: tiles|accordion
      default-root-container-layout = "tiles";

      # Possible values: horizontal|vertical|auto
      # 'auto' means: wide monitor (anything wider than high) gets horizontal orientation,
      #               tall monitor (anything higher than wide) gets vertical orientation
      default-root-container-orientation = "auto";

      # Mouse follows focus when focused monitor changes
      # Drop it from your config, if you don't like this behavior
      # See https://nikitabobko.github.io/AeroSpace/guide#on-focus-changed-callbacks
      # See https://nikitabobko.github.io/AeroSpace/commands#move-mouse
      # Fallback value (if you omit the key): on-focused-monitor-changed = []
      on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];

      # You can effectively turn off macOS "Hide application" (cmd-h) feature by toggling this flag
      # Useful if you don't use this macOS feature, but accidentally hit cmd-h or cmd-alt-h key
      # Also see: https://nikitabobko.github.io/AeroSpace/goodies#disable-hide-app
      automatically-unhide-macos-hidden-apps = false;

      # Possible values: (qwerty|dvorak|colemak)
      # See https://nikitabobko.github.io/AeroSpace/guide#key-mapping
      key-mapping = {
        preset = "qwerty";
      };

      # Gaps between windows (inner-*) and between monitor edges (outer-*).
      # Possible values:
      # - Constant:     gaps.outer.top = 8
      # - Per monitor:  gaps.outer.top = [{ monitor.main = 16 }, { monitor."some-pattern" = 32 }, 24]
      #                 In this example, 24 is a default value when there is no match.
      #                 Monitor pattern is the same as for 'workspace-to-monitor-force-assignment'.
      #                 See:
      #                 https://nikitabobko.github.io/AeroSpace/guide#assign-workspaces-to-monitors
      gaps = {
        inner = {
          horizontal = 0;
          vertical = 0;
        };
        outer = {
          left = 0;
          bottom = 0;
          top = 0;
          right = 0;
        };
      };

      # 'main' binding mode declaration
      # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
      # 'main' binding mode must be always presented
      # Fallback value (if you omit the key): mode.main.binding = {}
      mode.main.binding = {
        # All possible keys:
        # - Letters.        a, b, c, ..., z
        # - Numbers.        0, 1, 2, ..., 9
        # - Keypad numbers. keypad0, keypad1, keypad2, ..., keypad9
        # - F-keys.         f1, f2, ..., f20
        # - Special keys.   minus, equal, period, comma, slash, backslash, quote, semicolon,
        #                   backtick, leftSquareBracket, rightSquareBracket, space, enter, esc,
        #                   backspace, tab, pageUp, pageDown, home, end, forwardDelete,
        #                   sectionSign (ISO keyboards only, european keyboards only)
        # - Keypad special. keypadClear, keypadDecimalMark, keypadDivide, keypadEnter, keypadEqual,
        #                   keypadMinus, keypadMultiply, keypadPlus
        # - Arrows.         left, down, up, right

        # Modifiers: cmd, alt, ctrl, shift; prefix l/r to restrict a side.

        # All possible commands: https://nikitabobko.github.io/AeroSpace/commands

        # See: https://nikitabobko.github.io/AeroSpace/commands#exec-and-forget
        # You can uncomment the following lines to open a terminal with left Option + Enter
        # (like in i3)
        # lalt-enter = '''exec-and-forget osascript -e '
        # tell application "Terminal"
        #     do script
        #     activate
        # end tell'
        # '''

        # See: https://nikitabobko.github.io/AeroSpace/commands#layout
        lalt-slash = "layout tiles horizontal vertical";
        lalt-comma = "layout accordion horizontal vertical";

        # See: https://nikitabobko.github.io/AeroSpace/commands#focus
        lalt-h = "focus left";
        lalt-j = "focus down";
        lalt-k = "focus up";
        lalt-l = "focus right";

        # See: https://nikitabobko.github.io/AeroSpace/commands#move
        lalt-shift-h = "move left";
        lalt-shift-j = "move down";
        lalt-shift-k = "move up";
        lalt-shift-l = "move right";

        # See: https://nikitabobko.github.io/AeroSpace/commands#resize
        lalt-minus = "resize smart -50";
        lalt-equal = "resize smart +50";

        # See: https://nikitabobko.github.io/AeroSpace/commands#workspace
        lalt-0 = "workspace 10";
        lalt-1 = "workspace 1";
        lalt-2 = "workspace 2";
        lalt-3 = "workspace 3";
        lalt-4 = "workspace 4";
        lalt-5 = "workspace 5";
        lalt-6 = "workspace 6";
        lalt-7 = "workspace 7";
        lalt-8 = "workspace 8";
        lalt-9 = "workspace 9";
        lalt-a = "workspace A"; # In your config, you can drop workspace bindings that you don't need
        lalt-b = "workspace B";
        lalt-c = "workspace C";
        lalt-d = "workspace D";
        lalt-e = "workspace E";
        lalt-f = "workspace F";
        lalt-g = "workspace G";
        lalt-i = "workspace I";
        lalt-m = "workspace M";
        lalt-n = "workspace N";
        lalt-o = "workspace O";
        lalt-p = "workspace P";
        lalt-q = "workspace Q";
        lalt-r = "workspace R";
        lalt-s = "workspace S";
        lalt-t = "workspace T";
        lalt-u = "workspace U";
        lalt-v = "workspace V";
        lalt-w = "workspace W";
        lalt-x = "workspace X";
        lalt-y = "workspace Y";
        lalt-z = "workspace Z";

        # See: https://nikitabobko.github.io/AeroSpace/commands#move-node-to-workspace
        lalt-shift-1 = "move-node-to-workspace 1";
        lalt-shift-2 = "move-node-to-workspace 2";
        lalt-shift-3 = "move-node-to-workspace 3";
        lalt-shift-4 = "move-node-to-workspace 4";
        lalt-shift-5 = "move-node-to-workspace 5";
        lalt-shift-6 = "move-node-to-workspace 6";
        lalt-shift-7 = "move-node-to-workspace 7";
        lalt-shift-8 = "move-node-to-workspace 8";
        lalt-shift-9 = "move-node-to-workspace 9";
        lalt-shift-a = "move-node-to-workspace A";
        lalt-shift-b = "move-node-to-workspace B";
        lalt-shift-c = "move-node-to-workspace C";
        lalt-shift-d = "move-node-to-workspace D";
        lalt-shift-e = "move-node-to-workspace E";
        lalt-shift-f = "move-node-to-workspace F";
        lalt-shift-g = "move-node-to-workspace G";
        lalt-shift-i = "move-node-to-workspace I";
        lalt-shift-m = "move-node-to-workspace M";
        lalt-shift-n = "move-node-to-workspace N";
        lalt-shift-o = "move-node-to-workspace O";
        lalt-shift-p = "move-node-to-workspace P";
        lalt-shift-q = "move-node-to-workspace Q";
        lalt-shift-r = "move-node-to-workspace R";
        lalt-shift-s = "move-node-to-workspace S";
        lalt-shift-t = "move-node-to-workspace T";
        lalt-shift-u = "move-node-to-workspace U";
        lalt-shift-v = "move-node-to-workspace V";
        lalt-shift-w = "move-node-to-workspace W";
        lalt-shift-x = "move-node-to-workspace X";
        lalt-shift-y = "move-node-to-workspace Y";
        lalt-shift-z = "move-node-to-workspace Z";

        # See: https://nikitabobko.github.io/AeroSpace/commands#workspace-back-and-forth
        lalt-tab = "workspace-back-and-forth";
        # See: https://nikitabobko.github.io/AeroSpace/commands#move-workspace-to-monitor
        lalt-shift-tab = "move-workspace-to-monitor --wrap-around next";

        # See: https://nikitabobko.github.io/AeroSpace/commands#mode
        lalt-shift-semicolon = "mode service";
      };

      # 'service' binding mode declaration.
      # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
      mode.service.binding = {
        esc = [ "reload-config" "mode main" ];
        r = [ "flatten-workspace-tree" "mode main" ]; # reset layout
        f = [ "layout floating tiling" "mode main" ]; # Toggle between floating and tiling layout
        backspace = [ "close-all-windows-but-current" "mode main" ];

        # sticky is not yet supported https://github.com/nikitabobko/AeroSpace/issues/2
        #s = ['layout sticky tiling', 'mode main']

        lalt-shift-h = [ "join-with left" "mode main" ];
        lalt-shift-j = [ "join-with down" "mode main" ];
        lalt-shift-k = [ "join-with up" "mode main" ];
        lalt-shift-l = [ "join-with right" "mode main" ];

        down = "volume down";
        up = "volume up";
        shift-down = [ "volume set 0" "mode main" ];
      };

      on-window-detected = [
        { "if".app-id = "net.imput.helium"; run = "move-node-to-workspace W"; }
        { "if".app-id = "com.stablyai.orca"; run = "move-node-to-workspace S"; }
        { "if".app-id = "md.obsidian"; run = "move-node-to-workspace Q"; }
        { "if".app-id = "com.openai.codex"; run = "move-node-to-workspace C"; }
        { "if".app-id = "com.anthropic.claudefordesktop"; run = "move-node-to-workspace F"; }
        { "if".app-id = "com.apple.mail"; run = "move-node-to-workspace M"; }
        { "if".app-id = "net.whatsapp.WhatsApp"; run = "move-node-to-workspace E"; }
        { "if".app-id = "com.apple.reminders"; run = "move-node-to-workspace E"; }
        { "if".app-id = "io.tailscale.ipn.macsys"; run = "move-node-to-workspace 9"; }
        { "if".app-id = "com.softissimo.ReversoContext.macosapp"; run = "move-node-to-workspace 9"; }
        { "if".app-id = "com.pais.handy"; run = "move-node-to-workspace 9"; }
        { "if".app-id = "com.superduper.superwhisper"; run = "move-node-to-workspace 9"; }
        { "if".app-id = "com.todoist.mac.Todoist"; run = "move-node-to-workspace T"; }
        { "if".app-id = "com.apple.finder"; run = "move-node-to-workspace A"; }
        { "if".app-id = "com.apple.iBooksX"; run = "move-node-to-workspace B"; }
      ];
    };
  };
}
