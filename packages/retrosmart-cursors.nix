{ lib, stdenvNoCC, fetchFromGitHub, imagemagick, xcursorgen }:

stdenvNoCC.mkDerivation rec {
  pname = "retrosmart-x11-cursors";
  version = "unstable-2023-07-18";

  src = fetchFromGitHub {
    owner = "mdomlop";
    repo = "retrosmart-x11-cursors";
    rev = "1d78429beb6823eaabbc20370ce1205e5049388a";
    sha256 = "sha256-smsC02aDdOWlNfk+1/lVwH41qDCpPDxePDbrmou8M/4=";
  };

  nativeBuildInputs = [ imagemagick xcursorgen ];

  buildPhase = ''
    runHook preBuild
    make
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    
    mkdir -p $out/share/icons
    
    # Copy all built cursor themes
    for theme in retrosmart-xcursor-*; do
      if [ -d "$theme" ]; then
        cp -r "$theme" "$out/share/icons/"
      fi
    done
    
    runHook postInstall
  '';

  meta = with lib; {
    description = "A Retro Cursor Theme for X11";
    homepage = "https://github.com/mdomlop/retrosmart-x11-cursors";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
