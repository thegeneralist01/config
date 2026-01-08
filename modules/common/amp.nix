{ config, lib, pkgs, ... }:
let
  enableAmp = (!config.onLinux) || (!config.isServer);
  ampHomeModule = { lib, pkgs, ... }: {
    home.sessionPath = [ "$HOME/.amp/bin" ];
    home.activation.ampInstall = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      amp_bin="$HOME/.amp/bin/amp"
      if [ -x "$amp_bin" ]; then
        exit 0
      fi

      export PATH="${lib.makeBinPath [
        pkgs.coreutils
        pkgs.gnugrep
        pkgs.curl
        pkgs.bash
      ]}:$PATH"

      # Prevent installer from trying to mutate shell rc files (Home Manager manages those).
      SHELL="amp-installer" ${pkgs.curl}/bin/curl -fsSL https://ampcode.com/install.sh | ${pkgs.bash}/bin/bash
    '';
  };
in
lib.mkIf enableAmp {
  home-manager.sharedModules = [ ampHomeModule ];
}
