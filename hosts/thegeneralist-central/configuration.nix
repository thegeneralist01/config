# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./site.nix
    ./cache
    ./archive
    ./forgejo
  ];

  age.secrets.password.file = ./password.age;
  age.secrets.readlaterBotToken.file = ./readlater-bot-token.age;
  age.secrets.readlaterBotSyncToken.file = ./readlater-bot-sync-token.age;
  age.secrets.readlaterBotUserId.file = ./readlater-bot-user-id.age;
  age.secrets.openclawTelegramToken.file = ./openclaw-telegram-token.age;
  age.secrets.openclawGatewayEnv.file = ./openclaw-gateway.env.age;
  age.secrets.readlaterBotToken.owner = "thegeneralist";
  age.secrets.readlaterBotToken.group = "users";
  age.secrets.readlaterBotToken.mode = "0400";
  age.secrets.readlaterBotSyncToken.owner = "thegeneralist";
  age.secrets.readlaterBotSyncToken.group = "users";
  age.secrets.readlaterBotSyncToken.mode = "0400";
  age.secrets.readlaterBotUserId.owner = "thegeneralist";
  age.secrets.readlaterBotUserId.group = "users";
  age.secrets.readlaterBotUserId.mode = "0400";
  age.secrets.openclawTelegramToken.owner = "thegeneralist";
  age.secrets.openclawTelegramToken.group = "users";
  age.secrets.openclawTelegramToken.mode = "0400";
  age.secrets.openclawGatewayEnv.owner = "thegeneralist";
  age.secrets.openclawGatewayEnv.group = "users";
  age.secrets.openclawGatewayEnv.mode = "0400";
  users.users = {
    thegeneralist = {
      isNormalUser = true;
      description = "thegeneralist";
      extraGroups = [
        "wheel"
        "audio"
        "video"
        "input"
        "scanner"
        "docker"
      ];
      shell = pkgs.nushell;
      home = "/home/thegeneralist";
      homeMode = "0750";
      linger = true;
      hashedPasswordFile = config.age.secrets.password.path;
      openssh.authorizedKeys.keys =
        let
          inherit (import ../../keys.nix) thegeneralist;
        in
        [ thegeneralist ];
    };

    build = {
      isNormalUser = true;
      description = "for distributed builds";
      extraGroups = [ "build" ];
      shell = pkgs.zsh;
      hashedPasswordFile = config.age.secrets.password.path;
      openssh.authorizedKeys.keys =
        let
          inherit (import ../../keys.nix) thegeneralist;
        in
        [ thegeneralist ];
    };
  };

  home-manager = {
    backupFileExtension = "home.bak";
    extraSpecialArgs = { inherit inputs; };
    sharedModules = [ inputs.nix-openclaw.homeManagerModules.openclaw ];
    users.thegeneralist =
      { osConfig, ... }:
      {
        home = {
          username = "thegeneralist";
          homeDirectory = "/home/thegeneralist";
          stateVersion = "25.11";
        };

        programs.openclaw = {
          documents = ./openclaw-documents;
          config = {
            gateway = {
              mode = "local";
              auth.mode = "token";
            };

            channels.telegram = {
              tokenFile = osConfig.age.secrets.openclawTelegramToken.path;
              # Replace with your Telegram user ID from @userinfobot.
              allowFrom = [ 0 ];
              groups."*" = {
                requireMention = true;
              };
            };
          };

          instances.default.enable = true;
        };

        systemd.user.services.openclaw-gateway.Service.EnvironmentFile = [
          osConfig.age.secrets.openclawGatewayEnv.path
        ];

        home.activation.openclawTelegramAllowFrom =
          lib.hm.dag.entryAfter [ "openclawConfigFiles" ] ''
            set -euo pipefail

            user_id="$(${lib.getExe' pkgs.coreutils "cat"} ${osConfig.age.secrets.readlaterBotUserId.path})"
            tmp="$(${lib.getExe' pkgs.coreutils "mktemp"})"

            ${lib.getExe pkgs.jq} --argjson user_id "$user_id" \
              '.channels.telegram.allowFrom = [$user_id]' \
              /home/thegeneralist/.openclaw/openclaw.json > "$tmp"

            rm -f /home/thegeneralist/.openclaw/openclaw.json
            mv "$tmp" /home/thegeneralist/.openclaw/openclaw.json
          '';
      };
  };

  age.secrets.hostkey.file = ./hostkey.age;
  services.openssh.hostKeys = [
    {
      type = "ed25519";
      path = config.age.secrets.hostkey.path;
    }
  ];

  # Some programs
  services.libinput.enable = true;
  programs.firefox.enable = true;
  programs.zsh.enable = true;

  services.readlater-bot = {
    enable = true;
    user = "thegeneralist";
    group = "users";
    tokenFile = config.age.secrets.readlaterBotToken.path;
    settings = {
      media_dir = "/home/thegeneralist/obsidian/09 Misc/Assets/images_misc";
      resources_path = "/home/thegeneralist/obsidian/02 Knowledge/03 Resources";
      read_later_path = "/home/thegeneralist/obsidian/10 Read Later.md";
      finished_path = "/home/thegeneralist/obsidian/20 Finished Reading.md";
      data_dir = "/var/lib/readlater-bot";
      retry_interval_seconds = 30;
      sync = {
        repo_path = "/home/thegeneralist/obsidian";
        token_file = config.age.secrets.readlaterBotSyncToken.path;
      };
      sync_x = {
        source_project_path = "/home/thegeneralist/bookkeeper/vendor/extract-x-bookmarks";
        python_bin = "/home/thegeneralist/bookkeeper/vendor/extract-x-bookmarks/.venv/bin/python3";
        work_dir = "/home/thegeneralist/bookkeeper/.sync-x-work";
      };
    };
  };

  systemd.services.readlater-bot.preStart = lib.mkAfter ''
    if [ -f /run/readlater-bot/config.toml ]; then
      tmp="/run/readlater-bot/config.toml.tmp"
      {
        IFS= read -r first_line || true
        printf '%s\n' "$first_line"
        printf 'user_id = %s\n' "$(cat ${config.age.secrets.readlaterBotUserId.path})"
        cat
      } < /run/readlater-bot/config.toml > "$tmp"
      mv "$tmp" /run/readlater-bot/config.toml
    fi
  '';

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  system.stateVersion = "24.11";
}
