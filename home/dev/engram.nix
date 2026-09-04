# Engram: persistent memory system for AI coding agents (MCP server + CLI + TUI).
# Not in nixpkgs, so we package the pinned static release binary directly.
# Bump `version`/`hash` from https://github.com/Gentleman-Programming/engram/releases/latest
# (run `nix store prefetch-file <tarball-url>` for the hash).
{ pkgs, ... }:

let
  version = "1.20.0";
  engram = pkgs.stdenv.mkDerivation {
    pname = "engram";
    inherit version;

    src = pkgs.fetchurl {
      url = "https://github.com/Gentleman-Programming/engram/releases/download/v${version}/engram_${version}_linux_amd64.tar.gz";
      hash = "sha256-fcMAMxjjA77iaaR3IUTzzgHI7HAL/VJKrsdncKzTico=";
    };

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      tar -xzf $src -C $out/bin engram
      chmod +x $out/bin/engram
      runHook postInstall
    '';

    meta = {
      description = "Persistent memory system (MCP server, CLI, TUI) for AI coding agents";
      homepage = "https://github.com/Gentleman-Programming/engram";
      platforms = [ "x86_64-linux" ];
      mainProgram = "engram";
    };
  };
in
{
  home.packages = [ engram ];
}
