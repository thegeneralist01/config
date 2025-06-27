{ config, pkgs, ... }: let
  domain = "thegeneralist01.com";
in {
  environment.systemPackages = [ pkgs.cloudflared ];

  services.nginx = {
    enable = true;

    virtualHosts = {
      "${domain}" = {
        root = "/var/www/${domain}";
        locations."/".tryFiles = "$uri $uri/ $uri/index.html";
      };
    };
  };

  age.secrets.cftcert.file = ./cert.pem.age;
  age.secrets.cftcredentials.file = ./credentials.age;

  services.cloudflared = {
    enable = true;
    certificateFile = config.age.secrets.cftcert.path;
    tunnels."site" = {
      ingress = {
        "thegeneralist01.com" = "http://localhost:80";
        "www.thegeneralist01.com" = "http://localhost:80";
      };
      default = "http_status:404";
      credentialsFile = config.age.secrets.cftcredentials.path;
      certificateFile = config.age.secrets.cftcert.path;
    };
  };
}
