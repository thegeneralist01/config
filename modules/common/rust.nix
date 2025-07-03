{ pkgs, ... }: {
  # TODO: install nil (nix language server)
  # TODO: check these out: https://github.com/RGBCube/ncc/blob/86212e148b2642a51814e873a81be73fbc494e86/modules/common/rust.nix#L15-L24
  environment.systemPackages = with pkgs; [
    (fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    rust-analyzer-nightly

    # for nil
    nil
    nixfmt-rfc-style
  ];

  # home-manager.sharedModules = [{
  #   extraWrapperArgs = [
  #     "--suffix"
  #     "LIBRARY_PATH"
  #     ":"
  #     "${lib.makeLibraryPath [ pkgs.stdenv.cc.cc pkgs.zlib ]}"
  #     "--suffix"
  #     "PKG_CONFIG_PATH"
  #     ":"
  #     "${lib.makeSearchPathOutput "dev" "lib/pkgconfig" [ pkgs.stdenv.cc.cc pkgs.zlib ]}"
  #   ];
  # }];
}
