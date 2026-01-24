let
  forgejo_root_dir = "/var/lib/forgejo";
  domain = "git.thegeneralist01.com";

  forgejo_folder = folder_name: "${forgejo_root_dir}/${folder_name}";
in
{
  imports = [ ../../../modules/postgresql.nix ];

  age.secrets.forgejoRunnerToken.file = ./forgejo-runner-token.age;

  services.forgejo = {
    enable = true;
    stateDir = forgejo_folder "state";

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

  services.gitea-actions-runner = {
    package = pkgs.forgejo-runner;
    instances.central = {
      enable = true;
      name = "thegeneralist-central";
      url = "https://${domain}";
      tokenFile = config.age.secrets.forgejoRunnerToken.path;
      labels = [ "central:host" ];

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

  networking.firewall.allowedTCPPorts = [ 2222 ];
}
