{
  lib,
  meson,
  ninja,
  pkg-config,
  gettext,
  fetchFromGitLab,
  python3Packages,
  wrapGAppsHook4,
  gtk4,
  gtksourceview5,
  glib,
  gdk-pixbuf,
  gobject-introspection,
  desktop-file-utils,
  appstream-glib,
  shared-mime-info,
  libadwaita,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "gnome-secrets";
  version = "12.0";
  format = "other";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "secrets";
    rev = version;
    hash = "sha256-U+ez/rhaXROcLdXhFY992YzIRBCkR05hxkAYbWIpa/A=";
  };

  nativeBuildInputs = [
    meson
    ninja
    gettext
    pkg-config
    wrapGAppsHook4
    desktop-file-utils
    appstream-glib
    gobject-introspection
    shared-mime-info
  ];

  buildInputs = [
    gtk4
    gtksourceview5
    glib
    gdk-pixbuf
    libadwaita
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    construct
    pykcs11
    pykeepass
    pyotp
    validators
    yubico
    zxcvbn-rs-py
    pyhibp
  ];

  # Prevent double wrapping, let the Python wrapper use the args in preFixup.
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Password manager for GNOME which makes use of the KeePass v.4 format";
    homepage = "https://gitlab.gnome.org/World/secrets";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mvnetbiz ];
    teams = [ teams.gnome-circle ];
    mainProgram = "secrets";
  };
}
