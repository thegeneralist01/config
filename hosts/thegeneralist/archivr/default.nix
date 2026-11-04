{ config, pkgs, lib, ... }:
let
  domain = "mjr.shorthair-wall.ts.net";
in
{
  services.archivr-server = {
    enable = true;
    listenAddress = "127.0.0.1";
    port = 8080;
    archives = [
      {
        id = "personal";
        label = "Personal";
        path = "/mnt/usb/archivr/.archivr";
      }
    ];
    environment = {
      ARCHIVR_TWITTER_CREDENTIALS_FILE = "/mnt/usb/archivr/creds.txt";
    };
  };

  # Ensure data directory ownership and mounts
  systemd.services.archivr-data-ownership = {
    description = "Prepare archivr permissions on /mnt/usb/archivr and /var/lib/archivr-server";
    unitConfig.RequiresMountsFor = [ "/mnt/usb" ];
    before = [ "archivr-server.service" ];
    wantedBy = [ "archivr-server.service" ];
    serviceConfig.Type = "oneshot";
    script = ''
      ${pkgs.coreutils}/bin/mkdir -p /mnt/usb/archivr/.archivr/store/{raw,raw_tweets,structured,temp} /var/lib/archivr-server
      ${pkgs.coreutils}/bin/chown -R archivr:archivr /mnt/usb/archivr /var/lib/archivr-server
      ${pkgs.coreutils}/bin/chmod -R u=rwX,g=rwX,o=rX /mnt/usb/archivr
    '';
  };

  systemd.services.archivr-server = {
    requires = [ "archivr-data-ownership.service" ];
    after = [ "archivr-data-ownership.service" ];
    unitConfig.RequiresMountsFor = [ "/mnt/usb" ];
    serviceConfig = {
      Restart = lib.mkForce "always";
      RestartSec = lib.mkForce "10s";
    };
  };

  # Tailscale TLS certificate automation for HTTPS
  systemd.services.tailscale-cert-mjr = {
    description = "Fetch Tailscale TLS certificate for ${domain}";
    after = [ "network-online.target" "tailscaled.service" ];
    wants = [ "network-online.target" "tailscaled.service" ];
    before = [ "nginx.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "fetch-tailscale-cert-mjr" ''
        set -eu
        ${pkgs.coreutils}/bin/mkdir -p /var/lib/acme/${domain}
        ${pkgs.tailscale}/bin/tailscale cert \
          --cert-file /var/lib/acme/${domain}/fullchain.pem \
          --key-file /var/lib/acme/${domain}/key.pem \
          ${domain}
        ${pkgs.coreutils}/bin/chown -R acme:nginx /var/lib/acme/${domain}
        ${pkgs.coreutils}/bin/chmod 0750 /var/lib/acme/${domain}
        ${pkgs.coreutils}/bin/chmod 0640 /var/lib/acme/${domain}/*
        # --no-block: this unit is ordered before nginx, so a blocking reload would wait on this very job.
        if ${pkgs.systemd}/bin/systemctl is-active --quiet nginx.service; then
          ${pkgs.systemd}/bin/systemctl --no-block reload nginx.service || true
        fi
      '';
    };
  };

  systemd.timers.tailscale-cert-mjr = {
    description = "Daily renewal timer for Tailscale TLS certificate for ${domain}";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  # Nginx reverse proxy with HTTPS
  services.nginx.virtualHosts.${domain} = {
    forceSSL = true;
    sslCertificate = "/var/lib/acme/${domain}/fullchain.pem";
    sslCertificateKey = "/var/lib/acme/${domain}/key.pem";

    listen = [
      {
        addr = "100.108.125.63";
        port = 443;
        ssl = true;
      }
      {
        addr = "100.108.125.63";
        port = 80;
      }
    ];

    locations."/" = {
      proxyPass = "http://127.0.0.1:8080";
      recommendedProxySettings = true;
      extraConfig = ''
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;

        proxy_buffering off;
        proxy_read_timeout 3600s;
        proxy_send_timeout 3600s;
      '';
    };
  };
}
