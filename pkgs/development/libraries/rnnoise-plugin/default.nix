{
  lib,
  stdenv,
  alsa-lib,
  cmake,
  fetchFromGitHub,
  freetype,
  gtk3-x11,
  mount,
  pcre,
  pkg-config,
  webkitgtk,
  xorg,
}:
stdenv.mkDerivation rec {
  pname = "rnnoise-plugin";
  version = "1.03";

  src = fetchFromGitHub {
    owner = "werman";
    repo = "noise-suppression-for-voice";
    rev = "v${version}";
    sha256 = "sha256-1DgrpGYF7G5Zr9vbgtKm/Yv0HSdI7LrFYPSGKYNnNDQ=";
  };

  nativeBuildInputs = [cmake pkg-config];

  buildInputs = [
    alsa-lib
    freetype
    gtk3-x11
    pcre
    webkitgtk
    xorg.libX11
    xorg.libXrandr
  ];

  cmakeFlags = ["-DCMAKE_BUILD_TYPE=Release"];

  meta = with lib; {
    description = "A real-time noise suppression plugin for voice based on Xiph's RNNoise";
    homepage = "https://github.com/werman/noise-suppression-for-voice";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [panaeon henrikolsson sciencentistguy];
  };
}
