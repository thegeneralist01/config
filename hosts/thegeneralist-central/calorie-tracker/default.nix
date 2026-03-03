{ pkgs, inputs, ... }:
let
  sourceDir = "${inputs.calorie-tracker}";
  appDir = "/var/lib/calorie-tracker/app";
  dataDir = "/var/lib/calorie-tracker";
  port = 4322;

  acmeDomain = "thegeneralist01.com";
  domain = "calorie.${acmeDomain}";

  ssl = {
    forceSSL = true;
    quic = true;
    useACMEHost = acmeDomain;
  };
in
{
  systemd.services.calorie-tracker = {
    description = "Calorie Tracker";
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];

    environment = {
      NODE_ENV = "production";
      HOST = "127.0.0.1";
      PORT = toString port;
      DATABASE_URL = "file:${dataDir}/dev.db";
      PRISMA_ENGINES_CHECKSUM_IGNORE_MISSING = "1";

      PRISMA_FMT_BINARY = "${pkgs.prisma-engines}/bin/prisma-fmt";
      PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/schema-engine";
      PRISMA_QUERY_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/query-engine";
      PRISMA_QUERY_ENGINE_LIBRARY = "${pkgs.prisma-engines}/lib/libquery_engine.node";
    };

    path = with pkgs; [
      bash
      coreutils
      gnused
      nodejs_22
      prisma
      prisma-engines
      rsync
      sqlite
    ];

    preStart = ''
      mkdir -p ${appDir}
      rsync -a --delete --exclude ".git" --exclude "node_modules" --exclude "dist" --exclude ".astro" ${sourceDir}/ ${appDir}/
      chmod -R u+rwX ${appDir}

      cd ${appDir}

      if [ ! -f .env ]; then
        cp .env.example .env
      fi

      sed -i 's#^DATABASE_URL=.*#DATABASE_URL="file:${dataDir}/dev.db"#' .env

      if [ ! -d node_modules ] || [ ! -d node_modules/@astrojs/node ] || [ ! -d node_modules/server-destroy ] || [ ! -d node_modules/@vite-pwa/astro ] || [ ! -d node_modules/@astrojs/check ]; then
        npm ci --include=dev --no-fund --no-audit
      fi

      sqlite3 "${dataDir}/dev.db" < ${./schema.sql}

      npm run prisma:generate
      rm -rf dist
      npm run build
    '';

    serviceConfig = {
      Type = "simple";
      User = "thegeneralist";
      Group = "users";
      StateDirectory = "calorie-tracker";
      StateDirectoryMode = "0750";
      # Keep working dir on the guaranteed StateDirectory path so preStart can
      # create ${appDir} on first boot/deploy before ExecStart runs.
      WorkingDirectory = dataDir;
      ExecStart = "${pkgs.nodejs_22}/bin/node ${appDir}/dist/server/entry.mjs";
      KillMode = "mixed";
      Restart = "always";
      RestartSec = 5;
    };
  };

  # services.nginx.virtualHosts.${domain} = ssl // {
  #   locations."/" = {
  #     proxyPass = "http://127.0.0.1:${toString port}";
  #     proxyWebsockets = true;
  #     recommendedProxySettings = true;
  #     extraConfig = ''
  #       proxy_read_timeout 300s;
  #       proxy_send_timeout 300s;
  #     '';
  #   };
  # };
}
