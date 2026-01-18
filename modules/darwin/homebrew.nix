{
  homebrew-core,
  homebrew-cask,
  config,
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

    mutableTaps = false;
  };
}
