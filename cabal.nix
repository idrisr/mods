{ mkDerivation, base, filepath, fmt, lib, raw-strings-qq, tasty, tasty-hunit
, time, trifecta }:
mkDerivation {
  pname = "mods";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [ base fmt raw-strings-qq time trifecta ];
  executableHaskellDepends = [ base filepath ];
  testHaskellDepends = [ base raw-strings-qq tasty tasty-hunit trifecta ];
  license = "unknown";
  mainProgram = "mods";
}
