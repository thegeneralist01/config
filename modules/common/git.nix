{ lib, pkgs, ... }: let
  inherit (lib) getExe;
in {
  environment.systemPackages = with pkgs; [
    gnupg
  ];

  home-manager.sharedModules = [{
    programs = {
      gpg.enable = true;
      gh.enable = true;
      gh-dash.enable = true;
      git = {
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
          gpg.program = getExe pkgs.gnupg;
          user.signingKey = "~/.ssh/id_ed25519";
        };
      };
    };

  }];
}
