let
  inherit (import ./keys.nix) thegeneralist;
in {
  "hosts/thegeneralist/hostkey.age".publicKeys = [ thegeneralist ];
  "hosts/thegeneralist-central/hostkey.age".publicKeys = [ thegeneralist ];

  "hosts/thegeneralist-central/acme/acmeEnvironment.age".publicKeys = [ thegeneralist ];
  "hosts/thegeneralist-central/cert.pem.age".publicKeys = [ thegeneralist ];
  "hosts/thegeneralist-central/credentials.age".publicKeys = [ thegeneralist ];
  "hosts/thegeneralist-central/cache/key.age".publicKeys = [ thegeneralist ];

  "modules/linux/tailscale-marshall.age".publicKeys = [ thegeneralist ];
}
