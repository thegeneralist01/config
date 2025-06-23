{ config, ... }: {
  networking.hostName = if config.isServer then "thegeneralist-central" else "thegeneralist";
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;
}
