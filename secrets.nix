let
  inherit (import ./keys.nix) thegeneralist;
in {
  "hosts/thegeneralist/hostkey.age".publicKeys = [ thegeneralist ];
  "hosts/thegeneralist-central/hostkey.age".publicKeys = [ thegeneralist ];

  "modules/linux/tailscale-marshall.age".publicKeys = [ thegeneralist ];
}
