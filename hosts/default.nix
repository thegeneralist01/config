{ lib, inputs, self }:
let
  inherit (lib) 
    mapAttrs filterAttrs hasPrefix hasSuffix;
  
  # Read host directories
  hostDirs = builtins.readDir ./.;
  
  # Build a single host configuration
  mkHostConfig = name: _type: 
    let
      hostPath = ./${name};
      hostModule = import hostPath;
    in
    hostModule lib inputs self;
  
  # Determine if host is Darwin or NixOS based on naming
  isDarwin = name: 
    hasPrefix "thegeneralist" name && 
    (hasSuffix "mbp" name || hasSuffix "central-mbp" name);
  
  # Build all host configurations
  allHosts = mapAttrs mkHostConfig 
    (filterAttrs (_: type: type == "directory") hostDirs);
  
  # Separate Darwin and NixOS configurations
  darwinHosts = filterAttrs (name: _: isDarwin name) allHosts;
  nixosHosts = filterAttrs (name: _: !isDarwin name) allHosts;
in
{
  darwin = darwinHosts;
  nixos = nixosHosts;
}
