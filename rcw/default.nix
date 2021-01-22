{ stdenv, lib, fetchFromGitHub, python3, gettext }:

stdenv.mkDerivation rec {
  pname = "rcw";
  version = "LSDK-20.04-sr";

  src = fetchFromGitHub {
    owner = "SolidRun";
    repo = "rcw";
    rev = "be11b24dd0c05a10c85bf48bd804afa652458460";
    sha256 = "029qmic9r0gjs4zdsqyyyi4my108i95mjln4la59ml6m5y8mwjfw";
  };

  nativeBuildInputs = [ python3 gettext ];

  preBuild = ''
    cd lx2160acex7
    (
    export SP1=8 SP2=5 SP3=2 SRC1=1 SCL1=2 SPD1=1 CPU=22 SYS=14 MEM=29
    envsubst < configs/lx2160a_serdes.def > configs/lx2160a_serdes.rcwi
    envsubst < configs/lx2160a_timings.def > configs/lx2160a_timings.rcwi
    )
  '';

  installPhase = ''
    mkdir $out
    cp -r . $out/lx2160acex7
  '';
}
