;;; config.el --- Checker results in the buffer -*- lexical-binding: t; -*-

;; each level draws its own glyph, the standard levels share a single string
(defun my/flycheck-margin-icons ()
	(dolist (level '(error warning info))
		(put level 'flycheck-margin-spec
				 (flycheck-make-margin-spec (alist-get level my/icons-diagnostics)
																		(get level 'flycheck-fringe-face)))))

;; the glyphs draw two columns wide and flycheck only widens the margin by one
(defun my/flycheck-margin-width ()
	(setq left-margin-width (if flycheck-mode 2 0))
	(dolist (win (get-buffer-window-list))
		(set-window-margins win left-margin-width right-margin-width)))

(use-package flycheck
	;; lsp turns it on in buffers with a server, nothing else starts it
	:defer t
	:custom
	;; the fringe takes bitmaps only, the margin takes text so a glyph can be drawn there
	(flycheck-indication-mode 'left-margin)
	:hook (flycheck-mode . my/flycheck-margin-width)
	:config
	(my/flycheck-margin-icons)
	:general
	(my/leader
		"T" (cons "diagnostics" (make-sparse-keymap))
		"T T" #'flycheck-list-errors))
