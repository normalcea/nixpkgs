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
  glib,
  shared-mime-info,
  gtk4,
  libadwaita,
  wrapGAppsHook4,
  libxmlxx5,
  blueprint-compiler,
  qt6,
  yt-dlp,
  ffmpeg,
  aria2,
  nix-update-script,
  useQtInterface ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "parabolic";
  version = "2025.1.3";

  src = fetchFromGitHub {
    owner = "NickvisionApps";
    repo = "Parabolic";
    tag = "${finalAttrs.version}";
    hash = "sha256-EzV3jjodS5E8BPmv982FlONrHqAnpbSFOtx5Gqobo44=";
  };

  nativeBuildInputs =
    [
      cmake
      gettext
      ninja
      pkg-config
    ]
    ++ (
      if !useQtInterface then
        [
          itstool
          yelp-tools
          wrapGAppsHook4
          blueprint-compiler
          glib
          shared-mime-info
        ]
      else
        [ qt6.wrapQtAppsHook ]
    );

  buildInputs =
    [
      libnick
      boost
    ]
    ++ (
      if !useQtInterface then
        [
          glib
          gtk4
          libadwaita
          libxmlxx5
        ]
      else
        [
          qt6.qtbase
          qt6.qtsvg
        ]
    );

  cmakeFlags = [
    (lib.cmakeFeature "UI_PLATFORM" (if !useQtInterface then "gnome" else "qt"))
  ];

  preFixup =
    (if !useQtInterface then "gappsWrapperArgs" else "qtWrapperArgs")
    + ''
      +=(
            --prefix PATH : ${
              lib.makeBinPath [
                aria2
                ffmpeg
                yt-dlp
              ]
            }
          )
    '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Graphical frontend for yt-dlp to download video and audio";
    longDescription = ''
      Parabolic is a user-friendly frontend for `yt-dlp` that supports
      many features including but limited to:
      - Downloading and converting videos and audio using ffmpeg.
      - Supporting multiple codecs.
      - Offering YouTube sponsorblock support.
      - Running multiple downloads at a time.
      - Downloading metadata and video subtitles.
      - Allowing the use of `aria2` for parallel downloads.
      - Offering a graphical keyring to manage account credentials.
      - Being available as both a Qt and GNOME application.

      By default, the GNOME interface is used, but the Qt interface can
      be built by overriding the `useQtInterface` parameter to `true`.
    '';
    homepage = "https://github.com/NickvisionApps/Parabolic";
    license = lib.licenses.gpl3Plus;
    maintainers = [
      lib.maintainers.normalcea
    ];
    mainProgram = "org.nickvision.tubeconverter";
    platforms = lib.platforms.linux;
  };
})
