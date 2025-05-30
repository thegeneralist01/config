lib: inputs: self: lib.darwinSystem {
  specialArgs = inputs // { inherit inputs; inherit self; };
  modules = [
    # Extensions: nixosModules, darwinModules, overlays
    ({ pkgs, lib, inputs, ... }: let
      inherit (lib) attrValues hasAttrByPath getAttrFromPath filter;

      collect = packagePath: (attrValues inputs)
        |> filter (hasAttrByPath packagePath)
        |> map (getAttrFromPath packagePath);

      modules = collect [ "darwinModules" "default" ];
      # todo
      extensions = {
        nixpkgs.overlays = collect [ "overlays" "default" ];
        imports = modules;
      };
    in extensions)

    ./configuration.nix

    # Modules
    ({ pkgs, ... }: let
      inherit (lib) filter hasSuffix;
      commonModules = lib.filesystem.listFilesRecursive ../../modules/common |> filter (hasSuffix ".nix");
      darwinModules = lib.filesystem.listFilesRecursive ../../modules/darwin |> filter (hasSuffix ".nix");
    in {
      imports = commonModules ++ darwinModules;
    })
  ];
}
