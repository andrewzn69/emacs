;;; modeline.el --- Mode line -*- lexical-binding: t; -*-

(use-package doom-modeline
	:custom
	(doom-modeline-bar-width 3)
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
