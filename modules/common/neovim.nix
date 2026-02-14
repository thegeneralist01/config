{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) optionals optionalAttrs;
in
{
  environment.variables.EDITOR = "nvim";

  home-manager.sharedModules = [
    {
      programs.neovim = {
        enable = true;
      };

      home.sessionVariables = {
        EDITOR = "nvim";
      };

      home.packages =
        with pkgs;
        [
          # Lua
          luajitPackages.luarocks_bootstrap
          lua-language-server

          python313
          python313Packages.pip
          uv
          python313Packages.virtualenv
          basedpyright
          black

          nodejs
          nodePackages."sass"
          pnpm_9
        ]
        ++ optionals config.onLinux [
          #gcc_multi
        ];

      home.file = {
        ".config/nvim" = {
          source = ../dotfiles/nvim;
          force = true;
          recursive = true;
        };
        ".npmrc" = {
          force = true;
          text = ''
            prefix=~/.npm-packages
            color=true
          '';
        };
      }
      // optionalAttrs config.onLinux {
        ".config/i3status" = {
          source = ../dotfiles/i3status;
          force = true;
          recursive = true;
        };
      };

      # TODO: the two from the last (below) should be somehow moved to their own files
      home.sessionVariables.PNPM_HOME =
        if config.isDarwin then "$HOME/Library/pnpm" else "$HOME/.local/share/pnpm";

      home.sessionPath = [
        "node_modules/.bin"
        "/opt/homebrew/bin"
        "$HOME/.npm-packages/bin"
        "$PNPM_HOME"
      ];
    }
  ];
}
