{
  stdenv,
  lib,
  callPackage,
  fetchFromGitHub,
  bundlerEnv,
  nixosTests,
  ruby,
  pdfium-binaries,
  makeWrapper,
}:
let
  version = "2.1.7";
  src = fetchFromGitHub {
    owner = "docusealco";
    repo = "docuseal";
    rev = version;
    hash = "sha256-zNfxQPJjobYrx/YPGRn5QKwUd1VXetFqtBeII0wlmk4=";
    # https://github.com/docusealco/docuseal/issues/505#issuecomment-3153802333
    postFetch = "rm $out/db/schema.rb";
  };
  meta = {
    description = "Open source DocuSign alternative. Create, fill, and sign digital documents.";
    homepage = "https://www.docuseal.co/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ stunkymonkey ];
    platforms = lib.platforms.unix;
  };

  bundler = bundler.override { ruby = ruby; };
  rubyEnv = bundlerEnv {
    name = "docuseal-gems";
    ruby = ruby;
    inherit bundler;
    gemdir = ./.;
  };

  web = callPackage ./web.nix {
    inherit
      version
      src
      meta
      rubyEnv
      ;
  };
in
stdenv.mkDerivation {
  pname = "docuseal";
  inherit version src meta;

  buildInputs = [ rubyEnv ];
  propagatedBuildInputs = [ rubyEnv.wrappedRuby ];
  nativeBuildInputs = [ makeWrapper ];

  RAILS_ENV = "production";
  BUNDLE_WITHOUT = "development:test";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/public/packs
    cp -r ${src}/* $out
    cp -r ${web}/* $out/public/packs/

    bundle exec bootsnap precompile --gemfile app/ lib/

    runHook postInstall
  '';

  # create empty folder which are needed, but never used
  postInstall = ''
    chmod +w $out/tmp/
    mkdir -p $out/tmp/{cache,sockets}
  '';

  postFixup = ''
    wrapProgram $out/bin/rails \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ pdfium-binaries ]}"
  '';

  passthru = {
    tests = {
      inherit (nixosTests) docuseal-postgresql docuseal-sqlite;
    };
    updateScript = ./update.sh;
  };
}
