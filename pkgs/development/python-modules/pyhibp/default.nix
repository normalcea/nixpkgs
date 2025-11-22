{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  requests,
  check-manifest,
  flake8,
  pytest,
  pytest-cov,
  tox,
}:

buildPythonPackage rec {
  pname = "pyhibp";
  version = "4.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-glw4PgrEOsNDja2C5d20V3N1T7sbXDuKxWZpSD8sZ+0=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    requests
  ];

  optional-dependencies = {
    dev = [
      check-manifest
      flake8
      pytest
      pytest-cov
      tox
    ];
  };

  pythonImportsCheck = [
    "pyhibp"
  ];

  meta = {
    description = "Interface to Troy Hunt's 'Have I Been Pwned' public API";
    homepage = "https://pypi.org/project/pyhibp/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ normalcea ];
    mainProgram = "pyhibp";
  };
}
