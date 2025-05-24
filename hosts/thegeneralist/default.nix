lib: inputs: self: lib.nixosSystem {
  specialArgs = inputs // { inherit inputs; inherit self; };
  modules = [
    ./configuration.nix
    ({ pkgs, ... }: let
      inherit (lib) filter hasSuffix;
      modules = lib.filesystem.listFilesRecursive ../../modules/linux |> filter (hasSuffix ".nix");
    in {
      imports = modules;
    })
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
