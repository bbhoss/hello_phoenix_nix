{
  description = "Development environment";

  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixpkgs-unstable"; };
    flake-utils = { url = "github:numtide/flake-utils"; };
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        inherit (nixpkgs.lib) optionals;
        pkgs = import nixpkgs { inherit system; };

        erlang = pkgs.erlangR25.override {
          opensslPackage = pkgs.libressl;
        };
        beamPkg = pkgs.beam.packagesWith erlang;
        elixir = beamPkg.elixir_1_14;
        locales = if pkgs.stdenv.hostPlatform.libc == "glibc" then
          pkgs.glibcLocales.override {
            allLocales = false; # Only en-US utf8
          }
        else
          pkgs.locale;
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [ pkgs.postgresql_15 elixir locales ]
            ++ optionals pkgs.stdenv.isDarwin
            (with pkgs.darwin.apple_sdk.frameworks; [ Cocoa CoreServices ]);
        };
      });
}
