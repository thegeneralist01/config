{ lib, options, ... }: let
  inherit (lib) mkOption;
in {
  options.dnsServers = mkOption {
    default = [
      "45.90.28.0#365fed.dns.nextdns.io"
      "2a07:a8c0::#365fed.dns.nextdns.io"
      "45.90.30.0#365fed.dns.nextdns.io"
      "2a07:a8c1::#365fed.dns.nextdns.io"
      "100.100.100.100#shorthair-wall.ts.net"
    ];
  };
}
