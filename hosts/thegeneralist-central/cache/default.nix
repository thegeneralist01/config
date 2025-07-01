{ pkgs, config, ... }: let
  domain = "cache.thegeneralist01.com";

  ssl = {
    quic        = true;
    useACMEHost = "thegeneralist01.com";
  };
in {
  age.secrets.cacheSigningKey.file = ./key.age;
  services.nix-serve = {
    enable = true;
    package = pkgs.nix-serve-ng;
    secretKeyFile = config.age.secrets.cacheSigningKey.path;
    port = 1337;
    openFirewall = false;
  };

  services.nginx.virtualHosts.${domain} = ssl // {
    locations."/".proxyPass = "http://127.0.0.1:1337";
    locations."= /".return = "301 @404";
    locations."@404".return = "404 https://thegeneralist01.com/404";

    extraConfig = /* nginx */ ''
      proxy_intercept_errors on;
      error_page 404 = @404;
    '';
  };
}
