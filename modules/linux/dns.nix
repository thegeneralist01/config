{ config, lib, ... }: let
  inherit (lib) concatStringsSep;
in {
  # TODO: add fallback & check other options
  services.resolved = {
    enable = true;

    extraConfig = config.dnsServers
      |> map (server: "DNS=${server}")
      |> concatStringsSep "\n";

    dnssec     = "true";
    dnsovertls = "true";
  };
}
