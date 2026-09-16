pkgs:

# the patch touches the cairo font backend, the darwin build draws with its own
if pkgs.stdenv.hostPlatform.isDarwin then
  pkgs.emacs
else
  pkgs.emacs-pgtk.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./emacs-font-size-scale.patch ];
  })
