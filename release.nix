{ nixpkgs ? (import ./nixpkgs.nix), ... }:
let
  pkgs = import nixpkgs { config = {}; };
  tmux-copy-mode-kakoune = pkgs.callPackage ./derivation.nix {};
in {
  test = pkgs.runCommandNoCC "tmux-copy-mode-kakoune-test" {} ''
    mkdir -p $out
    : ${tmux-copy-mode-kakoune}
  '';
}