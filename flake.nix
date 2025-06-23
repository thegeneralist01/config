  {
  description = "thegeneralist's config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.darwin.follows = "nix-darwin";
    };
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
    # wrapper-manager = {
    #   url = "github:viperML/wrapper-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    #nix.url = "github:DeterminateSystems/nix-src";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, nix, ... }: let
    inherit (builtins) readDir;
    inherit (nixpkgs.lib) attrsToList const groupBy listToAttrs mapAttrs last mkOption splitString;
    #nix.enable = false;

    lib = nixpkgs.lib // nix-darwin.lib;

    targetHost = readDir ./hosts
      |> mapAttrs (name: const <| import ./hosts/${name} lib inputs self)
      |> attrsToList
      |> groupBy (host:
        if host.name == "thegeneralist" || host.name == "thegeneralist-central" then
          "nixosConfigurations"
        else
          "darwinConfigurations")
      |> mapAttrs (const listToAttrs);
  in targetHost;
}
