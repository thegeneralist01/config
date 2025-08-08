{ lib, pkgs, ... }:

{
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];

  # Wi-Fi stuff
  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXROOT";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/NIXBOOT";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [
    {
      device = "/dev/disk/by-label/swap";
    }
  ];

  # fileSystems."/mnt/usb" = {
  #   device = "/dev/disk/by-uuid/AADEEA03DEE9C7A1";
  #   fsType = "ntfs-3g";
  #   options = [
  #     "rw"
  #     "noatime"
  #   ];
  # };
  #
  boot.extraModprobeConfig = ''
    options usbcore autosuspend=-1
  '';

  environment.systemPackages = [ pkgs.hdparm ];

  services.udev.extraRules = ''
    ACTION=="add", KERNEL=="sda", RUN+="${pkgs.hdparm}/bin/hdparm -B 255 -S 0 /dev/sda"
  '';

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f0u5.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
