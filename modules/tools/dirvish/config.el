;;; config.el --- File manager -*- lexical-binding: t; -*-

(use-package nerd-icons)

;; every dired buffer opens as dirvish
(use-package dirvish
	:init
	(dirvish-override-dired-mode)
	:custom
	(dirvish-attributes '(nerd-icons file-time file-size))
	:config
	;; evil collection binds dired keys in normal state only, so emacs state leaves dired its own keys
	(with-eval-after-load 'evil
		(evil-set-initial-state 'dired-mode 'emacs)))
