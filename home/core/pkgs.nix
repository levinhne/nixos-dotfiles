{ pkgs, pkgs-unstable, ... }:

let
  # yt-dlp nightly build, pinned to a specific yt-dlp-nightly-builds release.
  # Stable/nixpkgs yt-dlp lags behind YouTube extractor breakage (e.g. 403 on
  # android_vr client, https://github.com/yt-dlp/yt-dlp/issues/17456), so we
  # build from the nightly source tarball instead. Bump `ytDlpNightlyVersion`
  # and `ytDlpNightlyHash` from https://github.com/yt-dlp/yt-dlp-nightly-builds/releases/latest
  # when you need a newer fix (run `nix store prefetch-file <tarball-url>` for the hash).
  ytDlpNightlyVersion = "2026.08.18.122307";
  ytDlpNightlyHash = "sha256-6RaYh6mGO8Y14dN2D5DLN1iNrSERBk1FTHkKqqEhNJo=";
  yt-dlp-nightly = pkgs.yt-dlp.overrideAttrs (_: {
    version = ytDlpNightlyVersion;
    src = pkgs.fetchurl {
      url = "https://github.com/yt-dlp/yt-dlp-nightly-builds/releases/download/${ytDlpNightlyVersion}/yt-dlp.tar.gz";
      hash = ytDlpNightlyHash;
    };
  });
in
{
  home.packages = with pkgs; [
    bat
    eza
    jq
    tree
    qutebrowser
    google-chrome
    firefox
    wpaperd
vscode
    git-extras
    pkgs-unstable.codex
    k9s
    kubectl
    podman-tui
    nixpkgs-fmt
    retrosmart-cursors
    ffmpeg
    mpv
    yt-dlp-nightly
    zk
    buku
  ];
}
