{ pkgs, ... }: {
  services.jellyfin = {
    user = "central";
    group = "central";
    logDir = "/var/log/jellyfin";
    enable = true;
    package = pkgs.jellyfin;
    dataDir = "/var/lib/jellyfin";
    cacheDir = "/Users/central/.cache/jellyfin";
    configDir = "/etc/jellyfin";
    openFirewall = true;
  };
}
