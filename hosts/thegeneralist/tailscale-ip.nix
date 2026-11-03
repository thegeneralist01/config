# Boot ordering for services that bind this host's Tailscale address directly.
#
# nginx (every vhost: archive, archivr, jellyfin, plex) and coredns listen on
# 100.108.125.63, not on 0.0.0.0. That address only appears on tailscale0 once
# tailscaled has logged in, which happens some seconds AFTER tailscaled.service
# reports "started". Ordering after tailscaled.service is therefore not enough:
# before this unit existed nginx failed 2-3 times per boot with "Cannot assign
# requested address" and only came up through its Restart=always retry loop.
#
# tailscale-ip-ready is a oneshot that blocks until the address is really
# present; nginx and coredns are ordered after it. `wants` (not `requires`):
# if Tailscale never connects the wait times out, the unit fails, and nginx and
# coredns still start and fall back to their own restart loops instead of
# staying down.
#
# Deliberately NOT net.ipv4.ip_nonlocal_bind = 1: that lets every service bind
# any address, so a typo in a listen address would silently stop failing.
{ pkgs, ... }:
let
  # Must match the `listen.addr` entries of the nginx vhosts and the coredns `bind` lines.
  tailscaleAddress = "100.108.125.63";
in
{
  systemd.services.tailscale-ip-ready = {
    description = "Wait until tailscale0 has ${tailscaleAddress}";
    after = [ "tailscaled.service" ];
    wants = [ "tailscaled.service" ];
    serviceConfig = {
      Type = "oneshot";
      # Stays "active" after the check so later start jobs don't re-run the wait.
      RemainAfterExit = true;
      TimeoutStartSec = "2min";
    };
    script = ''
      until ${pkgs.iproute2}/bin/ip -4 -o addr show dev tailscale0 2>/dev/null \
        | ${pkgs.gnugrep}/bin/grep -qF ' ${tailscaleAddress}/'; do
        sleep 1
      done
    '';
  };

  systemd.services.nginx = {
    after = [ "tailscale-ip-ready.service" ];
    wants = [ "tailscale-ip-ready.service" ];
  };

  systemd.services.coredns = {
    after = [ "tailscale-ip-ready.service" ];
    wants = [ "tailscale-ip-ready.service" ];
  };
}
