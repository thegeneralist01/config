{ config, lib, modulesPath, pkgs, ... }:

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
    options nvidia NVreg_DynamicPowerManagement=0x02
  '';
  boot.kernelParams = [ "usbcore.autosuspend=-1" ];
  networking.networkmanager.wifi.powersave = false;

  # Allow this headless Turing GPU to enter runtime D3 while unused.
  services.udev.extraRules = ''
    ACTION=="bind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", TEST=="power/control", ATTR{power/control}="auto"
    ACTION=="unbind", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", TEST=="power/control", ATTR{power/control}="on"
  '';

  # Favor efficient idle and light-load operation without suspending this
  # always-on host. The EPP setting retains short performance bursts.
  powerManagement = {
    cpuFreqGovernor = "powersave";
    scsiLinkPolicy = "med_power_with_dipm";
  };
  systemd.services.energy-policy = {
    description = "Apply host energy policy";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-modules-load.service" "local-fs.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      for policy in /sys/devices/system/cpu/cpufreq/policy*; do
        if [ -w "$policy/energy_performance_preference" ]; then
          echo balance_power > "$policy/energy_performance_preference"
        fi
      done

      # This unmounted archival HDD wakes transparently when accessed.
      disk=/dev/disk/by-id/ata-ST1000DM010-2EP102_ZN1043CH
      if [ -b "$disk" ]; then
        ${pkgs.hdparm}/bin/hdparm -S 120 "$disk"
      fi
    '';
  };
  boot.kernel.sysctl."kernel.nmi_watchdog" = 0;

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
      "noatime"
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
