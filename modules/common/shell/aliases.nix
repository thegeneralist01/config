{
  environment.shellAliases = {
    # Basic file operations (from RGBCube)
    l   = "ls --all";
    la  = "ls --all";
    ll  = "ls --long";
    lla = "ls --long --all";
    sl  = "ls";

    cp = "cp --recursive --verbose --progress";
    mk = "mkdir";
    mv = "mv --verbose";
    rm = "rm --recursive --verbose";

    pstree = "pstree -g 3";
    tree   = "eza --tree --git-ignore --group-directories-first";

    # Editor aliases
    v   = "nvim .";
    vi  = "vim";
    vim = "nvim";

    # Utilities
    ff  = "fastfetch --load-config examples/10.jsonc";
    g   = "glimpse --interactive -o both -f llm.md";
    rn  = "yazi";
    cat = "bat";
    c   = "clear";

    # Eza aliases
    e   = "eza";
    ea  = "eza -a";
    el  = "eza -la";
    ela = "eza -la";

    # Git aliases
    gs  = "git status";
    ga  = "git add";
    gc  = "git commit";
    gp  = "git push";
    gl  = "git log";
    gd  = "git diff";
    gco = "git checkout";
    gb  = "git branch";
    gm  = "git merge";
    gr  = "git remote";
    gcl = "git clone";
    gst = "git stash";
    gpl = "git pull";

    # Rebuild helper
    rb = "nh darwin switch . -- --extra-experimental-features \"nix-command pipe-operators\"";
    rebuild = "${../../../rebuild.nu}";
  };
}
