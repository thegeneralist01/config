inputs: 
let
  inherit (inputs.nixpkgs.lib) makeExtensible;
in
makeExtensible (self: 
  let
    callLib = file: import file inputs self;
    optionUtils = callLib ./option.nix;
  in
  {
    # Core system building functions
    mkSystem = (callLib ./system.nix).mkSystem;

    # Custom option utilities
    mkConst = optionUtils.mkConst;
    mkValue = optionUtils.mkValue;

    # Host detection and configuration
    mkHosts = callLib ./hosts.nix;
  }
)
