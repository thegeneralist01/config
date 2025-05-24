{
  home-manager.sharedModules = [{
    programs.git = {
      enable = true;

      userName = "TheGeneralist";
      userEmail = "180094941+thegeneralist01@users.noreply.github.com";
      lfs = {
        enable = true;
      };

      extraConfig = {
        commit.gpgSign = true;
        tag.gpgSign = true;
        gpg.format = "ssh";
        user.signingKey = "~/.ssh/id_ed25519";
      };
    };

    programs.gh = {
      enable = true;
    };
    programs.gh-dash = {
      enable = true;
    };
  }];
}
