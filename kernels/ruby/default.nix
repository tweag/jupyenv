{
  self,
  pkgs,
  iruby ? pkgs.iruby,
  extraRubyPackages ? [],
}: let
  #  env = iruby.overrideAttrs (final: prev: {
  #    exes = prev.exes ++ extraRubyPackages;
  #  });
in
  {
    name ? "ruby",
    displayName ? "Ruby", # TODO: add version
    language ? "ruby",
    argv ? [
      "${iruby}/bin/iruby"
      "kernel"
      "{connection_file}"
    ],
    codemirrorMode ? "ruby",
    logo64 ? ./logo64.png,
  }: {
    inherit
      name
      displayName
      language
      argv
      codemirrorMode
      logo64
      ;
  }
