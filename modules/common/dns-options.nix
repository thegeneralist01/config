{ lib, ... }: let
  inherit (lib) mkOption;
in {
  options.dnsServers = mkOption {
    default = [
      "100.100.100.100#shorthair-wall.ts.net"
      "1.1.1.1#"
    ];
  };
}
