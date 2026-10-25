{ config, ... }:
{
  # Crosspost worker: publishes queued X/LinkedIn/Instagram posts for crosspost-app (Cloudflare).
  # Outbound HTTPS only. Module source: ~/personal/crosspost (flake input `crosspost`).
  age.secrets.crosspostApiToken.file = ./api-token.age;
  age.secrets.crosspostWorkerKey.file = ./worker-key.age;

  services.crosspost = {
    enable = true;
    appUrl = "https://crosspost-app.thegeneralist01.workers.dev";
    apiTokenFile = config.age.secrets.crosspostApiToken.path;
    privateKeyFile = config.age.secrets.crosspostWorkerKey.path;
  };
}
