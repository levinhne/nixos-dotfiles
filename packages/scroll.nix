{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, wayland-scanner
, scdoc
, glslang
, hwdata
, libGL
, wayland
, wayland-protocols
, libxkbcommon
, pcre2
, json_c
, libevdev
, pango
, cairo
, libinput
, gdk-pixbuf
, librsvg
, libdrm
, libxcb-wm
, libxcb-render-util
, libxcb-image
, libxcb-errors
, libx11
, seatd
, vulkan-loader
, libliftoff
, libdisplay-info
, lcms2
, libcap
, libgbm
, pixman
, lua5_4
, systemd
, readline
, xwayland
, enableXWayland ? true
}:

# Sway fork with a PaperWM-style scrolling layout, built directly from
# upstream (github.com/dawsers/scroll) rather than a third-party flake
# wrapper. wlroots >=0.21,<0.22 is vendored in-tree (subprojects/wlroots)
# since nixpkgs does not package that version yet; omitting a system
# wlroots buildInput makes meson fall back to building the bundled copy,
# so its own build/runtime deps (glslang, hwdata, libliftoff, ...) are
# listed here too.
stdenv.mkDerivation (finalAttrs: {
  pname = "scroll";
  version = "1.12.20";

  inherit enableXWayland;

  src = fetchFromGitHub {
    owner = "dawsers";
    repo = "scroll";
    rev = finalAttrs.version;
    hash = "sha256-F8FDe4FSL99YxXlkNYpSvHNoU1kXBKamTqSpZ9qg0og=";
  };

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
    scdoc
    glslang
    hwdata
  ];

  buildInputs = [
    libGL
    wayland
    wayland-protocols
    libxkbcommon
    pcre2
    json_c
    libevdev
    pango
    cairo
    libinput
    gdk-pixbuf
    librsvg
    libdrm
    libxcb-render-util
    libxcb-image
    libxcb-errors
    libx11
    seatd
    vulkan-loader
    libliftoff
    libdisplay-info
    lcms2
    libcap
    libgbm
    pixman
    lua5_4
    systemd
    readline
  ]
  ++ lib.optionals finalAttrs.enableXWayland [
    libxcb-wm
    xwayland
  ];

  mesonFlags = [
    # xwayland is a wlroots subproject option (not exposed at the top level),
    # so it must be set with the "subproject:option" namespaced syntax.
    "-Dwlroots:xwayland=${if finalAttrs.enableXWayland then "enabled" else "disabled"}"
    (lib.mesonOption "sd-bus-provider" "libsystemd")
  ];

  meta = {
    description = "Sway fork with a PaperWM-style scrolling layout";
    homepage = "https://github.com/dawsers/scroll";
    changelog = "https://github.com/dawsers/scroll/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "scroll";
  };
})
