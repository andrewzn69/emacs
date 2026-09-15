;;; git.el --- Git client -*- lexical-binding: t; -*-

(use-package magit
  ;; loads on the first magit command, C-x g or leader g g opens the status buffer
  :defer t
  :general
  (my/leader
    "g" (cons "git" (make-sparse-keymap))
    "g g" #'magit-status))
