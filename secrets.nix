let
  inherit (import ./keys.nix) thegeneralist;
in
{
  "hosts/thegeneralist/hostkey.age".publicKeys = [ thegeneralist ];
  "hosts/thegeneralist/acme/acmeEnvironment.age".publicKeys = [ thegeneralist ];
  "hosts/thegeneralist/cert.pem.age".publicKeys = [ thegeneralist ];
  "hosts/thegeneralist/credentials.age".publicKeys = [ thegeneralist ];
  "hosts/thegeneralist/cache/key.age".publicKeys = [ thegeneralist ];
  "hosts/thegeneralist/forgejo/forgejo-runner-token.age".publicKeys = [ thegeneralist ];
  "hosts/thegeneralist/readlater-bot-token.age".publicKeys = [ thegeneralist ];
  "hosts/thegeneralist/readlater-bot-sync-token.age".publicKeys = [ thegeneralist ];
  "hosts/thegeneralist/readlater-bot-user-id.age".publicKeys = [ thegeneralist ];

  "modules/linux/tailscale-marshall.age".publicKeys = [ thegeneralist ];
}
