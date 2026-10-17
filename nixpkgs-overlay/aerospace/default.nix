{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  apple-sdk_26,
  aerospace,
  asciidoctor,
  complgen,
  installShellFiles,
  darwin,
  rcodesign,
  libcxx,
  cups,
  src,
}:
let
  swift = callPackage ./swift-toolchain.nix { };
  pins = (builtins.fromJSON (builtins.readFile "${src}/Package.resolved")).pins;
  hashes = import ./dependency-hashes.nix;
  dependencies = map (pin: {
    inherit (pin) identity;
    source = fetchFromGitHub {
      owner = builtins.elemAt (lib.splitString "/" pin.location) 3;
      repo = lib.removeSuffix ".git" (lib.last (lib.splitString "/" pin.location));
      rev = pin.state.revision;
      hash = hashes.${pin.identity};
      name = pin.identity;
    };
  }) pins;
  version = "0-unstable-${builtins.substring 0 8 src.lastModifiedDate}-${builtins.substring 0 7 src.rev}";
in
stdenv.mkDerivation {
  pname = "aerospace";
  inherit version src;

  nativeBuildInputs = [ swift asciidoctor complgen installShellFiles rcodesign ];
  # nixpkgs removes these system-library stubs from its Apple SDK.
  buildInputs = [ apple-sdk_26 libcxx (lib.getLib cups) ];
  strictDeps = true;
  dontConfigure = true;

  postPatch = ''
    # Use the exact Package.resolved revisions, without SwiftPM network access.
    mkdir -p .deps
    ${lib.concatMapStringsSep "\n" (dep: ''
      cp -R ${dep.source} .deps/${dep.identity}
      chmod -R u+w .deps/${dep.identity}
    '') dependencies}
    substituteInPlace Package.swift \
      --replace-fail '.package(url: "https://github.com/InerziaSoft/ISSoundAdditions.git", exact: "2.0.1")' '.package(path: ".deps/issoundadditions")' \
      --replace-fail '.package(url: "https://github.com/dduan/TOMLDecoder", exact: "0.4.4")' '.package(path: ".deps/tomldecoder")' \
      --replace-fail '.package(url: "https://github.com/apple/swift-collections.git", exact: "1.3.0")' '.package(path: ".deps/swift-collections")' \
      --replace-fail '.package(url: "https://github.com/soffes/HotKey.git", exact: "0.2.1")' '.package(path: ".deps/hotkey")'

    # Upstream's generators use BSD sed and bootstrap tools from the network.
    # Keep the generators, but use Nix's tools and skip their bootstrap setup.
    substituteInPlace generate.sh --replace-fail ${lib.escapeShellArg "sed -i ''"} "sed -i"
    substituteInPlace generate.sh script/generate-cmd-help.sh \
      --replace-fail 'source ./script/setup.sh' 'set -euo pipefail'
    patchShebangs generate.sh script/generate-cmd-help.sh
    bash ./generate.sh --ignore-xcodeproj --build-version ${lib.escapeShellArg version}
    cat > Sources/Common/gitHashGenerated.swift <<'EOF'
    public let gitHash = "${src.rev}"
    public let gitShortHash = "${builtins.substring 0 7 src.rev}"
    EOF
  '';

  buildPhase = ''
    runHook preBuild
    export HOME="$TMPDIR/home"
    mkdir -p "$HOME"
    export CFFIXED_USER_HOME="$HOME"
    export MACOSX_DEPLOYMENT_TARGET=13.0
    export SDKROOT=${apple-sdk_26.sdkroot}
    export SWIFT_EXEC=${swift}/usr/bin/swiftc
    export LIBTOOL=${darwin.cctools}/bin/libtool
    export CLANG_MODULE_CACHE_PATH="$TMPDIR/clang-module-cache"
    export SWIFTPM_MODULECACHE_OVERRIDE="$TMPDIR/swift-module-cache"
    # SwiftPM otherwise probes /usr/bin/xcrun for the manifest library's minos.
    # The pinned libPackageDescription.dylib targets macOS 14; the app targets 13.
    swiftFlags=(
      --configuration release --disable-sandbox
      --sdk "$SDKROOT" --jobs "$NIX_BUILD_CORES"
      -Xbuild-tools-swiftc -target -Xbuild-tools-swiftc arm64-apple-macosx14.0
      -Xlinker -L${lib.getLib libcxx}/lib
      -Xlinker -L${lib.getLib cups}/lib
    )
    swift build "''${swiftFlags[@]}" --product aerospace
    swift build "''${swiftFlags[@]}" --product AeroSpaceApp
    binPath="$(swift build "''${swiftFlags[@]}" --show-bin-path)"

    asciidoctor -b manpage -D .man docs/aerospace*.adoc
    mkdir -p .shell-completion
    complgen --zsh .shell-completion/_aerospace grammar/commands-bnf-grammar.txt
    complgen --fish .shell-completion/aerospace.fish grammar/commands-bnf-grammar.txt
    complgen --bash .shell-completion/aerospace.bash grammar/commands-bnf-grammar.txt
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    app="$out/Applications/AeroSpace.app"
    mkdir -p "$app/Contents/MacOS" "$app/Contents/Resources" "$out/bin"
    install -m755 "$binPath/AeroSpaceApp" "$app/Contents/MacOS/AeroSpace"
    install -m755 "$binPath/aerospace" "$out/bin/aerospace"

    # Only the precompiled artwork comes from nixpkgs' pinned official release.
    # Both executables and the default config are built from the fork above.
    cp ${aerospace}/Applications/AeroSpace.app/Contents/Resources/{AppIcon.icns,Assets.car} "$app/Contents/Resources/"
    cp docs/config-examples/default-config.toml "$app/Contents/Resources/"
    cat > "$app/Contents/Info.plist" <<'EOF'
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0"><dict>
      <key>CFBundleDevelopmentRegion</key><string>en</string>
      <key>CFBundleExecutable</key><string>AeroSpace</string>
      <key>CFBundleIdentifier</key><string>bobko.aerospace</string>
      <key>CFBundleName</key><string>AeroSpace</string>
      <key>CFBundlePackageType</key><string>APPL</string>
      <key>CFBundleInfoDictionaryVersion</key><string>6.0</string>
      <key>CFBundleShortVersionString</key><string>${version}</string>
      <key>CFBundleIconFile</key><string>AppIcon</string>
      <key>CFBundleIconName</key><string>AppIcon</string>
      <key>LSMinimumSystemVersion</key><string>13.0</string>
      <key>LSUIElement</key><true/>
    </dict></plist>
    EOF
    printf APPL'????' > "$app/Contents/PkgInfo"
    installManPage .man/*.1
    installShellCompletion --cmd aerospace \
      --bash .shell-completion/aerospace.bash \
      --fish .shell-completion/aerospace.fish \
      --zsh .shell-completion/_aerospace
    mkdir -p "$out/share/doc/aerospace"
    cp LICENSE.txt "$out/share/doc/aerospace/"
    cp -R legal "$out/share/doc/aerospace/"
    runHook postInstall
  '';

  # Sign after fixups; no developer certificate or host keychain is needed.
  postFixup = ''
    # SwiftBuild embeds build-only compatibility paths. Runtime libraries use
    # macOS or Nix install names; don't retain the compiler and SDK at runtime.
    for binary in "$out/bin/aerospace" "$out/Applications/AeroSpace.app/Contents/MacOS/AeroSpace"; do
      ${darwin.cctools}/bin/install_name_tool \
        -delete_rpath ${swift}/usr/lib/swift-6.2/macosx \
        -delete_rpath ${apple-sdk_26}/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift-6.2/macosx \
        "$binary"
    done
    rcodesign sign --config-file /dev/null --timestamp-url none \
      --binary-identifier aerospace "$out/bin/aerospace"
    rcodesign sign --config-file /dev/null --timestamp-url none \
      --entitlements-xml-file ${src}/resources/AeroSpace.entitlements \
      "$out/Applications/AeroSpace.app"
  '';

  disallowedReferences = [ swift apple-sdk_26 ];

  meta = aerospace.meta // {
    homepage = "https://github.com/N1ark/AeroSpace";
    description = "AeroSpace with left/right modifier bindings";
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ fromSource binaryNativeCode ];
  };
}
