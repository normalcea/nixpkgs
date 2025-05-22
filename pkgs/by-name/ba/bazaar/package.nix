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
  libglycin,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "bazaar";
  version = "0-unstable-2025-05-22";

  src = fetchFromGitHub {
    owner = "kolunmi";
    repo = "bazaar";
    rev = "b7a6ca066f7fef009dcb799963ef97d9d5b4cc52";
    hash = "sha256-UXGDRO/xCnT16CDaz+8L6HjESpSUfDi0w5SzycBHarM=";
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
    libglycin
  ];

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
