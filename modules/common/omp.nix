{ lib, pkgs, ... }:
let
  inherit (lib)
    filterAttrs
    mapAttrs'
    nameValuePair
    ;

  ompDotfiles = ../dotfiles/omp;
  modelSettings = pkgs.writeText "omp-models.json" (
    builtins.toJSON (import (ompDotfiles + "/models.nix"))
  );

  # Only manage named files (force=true). Does NOT take over the whole agents/
  # directory, so stock `omp agents unpack` files can coexist.
  filesFromDir =
    relDir: targetPrefix:
    let
      dir = ompDotfiles + "/${relDir}";
      entries = filterAttrs (_: type: type == "regular") (builtins.readDir dir);
    in
    mapAttrs'
      (
        name: _:
        nameValuePair "${targetPrefix}/${name}" {
          source = dir + "/${name}";
          force = true;
        }
      )
      entries;
in
{
  home-manager.sharedModules = [
    (
      { lib, ... }:
      {
        home.file = {
          ".omp/agent/AGENTS.md" = {
            source = ompDotfiles + "/AGENTS.md";
            force = true;
          };
        }
        // filesFromDir "agents" ".omp/agent/agents"
        // filesFromDir "prompts" ".omp/agent/prompts";

        # OMP writes this file itself; replace only the repo-owned routing sections.
        home.activation.ompModels = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          (
            config="$HOME/.omp/agent/config.yml"
            if [ -n "''${DRY_RUN:-}" ]; then
              echo "Apply repo-managed OMP model routing to $config"
            else
              ${pkgs.coreutils}/bin/install -d -m 700 "$HOME/.omp/agent"
              if [ ! -e "$config" ]; then
                ${pkgs.coreutils}/bin/install -m 600 /dev/null "$config"
              fi
              ${lib.getExe pkgs.yq-go} -i '
                .modelRoles = load("${modelSettings}").modelRoles |
                .task.agentModelOverrides = load("${modelSettings}").task.agentModelOverrides |
                .modelPresets = load("${modelSettings}").modelPresets
              ' "$config"
            fi
          )
        '';
      }
    )
  ];
}
