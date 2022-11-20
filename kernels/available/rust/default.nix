{
  self,
  system,
  # custom arguments
  pkgs ?
    import self.inputs.nixpkgs {
      inherit system;
      overlays = [rust-overlay];
    },
  rust-overlay ? self.inputs.rust-overlay.overlays.default,
  name ? "rust",
  displayName ? "Rust",
  runtimePackages ? with pkgs; [cargo gcc binutils-unwrapped],
  extraRuntimePackages ? [],
  evcxr ? pkgs.evcxr,
}: let
  /*
  rust-overlay recommends using `default` over `rust`.
  Pre-aggregated package `rust` is not encouraged for stable channel since it
  contains almost all and uncertain components.
  https://github.com/oxalica/rust-overlay/blob/1558464ab660ddcb45a4a4a691f0004fdb06a5ee/rust-overlay.nix#L331
  */
  rust = pkgs.rust-bin.stable.latest.default.override {
    extensions = ["rust-src"];
  };

  allRuntimePackages = runtimePackages ++ extraRuntimePackages ++ [rust];

  env = evcxr;
  wrappedEnv =
    pkgs.runCommand "wrapper-${env.name}"
    {nativeBuildInputs = [pkgs.makeWrapper];}
    ''
      mkdir -p $out/bin
      for i in ${env}/bin/*; do
        filename=$(basename $i)
        ln -s ${env}/bin/$filename $out/bin/$filename
        wrapProgram $out/bin/$filename \
          --set PATH "${pkgs.lib.makeSearchPath "bin" allRuntimePackages}" \
          --set RUST_SRC_PATH "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}"
      done
    '';
in {
  inherit name displayName;
  language = "rust";
  argv = [
    "${wrappedEnv}/bin/evcxr_jupyter"
    "--control_file"
    "{connection_file}"
  ];
  codemirrorMode = "rust";
  logo64 = ./logo64.png;
  logo32 = ./logo32.png;
}
