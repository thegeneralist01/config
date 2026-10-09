{ config, lib, pkgs, ... }:

let
  forgejoStateDir = "/mnt/usb/services/forgejo/stateDir";
  domain = "git.thegeneralist01.com";
in
{
  imports = [ ../../../modules/postgresql.nix ];

  age.secrets.forgejoRunnerToken.file = ./forgejo-runner-token.age;

  services.forgejo = {
    enable = true;
    stateDir = forgejoStateDir;

    lfs.enable = true;

    settings =
      let
        title = "thegeneralist01's forgejo";
        desc = "the attic of thegeneralist01's random repositories";
      in
      {
        default.APP_NAME = title;
        "ui.meta" = {
          AUTHOR = title;
          DESCRIPTION = desc;
        };

        attachment.ALLOWED_TYPES = "*/*";
        actions = {
          ENABLED = true;
        };
        cache.ENABLED = true;

        "cron.archive_cleanup" =
          let
            interval = "4h";
          in
          {
            SCHEDULE = "@every ${interval}";
            OLDER_THAN = interval;
          };

        packages.ENABLED = true;
        mailer = {
          ENABLED = false;

          # PROTOCOL = "smtps";
          # SMTP_ADDR = self.disk.mailserver.fqdn;
          # USER = "git@${domain}";
        };

        other = {
          SHOW_FOOTER_TEMPLATE_LOAD_TIME = false;
          SHOW_FOOTER_VERSION = false;
        };

        repository = {
          DEFAULT_BRANCH = "master";
          DEFAULT_MERGE_STYLE = "rebase-merge";
          DEFAULT_REPO_UNITS = "repo.code, repo.issues, repo.pulls";

          DEFAULT_PUSH_CREATE_PRIVATE = false;
          ENABLE_PUSH_CREATE_ORG = true;
          ENABLE_PUSH_CREATE_USER = true;

          DISABLE_STARS = true;
        };

        "repository.upload" = {
          FILE_MAX_SIZE = 100;
          MAX_FILES = 10;
        };

        server = {
          ROOT_URL = "https://${domain}/";
          DOMAIN = domain;
          LANDING_PAGE = "/explore";

          HTTP_ADDR = "127.0.0.1";
          HTTP_PORT = 3000;

          SSH_LISTEN_HOST = "0.0.0.0";
          SSH_PORT = 2222;
          SSH_LISTEN_PORT = 2222;
        };

        service.DISABLE_REGISTRATION = true;

        session = {
          COOKIE_SECURE = true;
          SAME_SITE = "strict";
        };
      };
  };

  systemd.services.forgejo = {
    requires = [ "forgejo-data-ownership.service" ];
    after = [ "forgejo-data-ownership.service" ];
  };

  systemd.services.forgejo-data-ownership = {
    description = "Prepare persisted Forgejo state";
    unitConfig.RequiresMountsFor = [ forgejoStateDir ];
    before = [ "forgejo.service" ];
    serviceConfig.Type = "oneshot";
    script = ''
      marker=${forgejoStateDir}/.nixos-ownership-v1
      if [ ! -e "$marker" ]; then
        ${pkgs.coreutils}/bin/chown -R forgejo:forgejo ${forgejoStateDir}
        ${pkgs.coreutils}/bin/touch "$marker"
        ${pkgs.coreutils}/bin/chown forgejo:forgejo "$marker"
      fi
    '';
  };

  services.gitea-actions-runner = {
    package = pkgs.forgejo-runner;
    instances.thegeneralist = {
      enable = true;
      name = "thegeneralist";
      url = "https://${domain}";
      tokenFile = config.age.secrets.forgejoRunnerToken.path;
      labels = [
        "native:host"
        # "node-22:docker://node:22-bookworm"
        # "nixos-latest:docker://nixos/nix"
      ];

      # Host-executed jobs need nix + ssh in PATH.
      hostPackages = with pkgs; [
        bash
        coreutils
        curl
        gawk
        gitMinimal
        gnused
        nodejs
        nix
        openssh
        wget
      ];
    };
  };

  networking.firewall.trustedInterfaces = [ "br-+" ];


  # Avoid /var/lib/private so the runner can write its state.
  systemd.services.gitea-runner-thegeneralist.serviceConfig = {
    DynamicUser = lib.mkForce false;
    StateDirectory = lib.mkForce "gitea-runner";
    StateDirectoryMode = "0755";
    # Ensure newly created files are group-writable for the shared repo.
    UMask = "0002";
  };

  users.groups.gitea-runner = { };
  users.users.gitea-runner = {
    isSystemUser = true;
    group = "gitea-runner";
    extraGroups = [ "users" ];
    home = "/var/lib/gitea-runner/thegeneralist";
    createHome = true;
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/gitea-runner 0755 gitea-runner gitea-runner -"
    "d /var/lib/gitea-runner/thegeneralist 0755 gitea-runner gitea-runner -"
  ];

  networking.firewall.allowedTCPPorts = [ 2222 ];
}
