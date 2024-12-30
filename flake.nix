{
  description = "Python devShell Flake";

  # Flake inputs
  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs-unstable,  nixpkgs-stable, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs-stable.legacyPackages.${system};
        in
        with pkgs;
        {
          devShells.default = mkShell {
             buildInputs = (with pkgs.python313Packages; [
                virtualenv
                pip
             ]);
             shellHook = ''
              echo "🐍 You're entering our dev environment! 🐍"
              source python-nix-venv/bin/activate
            '';
          };
        }
      );
}
