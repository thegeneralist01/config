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
    getExe
    mapAttrsToList
    mkBefore
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

    (
      homeArgs:
      let
        config' = homeArgs.config;
        nuExe = getExe (lib.head config'.shellsByPriority);
        fishPromptBody = ''
          set -l last_status $status

          set -l pwd_display (prompt_pwd)
          set -l workspace_root
          set -l workspace_subpath

          if command -sq jj
            set workspace_root (jj workspace root ^/dev/null)
            if test $status -eq 0 -a -n "$workspace_root"
              set workspace_subpath (path relative -- $PWD $workspace_root)
            end
          end

          set -l path_segment
          if test -n "$workspace_root"
            set -l workspace_name (basename "$workspace_root")
            if test -n "$workspace_subpath" -a "$workspace_subpath" != "."
              set path_segment (set_color bryellow)$workspace_name(set_color magenta)' → '(set_color blue)$workspace_subpath
            else
              set path_segment (set_color bryellow)$workspace_name
            end
          else
            set path_segment (set_color cyan)$pwd_display
          end

          set -l prefix
          if test $last_status -ne 0
            set prefix (set_color brred)$last_status(set_color yellow)'┣'
          end

          set -l duration_segment
          if set -q CMD_DURATION; and test "$CMD_DURATION" -gt 2000
            set duration_segment (set_color brmagenta)(math --scale 2 "$CMD_DURATION / 1000")s
          end

          set -l left_prefix (set_color bryellow)'┏'
          if test -n "$prefix"
            set left_prefix "$left_prefix$prefix"
          end
          if test -n "$duration_segment"
            set left_prefix "$left_prefix"(set_color bryellow)'┣'"$duration_segment"
          end
          set left_prefix "$left_prefix"(set_color bryellow)'━'(set_color normal)

          set -l suffix_parts
          if set -q IN_NIX_SHELL; and test -n "$IN_NIX_SHELL"
            set suffix_parts $suffix_parts (set_color brblue)'nix'(set_color normal)
          end
          if set -q VIRTUAL_ENV_PROMPT; and test -n "$VIRTUAL_ENV_PROMPT"
            set suffix_parts $suffix_parts (set_color brgreen)$VIRTUAL_ENV_PROMPT(set_color normal)
          end

          set -l suffix ""
          if test (count $suffix_parts) -gt 0
            set suffix ' '
            for item in $suffix_parts
              set suffix "$suffix"(set_color bryellow)'• '(set_color normal)"$item "
            end
            set suffix (string trim --right -- $suffix)
          end

          echo
          echo -n "$left_prefix$path_segment$suffix"
          echo
          echo -n (set_color bryellow)'┃'(set_color normal)' '
        '';
        fishRightPromptBody = ''
          set -l parts

          if command -sq jj
            set -l jj_status (jj --quiet --color always --ignore-working-copy log --no-graph --revisions @ --template '
              separate(
                " ",
                if(empty, label("empty", "(empty)")),
                coalesce(
                  surround(
                    "\"",
                    "\"",
                    if(
                      description.first_line().substr(0, 24).starts_with(description.first_line()),
                      description.first_line().substr(0, 24),
                      description.first_line().substr(0, 23) ++ "…"
                    )
                  ),
                  label(if(empty, "empty"), description_placeholder)
                ),
                bookmarks.join(", "),
                change_id.shortest(),
                commit_id.shortest(),
                if(conflict, label("conflict", "(conflict)")),
              )
            ' ^/dev/null)
            if test $status -eq 0 -a -n "$jj_status"
              set parts $parts $jj_status
            end
          end

          if set -q SSH_CONNECTION; and test -n "$SSH_CONNECTION"
            set parts $parts (set_color brgreen)'@'(prompt_hostname)(set_color normal)
          end

          if test (count $parts) -gt 0
            echo -n (string join ' ' $parts)
          end
        '';
        nuExecCondition =
          if config.isDarwin then
            ''
              [[ $- == *i* ]] && [ -z "$skip" ] && [ -t 1 ]
            ''
          else
            ''[ -z "$INTELLIJ_ENVIRONMENT_READER" ] && [ -z "$skip" ] && [ -z "$SSH_TTY" ]'';
      in
      {
        programs.fish = {
          enable = true;

          interactiveShellInit = ''
            set -g fish_greeting
            set -g fish_key_bindings fish_vi_key_bindings
            set -g fish_cursor_default block
            set -g fish_cursor_insert line
            set -g fish_cursor_replace_one underscore
            set -g fish_cursor_visual block
            set -g fish_cursor_external line
          '';

          shellInitLast = ''
            if set -q GHOSTTY_RESOURCES_DIR
              source "$GHOSTTY_RESOURCES_DIR/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish" 2>/dev/null
            end
          '';

          functions = {
            fish_prompt.body = fishPromptBody;
            fish_right_prompt.body = fishRightPromptBody;
          };
        };

        programs.zsh.initContent = mkBefore # zsh
          ''
            export PATH="$HOME/.local/bin:/run/wrappers/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/etc/profiles/per-user/$USER/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin''${PATH:+:}''${PATH}"
            source ${config'.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh

            if ${nuExecCondition}; then
              parent_cmd="$(ps -o command= -p "$PPID" 2>/dev/null || true)"
              case "$parent_cmd" in
                *"/Applications/Zed.app/Contents/MacOS/zed --printenv"*) return ;;
              esac
              export SHELL='${nuExe}'
              exec "$SHELL"
            fi
          '';
      }
    )
  ];
}
