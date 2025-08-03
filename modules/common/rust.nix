{ pkgs, ... }: {
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

    nixd
    nixfmt-rfc-style
  ];
}
