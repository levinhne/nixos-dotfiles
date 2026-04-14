{ lib
, python3Packages
, fetchurl
, git
, gnugrep
, imagemagick
, makeWrapper
,
}:

python3Packages.buildPythonApplication rec {
  pname = "webdiff";
  version = "1.3.0";
  pyproject = true;

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/source/w/${pname}/${pname}-${version}.tar.gz";
    hash = "sha256-o/YKZmz0Z23bnhsAI5l1EnUrnofSWMy/z951uYxwXQU=";
  };

  build-system = with python3Packages; [
    poetry-core
  ];

  dependencies = with python3Packages; [
    aiohttp
    binaryornot
    pillow
    pygithub
    unidiff
  ];

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substituteInPlace webdiff/app.py \
      --replace-fail "subprocess.Popen((sys.executable, *sys.argv))" "subprocess.Popen(sys.argv)"
    substituteInPlace webdiff/toy.py \
      --replace-fail "subprocess.Popen((sys.executable, *sys.argv))" "subprocess.Popen(sys.argv)"
  '';

  pythonImportsCheck = [ "webdiff" ];
  doCheck = false;

  postFixup = ''
    for bin in "$out/bin/webdiff" "$out/bin/git-webdiff" "$out/bin/git-webshow"; do
      wrapProgram "$bin" \
        --prefix PATH : ${lib.makeBinPath [ git gnugrep imagemagick ]}
    done
  '';

  meta = with lib; {
    description = "Two-column web-based git difftool";
    homepage = "https://github.com/danvk/webdiff";
    license = licenses.asl20;
    mainProgram = "webdiff";
    maintainers = [ ];
  };
}
