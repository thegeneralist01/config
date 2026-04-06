{ lib, pkgs, ... }:
{
  home-manager.sharedModules = [
    {
      programs.zoxide = {
        enable = true;
        options = [ "--cmd cd" ];
        enableNushellIntegration = true;
        enableZshIntegration = false;
      };
    }
  ];
}
