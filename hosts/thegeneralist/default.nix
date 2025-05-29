lib: inputs: self: lib.nixosSystem {
  specialArgs = inputs // { inherit inputs; inherit self; };
  modules = [
    # Extensions: nixosModules, darwinModules, overlays
    ({ pkgs, lib, ... }: let
      inherit (lib) attrValues hasAttrByPath getAttrFromPath filter;

      collect = packagePath: (attrValues inputs)
        |> filter (hasAttrByPath packagePath)
        |> map (getAttrFromPath packagePath);

      modules = collect [ "nixosModules" "default" ];
      extensions = modules // {
        nixpkgs.overlays = collect [ "overlays" "default" ];
        imports = modules;
      };
    in extensions)

    ./configuration.nix

    # Modules
    ({ pkgs, ... }: let
      inherit (lib) filter hasSuffix;
      commonModules = lib.filesystem.listFilesRecursive ../../modules/common |> filter (hasSuffix ".nix");
      linuxModules = lib.filesystem.listFilesRecursive ../../modules/linux |> filter (hasSuffix ".nix");
    in {
      imports = commonModules ++ linuxModules;
    })
  ];
}
