{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/23.11";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = { self, nixpkgs, flake-utils }:
    let
      system = flake-utils.lib.system.x86_64-linux;
      compiler = "ghc948";
      pkgs = import nixpkgs { system = system; };
      hPkgs = pkgs.haskell.packages."${compiler}";
      myDevTools = with hPkgs; [
        ghc
        ghcid
        fourmolu
        hlint
        cabal2nix
        haskell-language-server
        implicit-hie
        retrie
        cabal-install
        cabal-fmt
        pkgs.zlib
      ];
      app = pkgs.haskell.packages.${compiler}.callPackage ./cabal.nix;
    in {
      overlays = {
        mods = _: prev: {
          mods = prev.haskell.packages.${compiler}.callPackage ./cabal.nix { };
        };
      };
      apps.${system}.default = {
        type = "app";
        program = "${app { }}/bin/mods";
      };
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = myDevTools;
        LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath myDevTools;
      };
      packages.${system}.default = app { };
    };
}
