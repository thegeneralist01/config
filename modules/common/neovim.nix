{ pkgs, options, lib, ... }: {
  environment.variables.EDITOR = "nvim";

  home-manager.sharedModules = [{
    programs.neovim = {
      enable = true;
      extraLuaConfig = lib.fileContents ../home/dotfiles/nvim/init.lua;
    };

    home.sessionVariables = {
      EDITOR = "nvim";
    };

    home.packages = with pkgs; [
      vimPlugins.markdown-preview-nvim

      # Lua
      luajitPackages.luarocks_bootstrap
      lua-language-server

      python311

      nodejs
      nodePackages."sass"

      gcc_multi
      #llvmPackages_20.clangWithLibcAndBasicRtAndLibcxx
    ];

    home.file = lib.mkIf options.onLinux {
      ".config/i3status" = {
        source = ../home/dotfiles/i3status;
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
