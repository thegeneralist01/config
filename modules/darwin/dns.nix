{ config, lib, ... }: {
  networking.knownNetworkServices = [
    "Wi-Fi"
    "Firewall"
    "Thunderbolt Bridge"
  ];

  networking.dns = config.dnsServers
    |> map (lib.splitString "#")
    |> map lib.head;
}
