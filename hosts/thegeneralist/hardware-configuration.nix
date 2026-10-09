{ config, lib, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];

  # Wi-Fi stuff
  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;
  boot.kernelModules = [ "kvm-intel" "rtw_8822bu" ];

  # RTL8822BU is unreliable after switching itself to USB 3 mode and can
  # fail enumeration with EPROTO (-71). Keep it in USB 2 mode and disable
  # the power-saving states that can wedge rtw88 USB adapters.
  boot.extraModprobeConfig = ''
    options rtw88_usb switch_usb_mode=N
    options rtw88_core disable_lps_deep=1
  '';
  boot.kernelParams = [ "usbcore.autosuspend=-1" ];
  networking.networkmanager.wifi.powersave = false;

  fileSystems."/" =
    {
      device = "/dev/disk/by-label/NIXROOT";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-label/NIXBOOT";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  fileSystems."/mnt/usb" = {
    device = "/dev/disk/by-uuid/3c832d43-e9f4-424d-9185-0ff6a275a180";
    fsType = "ext4";
    options = [
      "nofail"
      "x-systemd.automount"
    ];
  };

  swapDevices = [{
    device = "/dev/disk/by-label/swap";
  }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f0u5.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
