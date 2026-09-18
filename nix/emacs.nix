pkgs:

let
  # the patch touches the cairo font backend, the darwin build draws with its own
  base =
    if pkgs.stdenv.hostPlatform.isDarwin then
      pkgs.emacs
    else
      pkgs.emacs-pgtk.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [ ./emacs-font-size-scale.patch ];
      });
in
# the wrapper aims the grammar search path at the store so none are built on first open
(pkgs.emacsPackagesFor base).emacsWithPackages (epkgs: [
  epkgs.treesit-grammars.with-all-grammars
])
