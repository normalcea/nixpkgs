{
  lib,
  fetchFromGitea,
  cmake,
  ninja,
  llvmPackages,
  stdenv,
  withOpenMP ? true,
}:
let
  derivation-build = (
    finalAttrs: {
      pname = "soundtouch";
      version = "2.4.0";

      src = fetchFromGitea {
        domain = "codeberg.org";
        owner = "soundtouch";
        repo = "soundtouch";
        tag = finalAttrs.version;
        hash = "sha256-7JUBAFURKtPCZrcKqL1rOLdsYMd7kGe7wY0JUl2XPvw=";
      };

      patches = [
        ./fix-cmake-install-dir.patch
      ];

      nativeBuildInputs = [
        cmake
        ninja
      ];

      buildInputs = lib.optionals withOpenMP [ llvmPackages.openmp ];

      cmakeFlags = [
        (lib.cmakeBool "BUILD_SHARED_LIBS" true)
        (lib.cmakeBool "SOUNDTOUCH_DLL" true)
        (lib.cmakeBool "OPENMP" withOpenMP)
      ];

      meta = {
        description = "Program and library for changing the tempo, pitch and playback rate of audio";
        longDescription = ''
          SoundTouch is an open-source audio processing library that allows
          changing the sound tempo, pitch and playback rate parameters
          independently from each other:

          - Change tempo while maintaining the original pitch
          - Change pitch while maintaining the original tempo
          - Change playback rate that affects both tempo and pitch at the same time
          - Change any combination of tempo/pitch/rate
        '';
        homepage = "https://www.surina.net/soundtouch/";
        license = lib.licenses.lgpl21Plus;
        maintainers = with lib.maintainers; [
          normalcea
          orivej
        ];
        mainProgram = "soundstretch";
        platforms = lib.platforms.all;
      };
    }
  );
in
if withOpenMP then
  llvmPackages.stdenv.mkDerivation derivation-build
else
  stdenv.mkDerivation derivation-build
