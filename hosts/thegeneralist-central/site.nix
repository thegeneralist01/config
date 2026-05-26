{ config, pkgs, ... }:
{
  imports = [
    ./acme
    ./dns.nix
    ./jellyfin
    ./plex
  ];

  # Nginx
  services.nginx = {
    enable = true;
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

    # Domain-specific virtual hosts live in the service modules below.
  };

  # Cloudflare
  environment.systemPackages = [ pkgs.cloudflared ];

  age.secrets.cftcert.file = ./cert.pem.age;
  age.secrets.cftcredentials.file = ./credentials.age;

  services.cloudflared = {
    enable = true;
    certificateFile = config.age.secrets.cftcert.path;

    tunnels = {
      "site" = {
        ingress = {
          "cache.thegeneralist01.com" = "http://localhost:80";
          "git.thegeneralist01.com" = "http://localhost:3000";
        };
        default = "http_status:404";

        credentialsFile = config.age.secrets.cftcredentials.path;
        certificateFile = config.age.secrets.cftcert.path;
      };
    };
  };
}
