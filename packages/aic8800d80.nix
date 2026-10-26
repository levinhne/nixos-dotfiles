{ lib
, stdenv
, fetchFromGitHub
, kernel
, kernelModuleMakeFlags
}:

# Out-of-tree driver for AICSemi AIC8800D80 USB WiFi 6 adapters (Tenda U11 / AX900),
# sourced from Tenda's U11 driver. Build with config.boot.kernelPackages.callPackage.
stdenv.mkDerivation rec {
  pname = "aic8800d80";
  version = "0-unstable-2026-10-23-${kernel.version}";

  src = fetchFromGitHub {
    owner = "shenmintao";
    repo = "aic8800d80";
    rev = "f9ab41822373efe70649d011edb587d1170364e7";
    hash = "sha256-FkIW3qqQLNO+wxVVmJp+igPx5owe+4Z605nNB/9xN/M=";
  };

  sourceRoot = "${src.name}/drivers/aic8800";

  nativeBuildInputs = kernel.moduleBuildDependencies;
  hardeningDisable = [ "pic" "format" ];

  # The loader reads firmware with filp_open() from a hardcoded /lib/firmware, which
  # NixOS doesn't have; point it at the firmware shipped in this package instead.
  postPatch = ''
    substituteInPlace aic_load_fw/aicbluetooth.c \
      --replace-fail '"/lib/firmware"' "\"$out/lib/firmware\""
  '';

  makeFlags = kernelModuleMakeFlags ++ [
    "KVER=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    runHook preInstall
    install -Dm444 -t $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/aic8800 \
      aic_load_fw/aic_load_fw.ko aic8800_fdrv/aic8800_fdrv.ko
    mkdir -p $out/lib/firmware
    cp -r ../../fw/aic8800* $out/lib/firmware/
    runHook postInstall
  '';

  meta = with lib; {
    description = "AIC8800D80 USB WiFi driver (Tenda U11 / AX900)";
    homepage = "https://github.com/shenmintao/aic8800d80";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
  };
}
