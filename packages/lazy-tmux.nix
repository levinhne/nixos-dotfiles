{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "lazy-tmux";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "alchemmist";
    repo = "lazy-tmux";
    rev = "v${version}";
    hash = "sha256-npZ7PHJgNPgOkbba1RTd542n3phbfN1N4IVckE1bqqw=";
  };

  vendorHash = "sha256-VIkNVIUUmRNowt1u94pNnoQRS3EKwA1KaOWI5tWJqQM=";

  meta = with lib; {
    description = "A lazy tmux environment manager";
    homepage = "https://github.com/alchemmist/lazy-tmux";
    license = licenses.mit;
    mainProgram = "lazy-tmux";
  };
}
