{ pkgs, config, lib, ... }: let
  inherit (lib) optionals optionalAttrs;
in {
  environment.variables.EDITOR = "nvim";

  home-manager.sharedModules = [{
    programs.neovim = {
      enable = true;
    };

    home.sessionVariables = {
      EDITOR = "nvim";
    };

    home.packages = with pkgs; [
      # Lua
      luajitPackages.luarocks_bootstrap
      lua-language-server

      python313
      python313Packages.pip
      python313Packages.virtualenv

      nodejs
      nodePackages."sass"
    ] ++ optionals config.onLinux [
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
    } // optionalAttrs config.onLinux {
      ".config/i3status" = {
        source = ../dotfiles/i3status;
        force = true;
        recursive = true;
      };
    };

    # TODO: make this normal
    # programs.npm.npmrc = ''
    #   prefix=~/.npm-packages
    #   color=true
    # '';

    home.sessionPath = [ "node_modules/.bin" ];
  }];
}
