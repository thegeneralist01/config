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

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";

      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";

      flake = false;
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

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      ...
    }:
    let
      # Extend nixpkgs lib with darwin and custom functions
      lib = nixpkgs.lib.extend (_: _: nix-darwin.lib // (import ./lib inputs));

      # Import host configurations
      hostConfigs = import ./hosts { inherit lib inputs self; };
    in
    {
      # NixOS configurations for Linux hosts
      nixosConfigurations = hostConfigs.nixos or { };

      # Darwin configurations for macOS hosts
      darwinConfigurations = hostConfigs.darwin or { };

      # Development shells
      devShells = lib.genAttrs [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ] (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              nil
              nixpkgs-fmt
              inputs.agenix.packages.${system}.default
            ];
          };
        }
      );
    };
}
