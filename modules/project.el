;;; project.el --- Project switching -*- lexical-binding: t; -*-

;; opening a file inside a project adds it to the switch list, list saved in the state dir
(use-package projectile
  :config
  (projectile-mode 1)
  :general-config
  ;; leader twice finds a file in the current project
  (my/leader
    "SPC" #'projectile-find-file
    "p" (cons "project" (make-sparse-keymap))
    "p b" #'projectile-switch-to-buffer
    "p f" #'projectile-find-file
    "p k" #'projectile-kill-buffers
    "p p" #'projectile-switch-project))
