{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    agenix
  ];

  age.identityPaths = [
    "~/.ssh/id_ed25519"
  ];
}
