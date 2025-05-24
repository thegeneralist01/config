{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    agenix
  ];

  age.identityPaths = [
    "/home/thegeneralist/.ssh/id_ed25519"
  ];
}
