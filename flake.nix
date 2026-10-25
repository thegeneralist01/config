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

    aerospace-src = {
      url = "github:N1ark/AeroSpace/d720311090f5922c10c5d9bfb62cbc7d8120e9fc";
      flake = false;
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
    steipete-tap = {
      url = "github:steipete/homebrew-tap";
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

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helium = {
      # url = "github:FKouhai/helium2nix/main";
      url = "github:AlvaroParker/helium-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    readlater-bot = {
      url = "github:thegeneralist01/bookkeeper";
    };

    # Private repo: git+ssh so fetching uses the evaluating user's SSH key (github: would need an access token).
    # No nixpkgs follows: the worker is built from crosspost's own pinned nixpkgs.
    crosspost.url = "git+ssh://git@github.com/thegeneralist01/crosspost?ref=main";

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.noctalia-qs.follows = "noctalia-qs";
    };

    noctalia-qs = {
      url = "github:noctalia-dev/noctalia-qs";
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

      packages.aarch64-darwin.aerospace =
        nixpkgs.legacyPackages.aarch64-darwin.callPackage ./nixpkgs-overlay/aerospace {
          src = inputs.aerospace-src;
        };

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
