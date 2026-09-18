;;; config.el --- Theme -*- lexical-binding: t; -*-

;; defaults
(defvar my/theme 'crimson)

;; themes shipped in this repo
(add-to-list 'custom-theme-load-path (expand-file-name "themes" my/config-directory))
(load-theme my/theme t)
