{
  lib,
  botocore,
  buildPythonPackage,
  fetchFromGitHub,
  jmespath,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  s3transfer,
  setuptools,
}:

buildPythonPackage rec {
  pname = "boto3";
  inherit (botocore) version; # N.B: botocore, boto3, awscli needs to be updated in lockstep, bump botocore version for updating these.
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "boto";
    repo = "boto3";
    rev = "refs/tags/${version}";
    hash = "sha256-4WP5E8LuuxWZi8DK8yOpvyy6isSfB4eFcbctkTEd3As=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  pythonRelaxDeps = [ "s3transfer" ];

  propagatedBuildInputs = [
    botocore
    jmespath
    s3transfer
  ];

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "boto3" ];

  disabledTestPaths = [
    # Integration tests require networking
    "tests/integration"
  ];

  optional-dependencies = {
    crt = [ botocore.optional-dependencies.crt ];
  };

  meta = with lib; {
    description = "AWS SDK for Python";
    homepage = "https://github.com/boto/boto3";
    changelog = "https://github.com/boto/boto3/blob/${version}/CHANGELOG.rst";
    license = licenses.asl20;
    longDescription = ''
      Boto3 is the Amazon Web Services (AWS) Software Development Kit (SDK) for
      Python, which allows Python developers to write software that makes use of
      services like Amazon S3 and Amazon EC2.
    '';
    maintainers = with maintainers; [ anthonyroussel ];
  };
}
