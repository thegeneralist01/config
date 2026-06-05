{ config, lib, ... }: let
  inherit (lib) mkIf;
in {
  services.resolved = mkIf (!config.isServer) {
    enable = true;

    settings.Resolve = {
      DNS = config.dnsServers;
      DNSSEC = true;
      DNSOverTLS = true;
    };
  };
}
