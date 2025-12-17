{
  description = "unocss-language-server";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (
    system: let
      pkgs = nixpkgs.legacyPackages.${system};
      pname = "unocss-language-server";
      version = "0.1.8";
      nodejs = pkgs.nodejs_22;
      pnpm = pkgs.pnpm_9;
    in {
      packages.default = pkgs.stdenv.mkDerivation (final: {
        inherit pname version;
        src = self;
        nativeBuildInputs = [ nodejs pnpm.configHook pkgs.makeWrapper ];
        prePnpmInstall = "";
        pnpmDeps = pnpm.fetchDeps {
          inherit (final) pname version src prePnpmInstall;
          fetcherVersion = 2;
          hash = "sha256-kg8JQvxpVMQ7gudtND/3xWIzEljQAGxC336eGrEJ+w0=";
        };
        buildPhase = ''
          runHook preBuild
          pnpm run build
          runHook postBuild
        '';
        installPhase = ''
          runHook preInstall
          mkdir -p $out/bin
          mkdir -p $out/lib/${pname}
          cp -r out $out/lib/${pname}/
          cp -r bin $out/lib/${pname}/
          cp -r node_modules $out/lib/${pname}/
          makeWrapper ${nodejs}/bin/node \
            $out/bin/unocss-language-server \
            --set NODE_PATH $out/lib/${pname}/node_modules \
            --add-flags $out/lib/${pname}/bin/index.js
          runHook postInstall
        '';
        meta = {
          description = "UnoCSS Language Server";
          license = pkgs.lib.licenses.mit;
          mainProgram = "unocss-language-server";
        };
      });
    }
  );
}
