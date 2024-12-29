{
  description = "Rayed BQN Template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    bqnlsp.url = "sourcehut:~detegr/bqnlsp";
    rayed-bqn.url = "/tmp/rayed-bqn";
  };

  outputs = { self, nixpkgs, flake-utils, bqnlsp, rayed-bqn}:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      bqnlspPkg = bqnlsp.packages.${system}.lsp;
      rayedBqn = rayed-bqn.packages.${system}.default;
      cbqn = pkgs.cbqn-replxx;

      name = "rayed-bqn-project"; # Give own name
      entryFile = "main.bqn"; # Entry file in src
    in {

      packages.default = pkgs.stdenv.mkDerivation {
        pname = name;
        version = "0.1.0";
        src = ./.;

        buildInputs = [ cbqn ];
        buildPhase = ''
          mkdir -p $out
          cp -r ./src $out
          ln -sf ${rayedBqn} $out/rayed-bqn

          mkdir -p $out/bin
          echo "#!/bin/bash" > $out/bin/${name}
          echo "${pkgs.cbqn-replxx}/bin/cbqn $out/src/${entryFile}" >> $out/bin/${name}
          chmod +x $out/bin/${name}
        '';
      };

      apps.default = {
        type = "app";
        program = "${self.packages.${system}.default}/bin/${name}";
      };

      devShells.default = pkgs.mkShell {
        buildInputs = [
          cbqn
          bqnlspPkg
          pkgs.nixd
        ];

        shellHook = ''
          ln -sf ${rayedBqn} ./rayed-bqn
        '';
      };
  });
}
