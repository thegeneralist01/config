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

      python311

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
    } // optionalAttrs config.onLinux {
      ".config/i3status" = {
        source = ../dotfiles/i3status;
        force = true;
        recursive = true;
      };
    };

    # TODO: this
    # programs.npm.npmrc = ''
    #   prefix=~/.npm-packages
    #   color=true
    # '';
  }];
}
