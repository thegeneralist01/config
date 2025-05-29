# { lib, ... }: let
#   sshOptions = {
#     PermitRootLogin = "no";
#     PasswordAuthentication = "no";
#   };
# in {
#   services.openssh = {
#     enable = true;
#     extraConfig = sshOptions
#       |> lib.mapAttrsToList (name: value: "${name} ${value}")
#       |> lib.concatStringsSep "\n";
#   };
# }
{}
