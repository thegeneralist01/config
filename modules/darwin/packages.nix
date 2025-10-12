{ pkgs, ... }: {
  homebrew.enable = true;
  homebrew.casks = [ "google-chrome" ];
  environment.systemPackages = [ pkgs.iina ];
}
