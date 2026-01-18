{ lib, pkgs, ... }: let
  inherit (lib) getExe;
  zoxide = getExe pkgs.zoxide;
in {
  home-manager.sharedModules = [{
    programs.zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
      enableNushellIntegration = false;
    };

    programs.nushell.extraConfig = /* nu */ ''
      # Zoxide integration with full path
      $env.config = ($env.config? | default {})
      $env.config.hooks = ($env.config.hooks? | default {})
      $env.config.hooks.env_change = ($env.config.hooks.env_change? | default {})
      $env.config.hooks.env_change.PWD = ($env.config.hooks.env_change.PWD? | default [])

      let __zoxide_hooked = ($env.config.hooks.env_change.PWD | any { try { get __zoxide_hook } catch { false } })
      if not $__zoxide_hooked {
        $env.config.hooks.env_change.PWD = ($env.config.hooks.env_change.PWD | append {
          __zoxide_hook: true,
          code: {|_, dir| ${zoxide} add -- $dir}
        })
      }

      def --env __zoxide_z [...rest: string] {
        let path = if ($rest | length) == 0 {
          $env.HOME
        } else if ($rest | length) == 1 and ($rest.0 == "-") {
          $env.OLDPWD
        } else {
          ${zoxide} query --exclude (pwd) -- ...$rest | str trim -r -c (char newline)
        }
        cd $path
      }

      def --env __zoxide_zi [...rest: string] {
        let path = ${zoxide} query --interactive -- ...$rest | str trim -r -c (char newline)
        cd $path
      }

      alias cd = __zoxide_z
      alias cdi = __zoxide_zi
    '';
  }];
}
