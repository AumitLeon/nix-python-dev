{
  description = "Example Python development environment from Zero to Nix";

  # Flake inputs
  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-24.11";
  };

  # Flake outputs
  outputs = { 
    self,     
    nixpkgs-unstable,
    nixpkgs-stable
  }:
    let
      # Systems supported
      allSystems = [
        "x86_64-linux" # 64-bit Intel/AMD Linux
        "aarch64-linux" # 64-bit ARM Linux
        "x86_64-darwin" # 64-bit Intel macOS
        "aarch64-darwin" # 64-bit ARM macOS
      ];

      # Helper to provide system-specific attributes
      forAllSystems = f: nixpkgs-stable.lib.genAttrs allSystems (system: f {
        pkgs = import nixpkgs-stable { inherit system; };
      });
    in
    {
      # Development environment output
      devShells = forAllSystems ({ pkgs }: {
        default =
          let
            # Use Python 3.13
            python = pkgs.python313;
          in
          pkgs.mkShell {
            # The Nix packages provided in the environment
            packages = [
              # Python plus helper tools
              (python.withPackages (ps: with ps; [
                virtualenv # Virtualenv
                pip # The pip installer
              ]))
            ];
            shellHook = ''
              echo "🐍 You're entering our dev environment! 🐍"
              source python-nix-venv/bin/activate
            '';
          };
      });
    };
}
