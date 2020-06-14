{ mkDerivation, base, file-embed, hakyll, stdenv, text }:
mkDerivation {
  pname = "weeezes-pages";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base file-embed hakyll text ];
  license = "unknown";
  hydraPlatforms = stdenv.lib.platforms.none;
}
