{
  pkgs,
  lib,
  config,
  ...
}:
{
  # TODO: check these out: https://github.com/RGBCube/ncc/blob/86212e148b2642a51814e873a81be73fbc494e86/modules/common/rust.nix#L15-L24
  environment = {
    variables = {
      LIBRARY_PATH = lib.mkIf (!config.onLinux) <| lib.makeLibraryPath [ pkgs.libiconv ];
    };

    systemPackages = with pkgs; [
      (fenix.complete.withComponents [
        "cargo"
        "clippy"
        "rust-src"
        "rustc"
        "rustfmt"
      ])
      rust-analyzer-nightly

      # for nil
      nixd
      nixfmt-rfc-style

      libiconv

      clang
      clang-analyzer
    ];
  };
}
