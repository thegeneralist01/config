{
  lib,
  stdenvNoCC,
  fetchurl,
  xar,
  cpio,
  bintools,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "aerospace-swift-toolchain";
  # Matches .swift-version in the pinned AeroSpace source.
  version = "6.4.0";

  src = fetchurl {
    url = "https://download.swift.org/swift-${finalAttrs.version}-release/xcode/swift-${finalAttrs.version}-RELEASE/swift-${finalAttrs.version}-RELEASE-osx.pkg";
    hash = "sha256-j9AxhbmP4n9UpUYxwkSd7PddW0Zs6ONKu9QUFBBjxqo=";
  };

  nativeBuildInputs = [ xar cpio ];
  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  # Preserve the toolchain's layout, relative dylib paths, and existing signatures.
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    xar -xf "$src" swift-${finalAttrs.version}-RELEASE-osx-package.pkg/Payload
    mkdir -p "$out"
    cd "$out"
    gzip -dc "$NIX_BUILD_TOP/swift-${finalAttrs.version}-RELEASE-osx-package.pkg/Payload" | cpio -idm --quiet
    # Use the pinned linker without Nix's C-driver default SDK flags.
    ln -s ${bintools.bintools}/bin/ld usr/bin/ld
    ln -s usr/bin bin
    runHook postInstall
  '';

  meta = {
    description = "Pinned Swift toolchain for building the AeroSpace fork";
    homepage = "https://www.swift.org/download/";
    license = lib.licenses.asl20;
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
