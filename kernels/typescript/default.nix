{
  self,
  pkgs,
  nodeenv ? pkgs.python3Packages.nodeenv,
  globalBuildInputs ? [],
}: let
  inherit (pkgs) fetchurl lib stdenv writeScriptBin;
  inherit (lib) makeBinPath attrValues;

  sources = {
    "@rollup/plugin-commonjs-13.0.2" = {
      name = "_at_rollup_slash_plugin-commonjs";
      packageName = "@rollup/plugin-commonjs";
      version = "13.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/@rollup/plugin-commonjs/-/plugin-commonjs-13.0.2.tgz";
        sha512 = "0dmxzcc586xiryw3kgnpxa5mrbzsqxfdi5f76v39p7p2c58a1bxl";
      };
    };
    "@rollup/plugin-node-resolve-11.2.1" = {
      name = "_at_rollup_slash_plugin-node-resolve";
      packageName = "@rollup/plugin-node-resolve";
      version = "11.2.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/@rollup/plugin-node-resolve/-/plugin-node-resolve-11.2.1.tgz";
        sha512 = "1m1g40v4rs9z4wax1ls0hfhg90zhabb4kwbvfi8zgibmrnizkygx";
      };
    };
    "@rollup/plugin-replace-2.3.4" = {
      name = "_at_rollup_slash_plugin-replace";
      packageName = "@rollup/plugin-replace";
      version = "2.3.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/@rollup/plugin-replace/-/plugin-replace-2.3.4.tgz";
        sha512 = "1bip192qplw5jj3lqkl4pbrz1s93ny5im3x8s275jk8a8g02156j";
      };
    };
    "@tslab/typescript-for-tslab-4.1.2" = {
      name = "_at_tslab_slash_typescript-for-tslab";
      packageName = "@tslab/typescript-for-tslab";
      version = "4.1.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/@tslab/typescript-for-tslab/-/typescript-for-tslab-4.1.2.tgz";
        sha512 = "08z8i17rkk6n6dcnbzbk4z55pyykhzpsrac05ym33cpygq5m7kfw";
      };
    };
    "@types/node-14.14.13" = {
      name = "_at_types_slash_node";
      packageName = "@types/node";
      version = "14.14.13";
      src = fetchurl {
        url = "https://registry.npmjs.org/@types/node/-/node-14.14.13.tgz";
        sha512 = "0f39qlh11ldzdbyp05vfjh11hql6xw7brqkb8f9z91ivcdd3ryjv";
      };
    };
    "commander-6.2.1" = {
      name = "commander";
      packageName = "commander";
      version = "6.2.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/commander/-/commander-6.2.1.tgz";
        sha512 = "0fmi1l136sj7vh4vrhdl7nagalwp381xqfmnk3f44wc9blc2y7z2";
      };
    };
    "rollup-2.34.2" = {
      name = "rollup";
      packageName = "rollup";
      version = "2.34.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/rollup/-/rollup-2.34.2.tgz";
        sha512 = "01kdaj4iz8j16rpp0pwviw17pwdsx5ia95by0wv7w4kqbafc6083";
      };
    };
    "semver-7.3.4" = {
      name = "semver";
      packageName = "semver";
      version = "7.3.4";
      src = fetchurl {
        url = "https://registry.npmjs.org/semver/-/semver-7.3.4.tgz";
        sha512 = "1jzj2cila9n3fr0kr35idxlb4fhpkjdjwc6h80m4xydn064x77na";
      };
    };
    "zeromq-6.0.0-beta.6" = {
      name = "zeromq";
      packageName = "zeromq";
      version = "6.0.0-beta.6";
      src = fetchurl {
        url = "https://registry.npmjs.org/zeromq/-/zeromq-6.0.0-beta.6.tgz";
        sha512 = "01b1c4ndq2330x2w30z8xarirw97zl405dmxfs8c8hpgi234zwi2";
      };
    };
  };

  tslab = nodeenv.buildNodePackage {
    name = "tslab";
    packageName = "tslab";
    version = "1.0.15";
    src = fetchurl {
      url = "https://registry.npmjs.org/tslab/-/tslab-1.0.15.tgz";
      sha512 = "096zw1jg8z6gxs9ppy4k19q3dx33yz64jdcyrcl5rq2il4jdvi9p";
    };
    dependencies = attrValues sources;
    buildInputs = globalBuildInputs;
    meta = {
      description = "tslab is an interactive programming environment and REPL with Jupyter for JavaScript and TypeScript users.";
      homepage = "https://github.com/yunabe/tslab";
      license = "Apache-2";
    };
    production = true;
    bypassCache = true;
    reconstructLock = true;
  };

  tslabSh = writeScriptBin "tslab" ''
    #! ${stdenv.shell}
    export PATH="${makeBinPath [tslab]}:$PATH"
    ${tslab}/bin/tslab "$@"
  '';
in
  {
    name ? "typescript",
    displayName ? "Typescript", # TODO: add version
    language ? "typescript",
    argv ? null,
    codemirrorMode ? "typescript",
    logo64 ? ./logo64.png,
    runtimePackages ? [],
    extraRuntimePackages ? [],
  }: let
    allRuntimePackages = runtimePackages ++ extraRuntimePackages;

    env = tslabSh;
    wrappedEnv =
      pkgs.runCommand "wrapper-${env.name}"
      {nativeBuildInputs = [pkgs.makeWrapper];}
      ''
        mkdir -p $out/bin
        for i in ${env}/bin/*; do
          filename=$(basename $i)
          ln -s ${env}/bin/$filename $out/bin/$filename
          wrapProgram $out/bin/$filename \
            --set PATH "${pkgs.lib.makeSearchPath "bin" allRuntimePackages}"
        done
      '';

    argv_ =
      if argv == null
      then [
        "${wrappedEnv}/bin/tslab"
        "kernel"
        "--config-path"
        "{connection_file}"
      ]
      else argv;
  in {
    argv = argv_;
    inherit
      name
      displayName
      language
      codemirrorMode
      logo64
      ;
  }
