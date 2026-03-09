{ pkgs, ... }:
let
  acmeDomain = "thegeneralist01.com";
  domain = "plex.${acmeDomain}";

  ssl = {
    forceSSL = true;
    quic = true;
    useACMEHost = domain;
  };

  plexDebUrl = "http://thegeneralist01.com/plexmediaserver_1.43.0.10492-121068a07_arm64.deb";
  plexDebSha256 = "1fkh09b46q70kicjprxf0v507idhg2jh3pk97nhbxj1jagkhgck2";
  plex = pkgs.stdenv.mkDerivation {
    pname = "plexmediaserver";
    version = "1.43.0.10492-121068a07";

    src = pkgs.fetchurl {
      url = plexDebUrl;
      sha256 = plexDebSha256;
    };

    nativeBuildInputs = [ pkgs.dpkg ];

    unpackPhase = ''
      dpkg-deb -x $src .
    '';

    installPhase = ''
  mkdir -p $out
  cp -r usr/* $out/

  mkdir -p $out/bin
  cat > $out/bin/plexmediaserver <<EOF
#!${pkgs.runtimeShell}

export PLEX_MEDIA_SERVER_HOME=$out/lib/plexmediaserver
export PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR="\$PLEX_DATADIR/Library/Application Support/Plex Media Server"
export LD_LIBRARY_PATH=$out/lib/plexmediaserver

exec "$out/lib/plexmediaserver/Plex Media Server" "\$@"
EOF

  chmod +x $out/bin/plexmediaserver
'';
  };

  config = ssl // {
    listen = [
      {
        addr = "100.86.129.23";
        port = 443;
        ssl = true;
      }
      {
        addr = "100.86.129.23";
        port = 80;
      }
    ];

    locations."/" = {
      proxyPass = "http://127.0.0.1:32400";
      proxyWebsockets = true;
      recommendedProxySettings = true;
      # https://arne.me/blog/plex-on-nixos
      extraConfig = ''
        # Some players don't reopen a socket and playback stops totally instead of resuming after an extended pause
        send_timeout 100m;
        # Plex headers
        proxy_set_header X-Plex-Client-Identifier $http_x_plex_client_identifier;
        proxy_set_header X-Plex-Device $http_x_plex_device;
        proxy_set_header X-Plex-Device-Name $http_x_plex_device_name;
        proxy_set_header X-Plex-Platform $http_x_plex_platform;
        proxy_set_header X-Plex-Platform-Version $http_x_plex_platform_version;
        proxy_set_header X-Plex-Product $http_x_plex_product;
        proxy_set_header X-Plex-Token $http_x_plex_token;
        proxy_set_header X-Plex-Version $http_x_plex_version;
        proxy_set_header X-Plex-Nocache $http_x_plex_nocache;
        proxy_set_header X-Plex-Provides $http_x_plex_provides;
        proxy_set_header X-Plex-Device-Vendor $http_x_plex_device_vendor;
        proxy_set_header X-Plex-Model $http_x_plex_model;
        # Buffering off send to the client as soon as the data is received from Plex.
        proxy_redirect off;
        proxy_buffering off;
        proxy_set_header   X-Real-IP           $remote_addr;
        proxy_set_header   X-Forwarded-For     $proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto   $scheme;
        proxy_set_header   Host                $host;
      '';
    };
  };
in
{
  services.plex = {
    enable = true;
    package = plex;
    dataDir = "/var/lib/plex";
    # openFirewall = true;
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/plex/Library/Application\\040Support/Plex\\ Media\\ Server 0755 plex plex -"
    "f /var/lib/plex/Library/Application\\040Support/Plex\\ Media\\ Server/Preferences.xml 0644 plex plex -"
  ];

  systemd.services.plex-fix-perms = {
    description = "Fix Plex library permissions";
    wants = [ "plex.service" ]; # Plex depends on this
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = ''
        mkdir -p "/var/lib/plex/Library/Application Support/Plex Media Server"
        chown -R plex:plex "/var/lib/plex/Library/Application Support/Plex Media Server"
      '';
    };
  };

  networking.firewall.interfaces."tailscale0" = {
    allowedTCPPorts = [ 3005 8324 32469 80 443 ];
    allowedUDPPorts = [ 1900 5353 32410 32412 32413 32414 ];
  };

  services.nginx.virtualHosts = {
    ${domain} = config;
    "100.86.129.23" = config;
  };

  systemd.services."plex".serviceConfig = {
    Wants = [ "tailscaled.service" ];
    After = [ "network-online.target" "tailscaled.service" ];
  };
}
