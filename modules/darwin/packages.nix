{ pkgs, ... }: {
  # homebrew.brews = [ "mole" ];
  # homebrew.casks = [ "google-chrome" ];
  environment.systemPackages = [ pkgs.iina ];
}
