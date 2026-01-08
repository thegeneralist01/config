inputs: self:
let
  inherit (inputs.nixpkgs.lib) 
    hasSuffix filesystem attrValues filter getAttrFromPath 
    hasAttrByPath mapAttrsToList concatMap;
    
  # Helper to collect all .nix files recursively in a directory
  collectModules = path: 
    if builtins.pathExists path
    then filter (hasSuffix ".nix") (filesystem.listFilesRecursive path)
    else [];

  # Collect modules from flake inputs with fallback handling
  collectInputModules = packagePath:
    let
      getModule = input:
        if hasAttrByPath packagePath input
        then [ (getAttrFromPath packagePath input) ]
        else [];
    in
    concatMap getModule (attrValues inputs);

  # Shared arguments for all configurations  
  specialArgs = inputs // {
    inherit inputs self;
  };

  # Collect platform-specific modules
  modulesCommon = collectModules ../modules/common;
  modulesLinux = collectModules ../modules/linux; 
  modulesDarwin = collectModules ../modules/darwin;

  # Collect input modules by platform
  inputModulesNixos = collectInputModules [ "nixosModules" "default" ];
  inputModulesDarwin = collectInputModules [ "darwinModules" "default" ];

  # Collect overlays from inputs
  overlays = collectInputModules [ "overlays" "default" ];
  
  overlayModule = {
    nixpkgs.overlays = overlays;
  };
in
{
  # Main system builder function
  mkSystem = os: configFile:
    let
      systemBuilder = if os == "darwin" 
                     then inputs.nix-darwin.lib.darwinSystem
                     else inputs.nixpkgs.lib.nixosSystem;
                     
      platformModules = if os == "darwin"
                       then modulesDarwin ++ inputModulesDarwin
                       else modulesLinux ++ inputModulesNixos;
    in
    systemBuilder {
      inherit specialArgs;
      
      modules = [
        overlayModule
        configFile
      ] ++ modulesCommon ++ platformModules;
    };
}
