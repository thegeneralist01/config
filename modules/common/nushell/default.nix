{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    readFile
    getExe
    mkAfter
    mkIf
    optionalAttrs
    ;
in
{
  # TODO: starship + change the zoxide src
  # TODO: Rust tooling
  environment =
    optionalAttrs config.onLinux {
      sessionVariables.SHELLS = [
        (getExe pkgs.nushell)
        (getExe pkgs.zsh)
      ];
    }
    // {
      shells = mkIf (!config.onLinux) [
        pkgs.nushell
        pkgs.zsh
      ];

      systemPackages = with pkgs; [
        nushell
        fish
        zoxide
        vivid
        ripgrep
        yazi
        jq
        yq-go
        eza
        fzf
        gh
        fastfetch
        carapace
        bat
        bat-extras.core
      ];

      shellAliases = {
        v = "nvim .";
        vi = "vim";
        vim = "nvim";

        ff = "fastfetch --load-config examples/10.jsonc";

        g = "glimpse --interactive -o both -f llm.md";
        gg = "open llm.md | save -r /dev/stdout | ^xclip -sel c";
        rn = "yazi";
        cat = "bat";
        c = "clear";
        e = "exa";
        ea = "exa -a";
        el = "exa -la";
        l = "ls -a";
        la = "ls -a";
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

  home-manager.sharedModules = [
    {
      home = {
        sessionPath = [ "$HOME/.amp/bin" "$HOME/.npm-packages/bin" "/opt/homebrew/bin" ];
        file = {
          ".zshrc" =
            let
              configFile = ./config.nu;
              envFile = ./env.nu;
            in
            {
              text = "exec nu --env-config ${envFile} --config ${configFile}";
              force = true;
            };

          ".config/nushell/zoxide.nu".source = pkgs.runCommand "zoxide.nu" { } ''
            ${getExe pkgs.zoxide} init nushell --cmd cd > $out
          '';

          ".config/nushell/ls_colors.txt".source = pkgs.runCommand "ls_colors.txt" { } ''
            ${getExe pkgs.vivid} generate gruvbox-dark-hard > $out
          '';
        };
      };
    }
    (homeArgs: {
      programs.nushell = {
        enable = true;
        package = pkgs.nushell;
        configFile.text = readFile ./config.nu;
        envFile.text = readFile ./env.nu;
        environmentVariables = config.environment.variables // homeArgs.config.home.sessionVariables;
      };
      programs.carapace = {
        enable = true;
        enableZshIntegration = true;
        enableNushellIntegration = true;
      };
      programs.zsh = {
        enable = true;
        sessionVariables = config.environment.variables // homeArgs.config.home.sessionVariables;
      };
      home.sessionPath = [ "/Users/thegeneralist/.cargo/bin" ];
    })
  ];
}
