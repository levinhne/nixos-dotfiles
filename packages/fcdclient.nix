{ lib
, stdenvNoCC
, fetchurl
, dpkg
, buildFHSEnv
, writeShellScriptBin
, callPackage
, freerdp-fci ? callPackage ./freerdp-fci.nix { }
, xdg-utils
,
}:

let
  pname = "fcdclient";
  version = "5.3.0-4.3.0";

  # FCDClient is a PyInstaller bundle that puts its own (Ubuntu-built) libraries
  # on LD_LIBRARY_PATH. Helpers it spawns are Nix binaries, so give them back the
  # caller's environment before they start.
  restoreHostEnv = ''
    if [[ -v FCDCLIENT_ORIG_LD_LIBRARY_PATH ]]; then
      export LD_LIBRARY_PATH="$FCDCLIENT_ORIG_LD_LIBRARY_PATH"
      [[ -n "$LD_LIBRARY_PATH" ]] || unset LD_LIBRARY_PATH
      unset LD_LIBRARY_PATH_ORIG QT_PLUGIN_PATH QT_QPA_PLATFORM_PLUGIN_PATH FCDCLIENT_LIB_PATH_DIR
    fi
  '';

  unwrapped = stdenvNoCC.mkDerivation {
    pname = "${pname}-unwrapped";
    inherit version;

    src = fetchurl {
      url = "https://ppa.launchpadcontent.net/fptsmartcloud/ppa/ubuntu/pool/main/f/fcdclient/fcdclient_${version}-noble_amd64.deb";
      hash = "sha256-E8eiit0zNm0cs62ZJB80tEqTuw9El4vs/iRdRc/+UuE=";
    };

    nativeBuildInputs = [ dpkg ];

    # Prebuilt PyInstaller bundle: leave the ELF files exactly as shipped.
    dontConfigure = true;
    dontBuild = true;
    dontStrip = true;
    dontPatchELF = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/share
      cp -a opt $out/opt
      cp -a usr/share/icons usr/share/applications $out/share/

      cat > $out/bin/fcdclient <<EOF
      #!/usr/bin/env bash
      export FCDCLIENT_ORIG_LD_LIBRARY_PATH="\''${LD_LIBRARY_PATH-}"
      unset QML_IMPORT_PATH QML2_IMPORT_PATH
      exec $out/opt/fcdclient/run.sh "\$@"
      EOF

      cat > $out/bin/nla-login <<EOF
      #!/usr/bin/env bash
      exec $out/opt/fcdclient/app/FCDClient/nla_login/nla-login "\$@"
      EOF

      install -m755 usr/bin/fcdrdp $out/bin/fcdrdp
      substituteInPlace $out/bin/fcdrdp \
        --replace-fail 'BUNDLED_XFRDP=/opt/freerdp-nightly/bin/xfreerdp3' \
                       'BUNDLED_XFRDP=${lib.getExe' freerdp-fci "xfreerdp"}' \
        --replace-fail 'BUNDLED_LIB=/opt/fcdclient/freerdp/usr/lib' '${restoreHostEnv}' \
        --replace-fail 'export LD_LIBRARY_PATH="$BUNDLED_LIB:''${LD_LIBRARY_PATH}"' ':' \
        --replace-fail '/opt/fcdclient/app/FCDClient/nla_login/nla-login' \
                       "$out/opt/fcdclient/app/FCDClient/nla_login/nla-login" \
        --replace-fail 'WLOG_FILEAPPENDER_OUTPUT_FILE_PATH=/home/$USER/.cache/fcd-client' \
                       'WLOG_FILEAPPENDER_OUTPUT_FILE_PATH="''${XDG_CACHE_HOME:-$HOME/.cache}/fcd-client"'
      # udsrdp ships as an identical copy of fcdrdp
      cmp usr/bin/fcdrdp usr/bin/udsrdp
      cp $out/bin/fcdrdp $out/bin/udsrdp

      chmod 755 $out/bin/* $out/opt/fcdclient/run.sh
      substituteInPlace $out/share/applications/fcdclient.desktop \
        --replace-fail 'Exec=/opt/fcdclient/app/FCDClient/FCDClient %u' 'Exec=fcdclient %u'

      runHook postInstall
    '';
  };

  # Links the app opens (OAuth2 sign-in, help pages) must not inherit the bundle's libraries.
  xdg-open = writeShellScriptBin "xdg-open" ''
    ${restoreHostEnv}
    exec ${lib.getExe' xdg-utils "xdg-open"} "$@"
  '';
in
buildFHSEnv {
  inherit pname version;

  # freerdp-fci stays off PATH (as on Ubuntu, where it lives in /opt): sessions
  # must go through fcdrdp/udsrdp, which reference it directly.
  targetPkgs =
    pkgs: with pkgs; [
      unwrapped
      xdg-open
      yad
      util-linux # setarch
      lsb-release

      # Libraries the bundles expect from the host. FCDClient bundles most of
      # its own; nla_login (a separate, slimmer bundle) needs the rest.
      zlib
      zstd
      libGL
      libgbm
      libdrm
      libxcb
      libxcb-cursor
      libxcb-image
      libxcb-keysyms
      libxcb-render-util
      libxcb-wm
      libxkbcommon
      libxcomposite
      libx11 # also /usr/share/X11/locale for the bundled libX11
      xkeyboard-config # /usr/share/X11/xkb for the bundled libxkbcommon
      wayland
      fontconfig
      freetype
      dbus
      glib
      krb5
      cups

      # Qt's GTK3 platform theme plugin
      gtk3
      at-spi2-core
      cairo
      pango
      gdk-pixbuf
    ];

  runScript = "${unwrapped}/bin/fcdclient";

  extraInstallCommands = ''
    mkdir -p $out/share
    cp -r ${unwrapped}/share/icons ${unwrapped}/share/applications $out/share/
  '';

  passthru = { inherit unwrapped freerdp-fci; };

  meta = {
    description = "FPT Cloud Desktop (FCD) Client";
    homepage = "https://launchpad.net/~fptsmartcloud/+archive/ubuntu/ppa";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "fcdclient";
  };
}
