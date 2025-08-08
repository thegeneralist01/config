{ pkgs, ... }: {
  homebrew.enable = true;
  homebrew.casks = [ "ungoogled-chromium" ];
  environment.systemPackages = [ pkgs.iina ];
}
