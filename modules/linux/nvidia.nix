{
  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics.enable = true;
}
