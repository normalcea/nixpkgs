{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6,
  makeWrapper,
  hyprutils,
  pciutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hyprsysteminfo";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprsysteminfo";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6PxVnMy66I342F1PJ/H94ti1aUAOiSWuD2NkD2XZJ78=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
    makeWrapper
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtwayland
    hyprutils
  ];

  postFixup = ''
    wrapProgram $out/bin/hyprsysteminfo \
      --prefix PATH : ${lib.makeBinPath [ pciutils ]}
  '';

  meta = {
    description = "Tiny qt6/qml application to display information about the running system";
    homepage = "https://github.com/hyprwm/hyprsysteminfo";
    license = lib.licenses.bsd3;
    mainProgram = "hyprsysteminfo";
    maintainers = with lib.maintainers; [ normalcea ];
    platforms = lib.platforms.linux;
  };
})
