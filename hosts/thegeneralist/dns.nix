{ pkgs, lib, ... }:
let
  subdomains = [ "internal" "archive" "plex" ];

  mainZoneFile = pkgs.writeText "thegeneralist01.zone" ''
    $ORIGIN thegeneralist01.com.
    @   IN SOA  ns.thegeneralist01.com. thegeneralist01.proton.me. (
          2025081501 ; serial (yyyymmddXX)
          3600       ; refresh
          600        ; retry
          86400      ; expire
          3600       ; minimum
    )
        IN NS   ns.thegeneralist01.com.
    ns  IN A    100.108.125.63
    ${lib.concatStringsSep "\n" (lib.map (sub: "${sub} IN A 100.108.125.63") subdomains)}
  '';

  forwarderBlock = ''
    .:53 {
      bind 100.108.125.63
      forward . 100.100.100.100 45.90.28.181 45.90.30.181
      cache
      log
      errors
    }
  '';
in
{
  services.coredns = {
    enable = true;
    config = ''
      thegeneralist01.com:53 {
        bind 100.108.125.63
        file ${mainZoneFile}
        log
        errors
      }

      ${forwarderBlock}
    '';
  };

  systemd.services.coredns = {
    wants = [ "network-online.target" "tailscaled.service" ];
    after = [ "network-online.target" "tailscaled.service" ];
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "2s";
    };
  };

}
