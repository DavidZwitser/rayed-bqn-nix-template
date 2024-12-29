{
  description = "Rayed BQN Template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    bqnlsp.url = "sourcehut:~detegr/bqnlsp";
    rayed-bqn.url = "github:DavidZwitser/rayed-bqn";
  };

  outputs = { self, nixpkgs, flake-utils, bqnlsp, rayed-bqn}:
    flake-utils.lib.eachDefaultSystem (system:
    let
      name = "rayed-bqn-project";   # Project name
      entryFile = "main.bqn";       # Entry file in src

      pkgs = nixpkgs.legacyPackages.${system};
      bqnlspPkg = bqnlsp.packages.${system}.lsp;
      rayedBQN = rayed-bqn.packages.${system}.default;
      CBQN = pkgs.cbqn-replxx;
    in {

      packages.default = pkgs.stdenv.mkDerivation {
        pname = name;
        version = "0.1.0";
        src = ./.;

        buildInputs = [ CBQN pkgs.git ];
        buildPhase = ''
          mkdir -p $out
          cp -r ./src $out
          ln -sf ${rayedBQN} $out/rayed-bqn

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
          CBQN
          bqnlspPkg
          pkgs.nixd
          pkgs.nil
        ];

        shellHook = ''
          # Create symlink to rayed-bqn if it isn't there yet
          [! -L "./rayed-bqn"] && ln -s "${rayedBQN}" "./rayed-bqn"
        '';
      };
  });
}
