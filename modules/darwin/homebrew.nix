{
  homebrew-core,
  homebrew-cask,
  steipete-tap,
  config,
  lib,
  ...
}:
{
  homebrew = {
    enable = true;
  };

  nix-homebrew = {
    enable = true;

    user = config.system.primaryUser;

    taps."homebrew/homebrew-core" = homebrew-core;
    taps."homebrew/homebrew-cask" = homebrew-cask;
    taps."steipete/tap" = steipete-tap;

    mutableTaps = true;
  };

  system.activationScripts.preActivation.text = lib.mkAfter ''
    if [[ -L /opt/homebrew/Library/Taps ]]; then
      rm -f /opt/homebrew/Library/Taps
    fi
    mkdir -p /opt/homebrew/Library/Taps
    chown ${config.system.primaryUser}:admin /opt/homebrew/Library/Taps
    chmod ug=rwx /opt/homebrew/Library/Taps
  '';
}
