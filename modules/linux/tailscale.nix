{ config, ...}: {
  age.secrets.tailscaleMarshall.file = ./tailscale-marshall.age;
  services.tailscale = {
    enable = true;
    interfaceName = "tailscale0";
    useRoutingFeatures = "both";
    openFirewall = true; # or false?
    extraUpFlags = [ "--ssh" ];
    extraSetFlags = [ "--advertise-exit-node" ];
    disableTaildrop = false;
    authKeyFile = config.age.secrets.tailscaleMarshall.path;
  };

  networking.firewall.enable = true;
  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  # for SSH
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.nameservers = [ "100.100.100.100" "8.8.8.8" "1.1.1.1" ];
}
