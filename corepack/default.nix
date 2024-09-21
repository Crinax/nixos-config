{ pkgs, ... }:
let 
  epkgs = [
    pkgs.nodejs_20
    pkgs.pkg-config
    pkgs.openssl
  ];
in
  pkgs.stdenv.mkDerivation {
    name = "env";
    buildInputs = epkgs;
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      corepack enable --install-directory=$out/bin
    '';
  }
