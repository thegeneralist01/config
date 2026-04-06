{ lib, pkgs, ... }:
let
  inherit (lib) getExe;
in
{
  environment.systemPackages = [
    pkgs.carapace
    pkgs.fish
    pkgs.zsh
    pkgs.bash
    pkgs.inshellisense
  ];

  environment.variables.CARAPACE_BRIDGES = "inshellisense,carapace,zsh,fish,bash";

  home-manager.sharedModules = [{
    programs.carapace = {
      enable = true;
      enableNushellIntegration = false;
      enableZshIntegration = false;
    };

    programs.nushell.extraConfig = /* nu */ ''
      source ${
        pkgs.runCommand "carapace.nu" { } ''
          ${getExe pkgs.carapace} _carapace nushell > $out
        ''
      }
    '';
  }];
}
