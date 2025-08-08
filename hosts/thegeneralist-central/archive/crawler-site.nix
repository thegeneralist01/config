let
  acmeDomain = "thegeneralist01.com";
  domain = "crawler.${acmeDomain}";

  ssl = {
    forceSSL = true;
    quic = true;
    useACMEHost = domain;
  };
in
{
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
      proxyPass = "http://127.0.0.1:8001";
      recommendedProxySettings = true;
      extraConfig = ''
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;

        # tell nginx not to buffer the response. send it as it comes.
        proxy_buffering off;

        # give jellyfin plenty of time to transcode
        proxy_read_timeout 3600s;
        proxy_send_timeout 3600s;
      '';
    };
  };
}
