{ nixpkgs ? (import ./nixpkgs.nix), ... }:
let
  pkgs = import nixpkgs {
    config = {};
    overlays = [
      (import ./overlay.nix)
    ];
  };
in {
  test = pkgs.runCommandNoCC "tmux-copy-mode-kakoune-test" {} ''
    mkdir -p $out
    : ${pkgs.tmux-copy-mode-kakoune}
  '';
}
