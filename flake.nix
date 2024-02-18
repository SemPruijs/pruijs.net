{
  description = "Personal website";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    # add more inputs here
  };
  # pass inputs to output function
  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems =
        [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }:
        let
        in {
          packages = {
            # add build phases here
            default = pkgs.stdenv.mkDerivation {
              name = "Personal site";
              src = ./.;
              buildInputs = with pkgs; [ pandoc ];
                buildPhase = ''
                pandoc site.md -o index.html
              '';
              installPhase = ''
                mkdir $out
                cp index.html $out/index.html
              '';
            };
          };
          devShells = {
            default = pkgs.mkShell {
              # add your developer tools here
              buildInputs = with pkgs; [ pandoc ];
            };
          };
        };
    };
}
