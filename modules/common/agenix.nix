{ pkgs, config, ... }: {
  environment.systemPackages = with pkgs; [
    agenix
  ];

  age.identityPaths = if config.onLinux then [
    "/home/thegeneralist/.ssh/id_ed25519"
  ] else [
    "/Users/thegeneralist/.ssh/id_ed25519"
  ];
}
