{ config, lib, ... }: let
  inherit (lib) mkIf concatStringsSep;
in {
  services.resolved = mkIf (!config.isServer) {
    enable = true;

    extraConfig = config.dnsServers
      |> map (server: "DNS=${server}")
      |> concatStringsSep "\n";

    dnssec     = "true";
    dnsovertls = "true";
  };
}
