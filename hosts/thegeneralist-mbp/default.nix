lib: inputs: self: lib.nixosSystem {
  specialArgs = inputs // { inherit inputs; inherit self; };
  modules = [
    ./configuration.nix

    # Modules
    ({ pkgs, ... }: let
      inherit (lib) filter hasSuffix;
      commonModules = lib.filesystem.listFilesRecursive ../../modules/common |> filter (hasSuffix ".nix");
      darwinModules = lib.filesystem.listFilesRecursive ../../modules/darwin |> filter (hasSuffix ".nix");
    in {
      imports = commonModules ++ darwinModules;
    })

    # Overlays
    ({ pkgs, lib, ... }: let
      inherit (lib) attrValues hasAttrByPath getAttrFromPath filter;
      packagePath = [ "overlays" "default" ];
      overlays = (attrValues inputs)
        |> filter (hasAttrByPath packagePath)
        |> map (getAttrFromPath packagePath);
    in {
      nixpkgs.overlays = overlays;
    })
  ];
}
