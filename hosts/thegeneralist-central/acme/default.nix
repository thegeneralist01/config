{ config, ... }: let
  domain = "thegeneralist01.com";
in {
  age.secrets.acmeEnvironment.file = ./acmeEnvironment.age;

  security.acme = {
    defaults = {
      # Options: https://go-acme.github.io/lego/dns/acme
      environmentFile = config.age.secrets.acmeEnvironment.path;
      email = "thegeneralist01@proton.me";
      dnsResolver = "1.1.1.1";
      dnsProvider = "cloudflare";
    };

    certs = {
      ${domain} = {
        extraDomainNames = [ "*.${domain}" ];
        group = "acme";
      };
      "git.${domain}" = {
        group = "acme";
      };
      "internal.${domain}" = {
        group = "acme";
      };
      "archive.${domain}" = {
        group = "acme";
      };
      "crawler.${domain}" = {
        group = "acme";
      };
    };

    acceptTerms = true;
  };

  users.groups.acme.members = [ "nginx" ];
}
