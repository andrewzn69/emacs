# epdfinfo from the nixpkgs pdf tools build, linked into bin so pdf tools finds it on PATH
pkgs:
let
  # built against the same emacs as nix/emacs.nix so no second emacs gets downloaded
  pdf-tools = (pkgs.emacsPackagesFor (import ./emacs.nix pkgs)).pdf-tools;
in
pkgs.runCommand "epdfinfo" { } ''
  mkdir -p $out/bin
	ln -s ${pdf-tools}/share/emacs/site-lisp/elpa/pdf-tools-${pdf-tools.version}/epdfinfo $out/bin/epdfinfo
''
