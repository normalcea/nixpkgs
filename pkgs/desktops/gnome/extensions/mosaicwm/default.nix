{
  lib,
  stdenv,
  fetchFromGitHub,
  glib,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "gnome-shell-extension-mosaicwm";
  version = "0-unstable-2025-12-14";

  src = fetchFromGitHub {
    owner = "CleoMenezesJr";
    repo = "MosaicWM";
    rev = "058d2925cdaf141321ec18cfd51405b464f79ac8";
    hash = "sha256-mq1o3IP/XS9AMTXyoLSIEy7DjT76OP+uGjPp/Kl2e8E=";
  };

  nativeBuildInputs = [
    glib
  ];

  buildPhase = ''
    runHook preBuild

    glib-compile-schemas --strict extension/schemas

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/gnome-shell/extensions
    cp -r -T extension $out/share/gnome-shell/extensions/mosaicwm@cleomenezesjr.github.io

    runHook postInstall
  '';

  passthru = {
    extensionUuid = "mosaicwm@cleomenezesjr.github.io";
    extensionPortalSlug = "mosaicwm";
    updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  };

  meta = {
    description = "Extension for rethinking window management for GNOME Shell";
    longDescription = ''
      A GNOME Shell extension that provides automatic window tiling in
      a mosaic layout. Inspired by GNOME's vision for rethinking
      window management, Mosaic WM intelligently arranges windows to
      maximize screen pace while maintaining visual harmony.
    '';
    homepage = "https://github.com/CleoMenezesJr/MosaicWM";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ normalcea ];
    platforms = lib.platforms.linux;
  };
}
