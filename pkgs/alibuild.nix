{ lib, python310, fetchPypi }:

python310.pkgs.buildPythonApplication rec {
  pname = "alibuild";
  version = "1.14.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gPHLo0fTWZLZBOXnReKfkZgXLoDK2Hjh43azvIq0J4w=";
  };

  doCheck = false;
  propagatedBuildInputs = with python310.pkgs; [
    requests
    pyyaml
    boto3
    jinja2
    distro
  ];

  meta = with lib; {
    homepage = "https://alisw.github.io/alibuild/";
    description = "Build tool for ALICE experiment software";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ktf ];
  };
}
