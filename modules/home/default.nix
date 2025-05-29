{ config, options, pkgs, inputs, lib, ... }: {
  home.username = "thegeneralist";
  home.homeDirectory = if options.onLinux then "/home/thegeneralist" else "/Users/thegeneralist";

  home.packages = with pkgs; [
    zip
    xz
    unzip

    mtr
    iperf3
    dnsutils
    ldns
    nmap

    file
    which
    tree
    gnupg
    btop

    pciutils
    usbutils

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  # or
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  # or
  #  /etc/profiles/per-user/thegeneralist/etc/profile.d/hm-session-vars.sh

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
