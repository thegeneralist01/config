{ lib, ... }:
let
  inherit (lib)
    filterAttrs
    mapAttrs'
    nameValuePair
    ;

  ompDotfiles = ../dotfiles/omp;

  # Only manage named files (force=true). Does NOT take over the whole agents/
  # directory, so stock `omp agents unpack` files can coexist.
  filesFromDir =
    relDir: targetPrefix:
    let
      dir = ompDotfiles + "/${relDir}";
      entries = filterAttrs (_: type: type == "regular") (builtins.readDir dir);
    in
    mapAttrs' (
      name: _:
      nameValuePair "${targetPrefix}/${name}" {
        source = dir + "/${name}";
        force = true;
      }
    ) entries;
in
{
  home-manager.sharedModules = [
    {
      home.file = {
        ".omp/agent/AGENTS.md" = {
          source = ompDotfiles + "/AGENTS.md";
          force = true;
        };
      }
      // filesFromDir "agents" ".omp/agent/agents"
      // filesFromDir "prompts" ".omp/agent/prompts";
    }
  ];
}
