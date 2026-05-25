{
  lib,
  stdenvNoCC,
  makeWrapper,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
  pnpm,
}:

let
  original = lib.importJSON ./package.json;
  inherit (original) version description;
  pname = original.name;
in

stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname version;

  src = lib.cleanSource ./.;

  nativeBuildInputs = [
    nodejs
    pnpm
    pnpmConfigHook
    makeWrapper
  ];

  prePnpmInstall = "";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      prePnpmInstall
      ;
    pnpm = pnpm;
    fetcherVersion = 3;
    hash = "sha256-vGSr+nLtV189QVoe1cKZoX+sUhTlqOe+EgurnXHCILY=";
  };

  buildPhase = ''
    runHook preBuild
    pnpm run build
    runHook postBuild
  '';

  postBuild = ''
    pnpm prune --prod
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/lib/${pname}

    cp -r out $out/lib/${pname}/
    cp -r node_modules $out/lib/${pname}/

    makeWrapper ${nodejs}/bin/node \
      $out/bin/unocss-language-server \
      --set NODE_PATH $out/lib/${pname}/node_modules \
      --add-flags $out/lib/${pname}/out/server.js

    runHook postInstall
  '';

  meta = {
    inherit description;
    mainProgram = pname;
    license = lib.licenses.mit;
    homepage = "https://github.com/xna00/unocss-language-server";
  };
})
