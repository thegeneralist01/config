{ lib, pkgs, ... }:
let
  inherit (lib) getExe;
in
{
  environment.systemPackages = with pkgs; [
    gnupg
    difftastic
  ];

  home-manager.sharedModules = [
    {
      programs.difftastic = {
        enable = true;
        options.background = "dark";
      };
    }

    {
      programs = {
        gpg.enable = true;
        gh.enable = true;
        gh-dash.enable = true;
        difftastic.git.enable = true;

        git = {
          enable = true;
          lfs.enable = true;

          settings = {
            user.name = "TheGeneralist";
            user.email = "180094941+thegeneralist01@users.noreply.github.com";
            user.signingKey = "~/.ssh/id_ed25519";

            commit.gpgSign = true;
            tag.gpgSign = true;
            gpg.format = "ssh";
            gpg.program = getExe pkgs.gnupg;

            diff.algorithm = "histogram";
            diff.colorMoved = "default";

            pull.rebase = true;
            push.autoSetupRemote = true;

            merge.conflictStyle = "zdiff3";
            rebase.autoSquash = true;
            rebase.autoStash = true;
            rebase.updateRefs = true;
            rerere.enabled = true;

            fetch.fsckObjects = true;
            receive.fsckObjects = true;
            transfer.fsckobjects = true;

            # https://bernsteinbear.com/git
            alias.recent = "! git branch --sort=-committerdate --format=\"%(committerdate:relative)%09%(refname:short)\" | head -10";
          };
        };
      };

    }
  ];
}
