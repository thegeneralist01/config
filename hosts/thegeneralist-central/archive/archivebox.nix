{ pkgs, ... }:
{
  # virtualisation.docker.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
  virtualisation.oci-containers.containers = {
    archivebox = {
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

    pywb = {
      image = "docker.io/webrecorder/pywb";
      ports = [ "127.0.0.1:8001:8001" ];
      volumes = [
        "/mnt/usb/services/browsertrix/webrecorder/:/"
        "/mnt/usb/services/browsertrix/webrecorder/webarchive:/webarchive"
      ];
    };
  };

  environment.systemPackages = [ pkgs.docker ];
}
