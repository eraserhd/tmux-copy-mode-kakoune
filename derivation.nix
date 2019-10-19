{ stdenv, fetchFromGitHub, ... }:

stdenv.mkDerivation rec {
  pname = "tmux-copy-mode-kakoune";
  version = "0.1.0";

  src = ./.;

  meta = with stdenv.lib; {
    description = "TODO: fill me in";
    homepage = https://github.com/eraserhd/tmux-copy-mode-kakoune;
    license = licenses.publicDomain;
    platforms = platforms.all;
    maintainers = [ maintainers.eraserhd ];
  };
}
