{ pkgs, ... }:
let
  internalZoneFile = pkgs.writeText "internal.zone" ''
    $ORIGIN internal.thegeneralist01.com.
    @   IN SOA  ns.internal.thegeneralist01.com. thegeneralist01.proton.me. (
          2025071801 ; serial (yyyymmddXX)
          3600       ; refresh
          600        ; retry
          86400      ; expire
          3600       ; minimum
    )
        IN NS   ns.internal.thegeneralist01.com.
    ns  IN A    100.86.129.23
    @   IN A    100.86.129.23
  '';

  archiveZoneFile = pkgs.writeText "archive.zone" ''
    $ORIGIN archive.thegeneralist01.com.
    @   IN SOA  ns.archive.thegeneralist01.com. thegeneralist01.proton.me. (
          2025073101 ; serial (yyyymmddXX)
          3600       ; refresh
          600        ; retry
          86400      ; expire
          3600       ; minimum
    )
        IN NS   ns.archive.thegeneralist01.com.
    ns  IN A    100.86.129.23
    @   IN A    100.86.129.23
  '';
in
{
  services.coredns = {
    enable = true;
    config = ''
      internal.thegeneralist01.com:53 {
        file ${internalZoneFile}
        log
        errors
      }

      archive.thegeneralist01.com:53 {
        file ${archiveZoneFile}
        log
        errors
      }

      .:53 {
        forward . 100.100.100.100 45.90.28.181 45.90.30.181
        cache
        log
        errors
      }
    '';
  };

  networking.firewall.allowedUDPPorts = [ 53 ];
  networking.firewall.allowedTCPPorts = [ 53 ];
}
