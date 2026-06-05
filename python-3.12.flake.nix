{
  description = "Python 3.12 environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        python = pkgs.python312;
      in
      {
        # `nix develop`
        devShells.default = pkgs.mkShell {
          buildInputs = [ python ];

          shellHook = ''
            echo "$(python3 --version)"
          '';
        };

        # `nix build`
        packages.default = python;

        # `nix run`
        apps.default = {
          type = "app";
          program = "${python}/bin/python3";
        };
      }
    );
}
