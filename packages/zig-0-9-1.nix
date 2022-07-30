{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  llvmPackages_13,
  libxml2,
  zlib,
}:
llvmPackages_13.stdenv.mkDerivation rec {
  pname = "zig";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "dit7ya";
    repo = pname;
    rev = "c8a7db5459ca363429a39a996276c858969c4cde";
    hash = "sha256-dId8/n1fwnbpf5Pt3ykxacyNOvJPiKuQPkIMzh5+HTY=";
  };

  nativeBuildInputs = [
    cmake
    llvmPackages_13.llvm.dev
  ];

  buildInputs =
    [
      libxml2
      zlib
    ]
    ++ (with llvmPackages_13; [
      libclang
      lld
      llvm
    ]);

  preBuild = ''
    export HOME=$TMPDIR;
  '';

  cmakeFlags = [
    # file RPATH_CHANGE could not write new RPATH
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    ./zig test --cache-dir "$TMPDIR" -I $src/test $src/test/behavior.zig
    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://ziglang.org/";
    description = "General-purpose programming language and toolchain for maintaining robust, optimal, and reusable software";
    license = licenses.mit;
    maintainers = with maintainers; [aiotter andrewrk AndersonTorres];
    platforms = platforms.unix;
  };
}
