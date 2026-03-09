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
      runHook preUnpack
      dpkg-deb -x $src .
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r usr/* $out/
      runHook postInstall
    '';
  };
in
{
  services.plex = {
    enable = true;
    package = plex;
    # openFirewall = true;
  };

  networking.firewall.interfaces."tailscale0" = {
    allowedTCPPorts = [ 3005 8324 32469 80 443 ];
    allowedUDPPorts = [ 1900 5353 32410 32412 32413 32414 ];
  };

  services.nginx.virtualHosts.${domain} = ssl // {
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
      '';
    };
  };
}
