{
  stdenv,
  fetchYarnDeps,
  yarn,
  fixup-yarn-lock,
  nodejs,
  which,
  version,
  src,
  meta,
  rubyEnv,
}:
stdenv.mkDerivation {
  pname = "docuseal-web";
  inherit version src meta;

  offlineCache = fetchYarnDeps {
    yarnLock = ./yarn.lock;
    hash = "sha256-IQOWLkVueuRs0CBv3lEdj6DOiumC4ZPuQRDxQHFh5fQ=";
  };

  nativeBuildInputs = [
    yarn
    fixup-yarn-lock
    nodejs
    rubyEnv
    which
  ];

  RAILS_ENV = "production";
  NODE_ENV = "production";

  # no idea how to patch ./bin/shakapacker. instead we execute the two bundle exec commands manually
  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)
    fixup-yarn-lock yarn.lock

    yarn config --offline set yarn-offline-mirror $offlineCache

    yarn install --offline --frozen-lockfile --ignore-engines --ignore-scripts --no-progress
    patchShebangs node_modules

    bundle exec rails assets:precompile
    bundle exec rails shakapacker:compile

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r public/packs $out

    runHook postInstall
  '';
}
