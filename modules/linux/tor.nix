{
  services.tor = {
    enable = true;
    settings = {
      # WE DO NOT WANT GERMAN NODES ANYWHERE IN THE CIRCUIT!!!!
      ExcludeExitNodes = "{de}";
      ExcludeNodes = "{de}";
      StrictNodes = 1;

      # optionally also avoid unknown-geoip nodes
      GeoIPExcludeUnknown = 1;

      # listen on socks5 port for local apps (like transmission/qbittorrent)
      SOCKSPort = "9050";
    };
  };
  services.transmission = {
    enable = true;
    settings = {
      proxy = "socks5://127.0.0.1:9050"; # assuming tor daemon
      proxy-auth-enabled = false;
    };
  };
}
