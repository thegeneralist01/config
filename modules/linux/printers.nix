{ pkgs, ... }: {
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Epson proprietary backend
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [
    pkgs.epkowa
  ];
}
