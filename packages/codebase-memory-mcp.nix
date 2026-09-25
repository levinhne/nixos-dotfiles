{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  stdenv,
}:

let
  version = "0.11.0";

  srcs = {
    x86_64-linux = {
      arch = "linux-amd64";
      sha256 = "032b33c1833919a2d1de67ff6367fa6ea46aee8689c86ef223c88fae3b6e4536";
    };
    aarch64-linux = {
      arch = "linux-arm64";
      sha256 = "c0e46c87cf37e35f1ac0bd9cc7e1d8b0ca4ef40034e1008805d709fa52a4e38a";
    };
    aarch64-darwin = {
      arch = "darwin-arm64";
      sha256 = "4dee7f38b63740e6751d7a7ed7eb10291c1f2a3ea2415f599dc68370ca0a2d18";
    };
    x86_64-darwin = {
      arch = "darwin-amd64";
      sha256 = "dbf1c73bfcbde64e7dde4cd1320da7afc02e2c972ee1789ae039521411f5132e";
    };
  };

  release =
    srcs.${stdenvNoCC.hostPlatform.system}
      or (throw "codebase-memory-mcp: unsupported system ${stdenvNoCC.hostPlatform.system}");
in
stdenvNoCC.mkDerivation {
  pname = "codebase-memory-mcp";
  inherit version;

  src = fetchurl {
    url = "https://github.com/DeusData/codebase-memory-mcp/releases/download/v${version}/codebase-memory-mcp-${release.arch}.tar.gz";
    inherit (release) sha256;
  };

  sourceRoot = ".";

  # Upstream ships an ad-hoc signed macOS binary; stripping invalidates the signature.
  dontStrip = stdenvNoCC.hostPlatform.isDarwin;

  # Linux release is a dynamically linked ELF (libc/libstdc++/libgcc_s/libm) built
  # against a glibc that doesn't match the Nix store layout — patch it to work.
  nativeBuildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
    autoPatchelfHook
  ];
  buildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 codebase-memory-mcp $out/bin/codebase-memory-mcp
    runHook postInstall
  '';

  meta = {
    description = "Code intelligence MCP server indexing codebases into a knowledge graph";
    homepage = "https://github.com/DeusData/codebase-memory-mcp";
    license = lib.licenses.mit;
    mainProgram = "codebase-memory-mcp";
    platforms = builtins.attrNames srcs;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
