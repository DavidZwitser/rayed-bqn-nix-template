{
  description = "Rayed BQN Template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    bqnlsp.url = "sourcehut:~detegr/bqnlsp";
    rayed-bqn.url = "github:DavidZwitser/rayed-bqn";
    # Get specific verion of raylib
    # raylib.url = "github:"
  };

  outputs = { self, nixpkgs, flake-utils, bqnlsp, rayed-bqn}:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      bqnlspPkg = bqnlsp.packages.${system}.lsp;

      cbqn = pkgs.cbqn-replxx;
      raylib = pkgs.raylib;
    in rec {

      packages.default = pkgs.writeShellScriptBin "run" /*bash*/ ''
        # Setting up rayed-bqn and its submodules
        git submodule update --init --recursive

        mkdir ./rayed-bqn/lib
        ln -sf ${raylib}/lib/libraylib.dylib ./rayed-bqn/lib/libraylib.dylib

        # Running the program
     	  ${cbqn}/bin/bqn -f ./src/main.bqn
      '';

      devShells.default = pkgs.mkShell {
        buildInputs = [
          cbqn
          bqnlspPkg
          pkgs.nixd
        ];
      };
  });
}
