{ lib, options, ... }: let
  inherit (lib) mkOption;
in {
  options.dnsServers = mkOption {
    default = [
      "45.90.28.181#365fed.dns.nextdns.io"
      "45.90.30.181#365fed.dns.nextdns.io"
      "100.100.100.100#shorthair-wall.ts.net"
    ];
  };
}
