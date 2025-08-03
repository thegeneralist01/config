{ pkgs, ... }: {
  virtualisation.docker.enable = true;
  virtualisation.oci-containers.containers.archivebox = {
    image = "ghcr.io/archivebox/archivebox:main";
    ports = [ "127.0.0.1:8000:8000" ];
    volumes = [
      "/mnt/usb/services/archivebox/data:/data"
    ];
    environment = {
      ALLOWLIST_HOSTS = "localhost";
      CSRF_TRUSTED_ORIGINS = "https://archive.thegeneralist01.com,127.0.0.1:8000";
      REVERSE_PROXY_USER_HEADER = "X-Remote-User";
      REVERSE_PROXY_WHITELIST = "127.0.0.1/32,100.86.129.23/32";
    };
  };

  environment.systemPackages = [ pkgs.docker ];
}
