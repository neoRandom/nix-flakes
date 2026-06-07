{
  description = "Rust latest stable environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ rust-overlay.overlays.default ];
        };

        rust = pkgs.rust-bin.stable.latest.default.override {
          extensions = [ "rust-src" "rust-analyzer" "clippy" "rustfmt" ];
        };
      in
      {
        # `nix develop`
        devShells.default = pkgs.mkShell {
          buildInputs = [
            rust
            pkgs.pkg-config
            pkgs.gcc
            pkgs.clang
            pkgs.cmake
          ];

          shellHook = ''
            echo "$(rustc --version)"
            echo "$(cargo --version)"
          '';

          # Rust toolchain env vars
          RUST_SRC_PATH = "${rust}/lib/rustlib/src/rust/library";
        };

        # `nix build`
        packages.default = rust;
      }
    );
}
