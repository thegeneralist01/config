# stolen from https://github.com/RGBCube/ncc/blob/94c349aa767f04f40ff4165c70c15ed3c3996f82/modules/postgresql.nix
{ config, lib, pkgs, ... }: let
  inherit (lib) flip mkForce mkOverride mkOption;
in {
  config.environment.systemPackages = [
    config.services.postgresql.package
  ];

  options.services.postgresql.ensure = mkOption {
    default = [];
  };

  config.services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;

    enableJIT   = true;
    enableTCPIP = true;

    settings.listen_addresses = mkForce "::";
    authentication            = mkOverride 10 /* ini */ ''
      #     DATABASE USER        AUTHENTICATION
      local all      all         peer

      #     DATABASE USER ADDRESS AUTHENTICATION
      host  all      all  ::/0    md5
    '';

    ensure = [ "postgres" "root" ];

    initdbArgs      = [ "--locale=C" "--encoding=UTF8" ];
    ensureDatabases = config.services.postgresql.ensure;

    ensureUsers = flip map config.services.postgresql.ensure (name: {
      inherit name;

      ensureDBOwnership = true;

      ensureClauses = {
        login       = true;
        superuser   = name == "postgres" || name == "root";
      };
    });
  };
}
