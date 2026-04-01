{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    attrNames
    attrValues
    const
    filterAttrs
    flatten
    listToAttrs
    mapAttrs
    mapAttrsToList
    readFile
    replaceStrings
    ;

  unstable = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
    sha256 = if (config.isServer) then "sha256:0fgmdh1j6qrx64wq8wk2hry2rjh3rkvz9pch29l8zn49nlndvxy2" else (if (config.onLinux) then "sha256:03plivnr4cg0h8v7djf9g2jra09r45pmdiirmy4lvl2n1d4yb7ac" else "sha256:16xi1yijq2ccbp8254zc0b5fgz0igxvyf4yn349wj2ggk4cl6dgn");
  }) { system = pkgs.stdenv.hostPlatform.system; };
  package = unstable.nushell;
in
{
  home-manager.sharedModules = [
    (
      homeArgs:
      let
        config' = homeArgs.config;

        environmentVariables =
          let
            variablesMap =
              config'.variablesMap
              |> mapAttrsToList (
                name: value: [
                  {
                    name = "\$${name}";
                    inherit value;
                  }
                  {
                    name = "\${${name}}";
                    inherit value;
                  }
                ]
              )
              |> flatten
              |> listToAttrs;
          in
          config.environment.variables
          |> mapAttrs (const <| replaceStrings (attrNames variablesMap) (attrValues variablesMap))
          |> filterAttrs (name: const <| name != "TERM");
      in
      {
        shells."0" = package;

        programs.nushell = {
          enable = true;
          inherit package;

          inherit environmentVariables;

          shellAliases =
            config.environment.shellAliases // { ls = "ls"; };

          configFile.text = readFile ./0_nushell.nu;
        };
      }
    )
  ];
}
