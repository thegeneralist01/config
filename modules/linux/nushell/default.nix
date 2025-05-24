{ config, pkgs, lib, ... }: let
  inherit (lib) readFile;
in {
  # TODO: starship + change the zoxide src
  # TODO: Rust tooling
  environment = {
    systemPackages = with pkgs; [
      nushell
      zoxide
      ripgrep
      jq
      yq-go
      eza
      fzf
      gh
      fastfetch
    ];

    shellAliases = {
      v = "nvim .";
      ff = "fastfetch --load-config examples/10.jsonc";
      g = "glimpse --interactive -o both -f llm.md";
      gg = "open llm.md | save -r /dev/stdout | ^xclip -sel c";
      rn = "yazi";
      c = "clear";
      e = "exa";
      el = "exa -la";
      l = "ls -a";
      ll = "ls -la";
      cl = "c; l";
      ap = "cd ~/personal";
      ad = "cd ~/Downloads";
      ab = "cd ~/books";
      a = "cd ~";
      ah = "cd ~/dotfiles/hosts/thegeneralist";
      ai3 = "nvim /home/thegeneralist/dotfiles/hosts/thegeneralist/dotfiles/i3/config";
      rb = "nh os switch . -v -- --show-trace --verbose";
    };
  };

  home-manager.sharedModules = [{
    programs.nushell = {
      enable = true;
      configFile.text = readFile ./config.nu;
      envFile.text = readFile ./env.nu;
      environmentVariables = config.environment.variables;
    };
  }];
}
