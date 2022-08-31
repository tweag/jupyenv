{
  pkgs,
  nodejs ? pkgs."nodejs-14_x",
}: final: prev: {
  tslab = prev.tslab.override (oldAttrs: {
    preRebuild = ''
      export NPM_CONFIG_ZMQ_EXTERNAL=true
    '';
    buildInputs = oldAttrs.buildInputs ++ [final.node-gyp-build pkgs.zeromq];
  });
}
