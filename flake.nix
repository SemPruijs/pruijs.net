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
          packages = rec {
            # add build phases here
            default = site;
            site = pkgs.stdenv.mkDerivation {
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
            spellcheck = pkgs.stdenv.mkDerivation {
              name = "spellcheck";
              dontUnpack = true;
              src = ./.;
              buildInputs = [ pkgs.nodePackages.cspell ];
              doCheck = true;
              checkPhase = ''
                cd $src/.
                cspell lint --no-progress "**"
                touch $out
              '';
            };
          };
          devShells = {
            default = pkgs.mkShell {
              # add your developer tools here
              buildInputs = with pkgs; [ pandoc nodePackages.cspell ];
            };
          };
        };
    };
}
