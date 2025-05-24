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
  };

  outputs = inputs@{ self, nixpkgs, ... }: let
    inherit (builtins) readDir;
    inherit (nixpkgs.lib) attrsToList const groupBy listToAttrs mapAttrs;

    targetHost = readDir ./hosts
      |> mapAttrs (name: const <| import ./hosts/${name} nixpkgs.lib inputs self)
      |> attrsToList
      |> groupBy (host:
        if host.name == "thegeneralist" then
          "nixosConfigurations"
        else
          "darwinConfigurations")
      |> mapAttrs (const listToAttrs);
  in targetHost;
}
