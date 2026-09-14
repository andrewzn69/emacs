;;; project.el --- Project switching -*- lexical-binding: t; -*-

;; opening a file inside a project adds it to the switch list, list saved in the state dir
(use-package projectile
  :config
  (projectile-mode 1))
