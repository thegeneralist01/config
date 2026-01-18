{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    attrsToList
    catAttrs
    const
    flatten
    getAttr
    mapAttrsToList
    mkIf
    mkOption
    sortOn
    toInt
    unique
    ;

  mkConst =
    value:
    mkOption {
      default = value;
      readOnly = true;
    };

  mkValue =
    default:
    mkOption {
      inherit default;
    };
in
{
  environment.shells =
    config.home-manager.users
    |> mapAttrsToList (const <| getAttr "shellsByPriority")
    |> flatten
    |> unique;

  home-manager.sharedModules = [

    (
      homeArgs:
      let
        config' = homeArgs.config;
      in
      {
        options.shells = mkValue { };

        options.shellsByPriority = mkConst (
          config'.shells |> attrsToList |> sortOn ({ name, ... }: toInt name) |> catAttrs "value"
        );

        options.variablesMap = mkConst {
          HOME = config'.home.homeDirectory;
          USER = config'.home.username;

          XDG_CACHE_HOME = config'.xdg.cacheHome;
          XDG_CONFIG_HOME = config'.xdg.configHome;
          XDG_DATA_HOME = config'.xdg.dataHome;
          XDG_STATE_HOME = config'.xdg.stateHome;
        };
      }
    )

    (mkIf config.isDarwin (
      homeArgs:
      let
        config' = homeArgs.config;
      in
      {
        home.file.".zshrc".text = # zsh
          ''
            export PATH="/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/etc/profiles/per-user/$USER/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin''${PATH:+:}''${PATH}"
            source ${config'.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh

            if [ -z "$INTELLIJ_ENVIRONMENT_READER" ]; then
              SHELL='${lib.getExe <| lib.head config'.shellsByPriority}' exec "$SHELL"
            fi
          '';
      }
    ))

  ];
}
