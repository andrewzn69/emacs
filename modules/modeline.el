;;; modeline.el --- Mode line -*- lexical-binding: t; -*-

;; full state names instead of the short tags, evil declares them with defvar so values set before it loads stay
(setq evil-normal-state-tag " NORMAL "
      evil-insert-state-tag " INSERT "
      evil-visual-char-tag " VISUAL "
      evil-visual-line-tag " V-LINE "
      evil-visual-screen-line-tag " V-LINE "
      evil-visual-block-tag " V-BLOCK "
      evil-replace-state-tag " REPLACE "
      evil-operator-state-tag " O-PENDING "
      evil-motion-state-tag " MOTION "
      evil-emacs-state-tag " EMACS ")

(use-package doom-modeline
	:custom
	(doom-modeline-bar-width 3)
	;; state name text instead of an icon
	(doom-modeline-modal-icon nil)
	;; error and warning counts only
	(doom-modeline-check 'simple)
	;; path starts at the project folder
	(doom-modeline-buffer-file-name-style 'relative-from-project)
	;; encoding only when it isnt utf 8 with the os line endings
	(doom-modeline-buffer-encoding 'nondefault)
	(doom-modeline-default-eol-type (if my/windows-p 1 0))
	;; minor mode lighters are hidden
	(projectile-dynamic-mode-line nil)
	:config
	;; column and file size next to the line number
	(column-number-mode 1)
	(size-indication-mode 1)
	(doom-modeline-mode 1))

;; match count while searching, drawn by the mode line
(use-package anzu
	:config
	(global-anzu-mode 1))
