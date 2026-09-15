;;; evil.el --- Vim keys -*- lexical-binding: t; -*-

(use-package evil
	:init
	;; keys for other modes come from evil collection instead
	(setq evil-want-keybinding nil)
	:custom
	;; C-u scrolls up, Y yanks to end of line
	(evil-want-C-u-scroll t)
	(evil-want-Y-yank-to-eol t)
	;; C-r redo through the built in undo redo
	(evil-undo-system 'undo-redo)
	:config
	(evil-mode 1)
	:general-config
	;; window keys from C-w under the leader too
	(my/leader
	 "w" (cons "window" evil-window-map)))

(use-package evil-collection
	:after evil
	:config
	(evil-collection-init))
