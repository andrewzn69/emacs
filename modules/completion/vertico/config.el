;;; config.el --- Minibuffer completion list -*- lexical-binding: t; -*-

;; the prompt at the bottom lists what matches instead of hiding it behind a key
(use-package vertico
	:config
	(vertico-mode 1))

;; file and buffer glyphs beside the entries, the same nerd font the rest of the ui uses
(use-package nerd-icons-completion
	:after vertico
	:config
	(nerd-icons-completion-mode 1))
