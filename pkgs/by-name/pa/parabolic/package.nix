{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gettext,
  itstool,
  ninja,
  yelp-tools,
  pkg-config,
  libnick,
  boost,
  curl,
  glib,
  shared-mime-info,
  libsecret,
  gtk4,
  libadwaita,
  wrapGAppsHook4,
  libxmlxx5,
  blueprint-compiler,
  yt-dlp,
  ffmpeg,
  aria2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "parabolic";
  version = "2024.11.1";

  src = fetchFromGitHub {
    owner = "NickvisionApps";
    repo = "Parabolic";
    rev = "${finalAttrs.version}";
    hash = "sha256-Vm5QVmPc0uipLlDy5Wn9S7HQ/0rLg0wVk0XdWRECQDY=";
  };

  nativeBuildInputs = [
    cmake
    gettext
    itstool
    ninja
    yelp-tools
    pkg-config
    wrapGAppsHook4
    blueprint-compiler
    glib
    shared-mime-info
  ];

  buildInputs = [
    libnick
    boost
    curl
    libsecret
    glib
    gtk4
    libadwaita
    libxmlxx5
  ];

  cmakeFlags = [
    (lib.cmakeFeature "UI_PLATFORM" "gnome")
  ];

  runtimeDependencies = [
    yt-dlp
    ffmpeg
    aria2
  ];

  dontWrapGApps = true;
  postFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postInstall = ''
    wrapProgram $out/bin/org.nickvision.tubeconverter \
      --prefix PATH : ${lib.makeBinPath finalAttrs.runtimeDependencies}
  '';

  meta = with lib; {
    description = "Graphical frontend for yt-dlp to download video and audio";
    homepage = "https://github.com/NickvisionApps/Parabolic";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      ewuuwe
      normalcea
      getchoo
    ];
    mainProgram = "org.nickvision.tubeconverter";
    platforms = platforms.linux;
  };
})
