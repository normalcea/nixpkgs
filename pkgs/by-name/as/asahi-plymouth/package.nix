{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "asahi-plymouth";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "asahi-plymouth";
    tag = finalAttrs.version;
    hash = "sha256-JgsTiS9Qv+Ct7jRmJMCxbqVNkPahZpX4hFc9RE9aONY=";
  };

  installPhase = ''
    runHook preInstall

    find asahi/ -type f \
      -exec install -Dm644 -t $out/share/plymouth/themes/asahi/ {} \;

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    substituteInPlace $out/share/plymouth/themes/asahi/asahi.plymouth \
                      --replace-fail "/usr" "$out"

    runHook postFixup
  '';

  meta = {
    description = "Plymouth theme for Asahi Linux";
    homepage = "https://github.com/AsahiLinux/asahi-plymouth";
    license = with lib.licenses; [
      # Plymouth script code
      gpl3Plus
      # Asahi Linux logo
      cc-by-sa-40
      # "The Apple-like beachball is available for free for non-commercial use from PNGWing."
      unfree
    ];
    maintainers = with lib.maintainers; [ normalcea ];
    platforms = lib.platforms.linux;
  };
})
