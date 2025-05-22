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
  version = "0-unstable-2025-06-01";

  src = fetchFromGitHub {
    owner = "kolunmi";
    repo = "bazaar";
    rev = "54a3ed6637cdc5beece73350f719e2539e2b1120";
    hash = "sha256-0gve/uBp4BZkc58Aa3FUJfeAFF2wYj3BgrZzXTiF9CE=";
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
