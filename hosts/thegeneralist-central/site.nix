{ config, pkgs, ... }:
let
  domain = "thegeneralist01.com";
	family_domain = builtins.getEnv "FAMILY_DOMAIN";

  ssl = {
    quic = true;
    useACMEHost = domain;
  };
in
{
  imports = [
    ./acme
    ./dns.nix
    ./jellyfin
  ];

  # Nginx
  services.nginx = {
    enable = true;
    package = pkgs.nginxQuic;
    enableQuicBPF = true;

    experimentalZstdSettings = true;
    recommendedUwsgiSettings = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedBrotliSettings = true;

    statusPage = true;
    validateConfigFile = true;

    virtualHosts."${domain}" = ssl // {
      root = "/var/www/${domain}";
      locations."/".tryFiles = "$uri $uri.html $uri/ $uri/index.html =404";

      extraConfig = ''
        if ($http_x_forwarded_proto = "http") {
          return 301 https://${domain}$request_uri;
        }

        location ~* \.(html|css|js|jpg|jpeg|png|gif|svg|ico|woff2?)$ {
          expires 1d;
          add_header Cache-Control "public";
        }

        error_page 404 /404.html;
      '';
    };

    virtualHosts."www.${domain}" = ssl // {
      locations."/".return = "306 https://${domain}$request_uri";
    };

    virtualHosts."${family_domain}" = {
      root = "/var/www/${family_domain}/dist";
      locations."/".tryFiles = "$uri $uri/index.html $uri.html =404";

      extraConfig = ''
        absolute_redirect off;

        location ~* \.(html|css|js|jpg|jpeg|png|gif|svg|ico)$ {
          expires 1d;
          add_header Cache-Control "public";
        }

        location ~* \.(ttf|woff2?)$ {
          expires 1y;
          add_header Cache-Control "public, immutable";
        }

        error_page 404 /404.html;
      '';
    };

    virtualHosts."www.${family_domain}" = {
      locations."/".return = "306 https://${family_domain}$request_uri";
    };

    # virtualHosts._ = ssl // {
    #   locations."/".return = "307 https://${domain}/404";
    # };
  };

  # Cloudflare
  environment.systemPackages = [ pkgs.cloudflared ];

  age.secrets.cftcert.file = ./cert.pem.age;
  age.secrets.cftcredentials.file = ./credentials.age;
  age.secrets.cftcredentials_personal.file = ./credentials_personal.age;

  services.cloudflared = {
    enable = true;
    certificateFile = config.age.secrets.cftcert.path;

    tunnels = {
      "site" = {
        ingress = {
          "thegeneralist01.com" = "http://localhost:80";
          "www.thegeneralist01.com" = "http://localhost:80";
          "cache.thegeneralist01.com" = "http://localhost:80";
          "git.thegeneralist01.com" = "http://localhost:3000";
        };
        default = "http_status:404";

        credentialsFile = config.age.secrets.cftcredentials.path;
        certificateFile = config.age.secrets.cftcert.path;
      };
      "personal" = {
        ingress = {
          "${family_domain}" = "http://localhost:80";
          "www.${family_domain}" = "http://localhost:80";
        };
        default = "http_status:404";

        credentialsFile = config.age.secrets.cftcredentials_personal.path;
        certificateFile = config.age.secrets.cftcert.path;
      };
    };
  };
}
