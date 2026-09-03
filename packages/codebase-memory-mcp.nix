{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  stdenv,
}:

let
  version = "0.10.8";

  srcs = {
    x86_64-linux = {
      arch = "linux-amd64";
      sha256 = "e5cba4cad6ca8254a85f45041fc8a831908d7d5cb64f98fc3f8eb70a58671793";
    };
    aarch64-linux = {
      arch = "linux-arm64";
      sha256 = "e2804a20f5a6fc392af361525a232703e351b7d1aacb81b88eef806eec5959fa";
    };
    aarch64-darwin = {
      arch = "darwin-arm64";
      sha256 = "9bd840dfb3ec7eaef4f310382057adaa5b0e904df883104d03ffcf39836afd07";
    };
    x86_64-darwin = {
      arch = "darwin-amd64";
      sha256 = "2b193085410af3801634a522f4b17dcd6699695e015a068393c87817c1d260d4";
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
