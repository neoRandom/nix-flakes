{
  description = "Node.js Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          # Define the packages you need available in your shell
          buildInputs = [
            pkgs.nodejs_24
          ];

          # Optional: Run commands when entering the shell
          shellHook = ''
            echo "🚀 Node.js environment loaded!"
            echo "Node version: $(node --version)"
            echo "NPM version:  $(npm --version)"
          '';
        };
      }
    );
}
