{
  lib,
  stdenv,
  fetchFromGitHub,
  blueprint-compiler,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  appstream,
  bubblewrap,
  flatpak,
  glib-networking,
  glycin-loaders,
  gtk4,
  json-glib,
  libadwaita,
  libdex,
  libglycin,
  libsoup_3,
  libxmlb,
  libyaml,
  md4c,
  nix-update-script,
  contentConfigPath ? "",
  blocklistPath ? "",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bazaar";
  version = "0.5.10";

  src = fetchFromGitHub {
    owner = "kolunmi";
    repo = "bazaar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-isswXfOJZ04MQbaQ6AcNSxasNllGSRS6vukskS0FvCk=";
  };

  nativeBuildInputs = [
    blueprint-compiler
    desktop-file-utils
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    appstream
    flatpak
    glib-networking
    gtk4
    json-glib
    libadwaita
    libdex
    libglycin
    libsoup_3
    libxmlb
    libyaml
    md4c
  ];

  mesonFlags = [
    (lib.mesonOption "hardcoded_content_config_path" contentConfigPath)
    (lib.mesonOption "hardcoded_blocklist_path" blocklistPath)
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "$out/bin:${lib.makeBinPath [ bubblewrap ]}"
      --prefix XDG_DATA_DIRS : "${glycin-loaders}/share"
    )
  '';

  passthru = {
    inherit (libglycin) glycinPathsPatch;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "FlatHub-first app store for GNOME";
    homepage = "https://github.com/kolunmi/bazaar";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      dtomvan
      normalcea
    ];
    mainProgram = "bazaar";
    platforms = lib.platforms.linux;
  };
})
