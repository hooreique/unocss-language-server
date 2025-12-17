{
  description = "unocss language server";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      perSystem =
        { config, pkgs, ... }:
        {
          packages = {
            unocss-language-server = pkgs.callPackage ./package.nix { };
            default = config.packages.unocss-language-server;
          };

          devShells.default = pkgs.mkShell {
            packages = [
              pkgs.nodejs
              pkgs.pnpm
              pkgs.typescript
              pkgs.typescript-language-server
            ];
          };
        };
    };
}
