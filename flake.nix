{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };
  outputs = { self, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = (import nixpkgs) { inherit system; };
      in rec {
        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            pkg-config
            glfw
            raylib

            xorg.libX11
            xorg.libXrandr
            xorg.libXcursor
            # mesa
            # alsa-lib
            # xorg.xorgproto
          ];
        };
      });
}
