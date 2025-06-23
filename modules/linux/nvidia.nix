{ lib, config, ... }: lib.mkIf (!config.isServer) {
  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics.enable = true;
}
