{ config, lib, pkgs, ... }: let
  inherit (lib) concatStringsSep const flatten getAttr mapAttrsToList mkForce unique;
in {
  users.defaultUserShell = pkgs.zsh;

  environment.sessionVariables.SHELLS = config.home-manager.users
  |> mapAttrsToList (const <| getAttr "shellsByPriority")
  |> flatten
  |> map (drv: "${drv}${drv.shellPath}")
  |> unique
  |> concatStringsSep ":";

  environment.shellAliases = {
    ls = mkForce null;
    l  = mkForce null;
  };
}
