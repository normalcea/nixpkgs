{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gettext,
  glib,
  gtk4,
  desktop-file-utils,
  wrapGAppsHook4,
  libadwaita,
  libdex,
  flatpak,
  appstream,
  libxmlb,
  libyaml,
  libglycin,
  unstableGitUpdater,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "bazaar";
  version = "0-unstable-2025-06-12";

  src = fetchFromGitHub {
    owner = "kolunmi";
    repo = "bazaar";
    rev = "cbba8c8aa279bf9ecffb7c3a4162c199ed20d3f4";
    hash = "sha256-Z2M4mi8PCYe/91pAq4vLbutQ7E0fiAnu6rW8wd6tMh0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    glib
    gtk4
    desktop-file-utils
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
    libdex
    flatpak.dev
    appstream
    libxmlb
    libyaml
    libglycin
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Flathub store for GNOME";
    longDescription = ''
      In the works flatpak store
    '';
    homepage = "https://github.com/kolunmi/bazaar";
    downloadPage = "";
    changelog = "";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ normalcea ];
    mainProgram = "bazaar";
    platforms = lib.platforms.linux;
  };
})
