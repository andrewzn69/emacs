;;; config.el --- Remote files -*- lexical-binding: t; -*-

(use-package tramp
  :straight nil
  :defer t
  :config
  ;; nixos hosts keep programs outside the standard dirs, the login shell path has them
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path))
