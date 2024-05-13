{ haskell, compiler ? "ghc948" }:
haskell.packages.${compiler}.callCabal2nix "" ./mods { }
