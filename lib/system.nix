inputs: self: super:
let
  inherit (self)
    hasSuffix
    filesystem
    attrValues
    filter
    getAttrFromPath
    hasAttrByPath
    ;

  collectModules = path: filesystem.listFilesRecursive path |> filter (hasSuffix ".nix");

  collectInputModules =
    packagePath:
    (attrValues inputs) |> filter (hasAttrByPath packagePath) |> map (getAttrFromPath packagePath);

  specialArgs = inputs // {
    inherit inputs;
    inherit self;
  };

  # All modules
  modulesCommon = collectModules ../modules/common;
  modulesLinux = collectModules ../modules/linux;
  modulesDarwin = collectModules ../modules/darwin;

  inputModulesNixos = collectInputModules [
    "nixosModules"
    "default"
  ];
  inputModulesDarwin = collectInputModules [
    "darwinModules"
    "default"
  ];

  # Overlays
  overlays = collectInputModules [
    "overlays"
    "default"
  ];

  overlayModules = {
    nixpkgs.overlays = overlays;
  };
in
{
  system =
    os: configFile:
    (if os == "darwin" then
      super.darwinSystem
    else
      super.nixosSystem) {
        inherit specialArgs;

        modules =
          [
            overlayModules
            configFile
          ]
          ++ modulesCommon
          ++ (
            if os == "darwin" then modulesDarwin ++ inputModulesDarwin else modulesLinux ++ inputModulesNixos
          );
      };
}
