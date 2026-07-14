{ pkgs, lib, ... }:
let
  inherit (lib) getExe;
in
{
  home-manager.sharedModules = [
    {
      programs.jujutsu = {
        enable = true;

        settings = {
          user = {
            name = "TheGeneralist";
            email = "180094941+thegeneralist01@users.noreply.github.com";
          };

          ui = {
            default-command = "log";
            diff-formatter = [ (getExe pkgs.difftastic) "--color=always" ];
            graph.style = "curved";
            pager = ":builtin";
          };

          aliases = {
            ".."  = [ "edit" "@-" ];
            ",,"  = [ "edit" "@+" ];
            tug   = [ "bookmark" "set" "main" "-r" "@-" ];
            ship  = [ "git" "push" "--bookmark" "main" ];
          };

          remotes.origin.auto-track-bookmarks = "glob:*";
        };
      };
    }
  ];
}
