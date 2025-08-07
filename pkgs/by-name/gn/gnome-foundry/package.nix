{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  wrapGAppsNoGuiHook,
  glib,
  gom,
  libdex,
  json-glib,
  libpeas2,
  libsysprof-capture,
  libxml2,
  libyaml,
  libgit2,
  libssh2,
  cmark,
  webkitgtk_6_0,
  gtksourceview5,
  vte-gtk4,
  template-glib,
  flatpak,
  libspelling,
  testers,
  gnome,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-foundry";
  version = "1.0.beta";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "foundry";
    tag = finalAttrs.version;
    hash = "sha256-dO489pT5VOAMQm+QZFW0SoDeuU9/JCBuga11mMPdgGo=";
  };

  libdex_011 = libdex.overrideAttrs (_: rec {
    version = "0.11.1";
    src = fetchurl {
      url = "mirror://gnome/sources/libdex/${lib.versions.majorMinor version}/libdex-${version}.tar.xz";
      hash = "sha256-lCUKLYPm9z06yJcvGkOAFSNqRltWywBeDmv7nUlIc58=";
    };
  });

  template-glib_3_37 = template-glib.overrideAttrs (_: rec {
    version = "3.37.0";
    src = fetchurl {
      url = "mirror://gnome/sources/template-glib/${lib.versions.majorMinor version}/template-glib-${version}.tar.xz";
      hash = "sha256-IWR9XgUCvWfV/1+3G58HDDd+nnv3+s8S4IwLJtEXDOU=";
    };
  });

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsNoGuiHook
  ];

  buildInputs = [
    glib
    gom
    finalAttrs.libdex_011
    json-glib
    libpeas2
    libsysprof-capture
    libxml2
    libyaml
    libgit2
    libssh2
    cmark
    webkitgtk_6_0
    gtksourceview5
    vte-gtk4
    finalAttrs.template-glib_3_37
    flatpak
    libspelling
  ];

  # doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules { package = finalAttrs.finalPackage; };
    updateScript = gnome.updateScript {
      packageName = "foundry";
    };
  };

  meta = {
    description = "Library and companion command-line tool for GNOME development";
    homepage = "https://gitlab.gnome.org/GNOME/foundry";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ normalcea ];
    mainProgram = "foundry";
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "libfoundry-1"
      "libfoundry-gtk-1"
    ];
  };
})
