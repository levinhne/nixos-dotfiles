{ fetchurl
, freerdp
,
}:

# FPT Smart Cloud's FreeRDP fork ("freerdp-fci", tag 3.27.2-fcd), built from the
# source package published in ppa:fptsmartcloud/ppa using the nixpkgs recipe.
freerdp.overrideAttrs (old: rec {
  pname = "freerdp-fci";
  version = "3.27.2-fcd";

  src = fetchurl {
    # Store path names may not contain '~', so name the file explicitly.
    name = "freerdp-fci-${version}.tar.xz";
    url = "https://ppa.launchpadcontent.net/fptsmartcloud/ppa/ubuntu/pool/main/f/freerdp-fci/freerdp-fci_3.27.2+fcd~24.04.1.tar.xz";
    hash = "sha256-MF3Y2GU5vpF6/0G1ceR+WXQ0K1USOlcQv7MkfL5uXGQ=";
  };

  # Upstream meta.changelog points at a GitHub tag that fetchurl doesn't have.
  meta = removeAttrs old.meta [ "changelog" ] // {
    description = "FreeRDP fork used by FPT Cloud Desktop (FCD) Client";
    homepage = "https://launchpad.net/~fptsmartcloud/+archive/ubuntu/ppa";
  };
})
