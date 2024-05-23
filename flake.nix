{
  inputs =
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

      flake-utils.url = "github:numtide/flake-utils";
    };

  outputs = { self, nixpkgs, ... }@inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system:
    let pkgs = nixpkgs.legacyPackages.${system}; in
    {
      devShells.default = pkgs.mkShell {
          nativeBuildInputs = let
            php = pkgs.php83.buildEnv {
                extraConfig = ''xdebug.mode=coverage'';
                extensions = { enabled, all }: enabled ++ (with all; [
                    xdebug
                ]);
            };
           in with pkgs; [
              php
              php.packages.composer
           ];
      };
    }
    );
}

