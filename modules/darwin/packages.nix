{ pkgs, ... }: {
  homebrew.enable = true;
  # homebrew.brews = [ "mole" ];
  homebrew.casks = [ "google-chrome" ];
  environment.systemPackages = [ pkgs.iina ];
}
