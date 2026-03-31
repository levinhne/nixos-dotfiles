{ lib, stdenvNoCC, fetchurl, autoPatchelfHook, zstd }:

let
  pname = "crush";
  version = "0.52.0";

  releaseAssets = {
    x86_64-linux = {
      url = "https://github.com/charmbracelet/crush/releases/download/v${version}/crush-${version}-1-x86_64.pkg.tar.zst";
      hash = "sha256-KmFEv3JOv/+m+Tip8qztglEUlWsYopyuEO8Qf/n7Sgs=";
    };
    aarch64-linux = {
      url = "https://github.com/charmbracelet/crush/releases/download/v${version}/crush-${version}-1-aarch64.pkg.tar.zst";
      hash = "sha256-fIL9ORvdRG5x6UaXHnT2SH9afzNJ+6ufZAary8PQ548=";
    };
  };

  asset =
    releaseAssets.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system for ${pname}: ${stdenvNoCC.hostPlatform.system}");
in
stdenvNoCC.mkDerivation {
  inherit pname version;

  src = fetchurl {
    inherit (asset) url hash;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    zstd
  ];

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    runHook preUnpack
    tar --extract --file "$src"
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    cp -r usr/* "$out/"

    runHook postInstall
  '';

  meta = with lib; {
    description = "AI coding agent for the terminal";
    homepage = "https://github.com/charmbracelet/crush";
    license = licenses.fsl11Mit;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "crush";
    platforms = builtins.attrNames releaseAssets;
    maintainers = [ ];
  };
}
