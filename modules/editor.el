;;; editor.el --- General editing behaviour -*- lexical-binding: t; -*-

;; defaults, local.el can override them
;; relative so line motion counts read off the gutter, t or visual also work
(defvar my/line-numbers-type 'relative)
(defvar my/tab-width 2)

;; reopening a file puts the cursor back where it was, positions saved in the state dir
(save-place-mode 1)

(setq display-line-numbers-type my/line-numbers-type)
;; width counted from the buffer lines up front so text doesnt shift when a longer number scrolls into view
(setq display-line-numbers-width-start t)

(setq-default tab-width my/tab-width)

;; long lines run past the window edge instead of wrapping onto the next row
(defun my/truncate-lines ()
	(setq truncate-lines t))

;; indent guides, the theme sets both colors
(defface my/indent-bar
	'((t :inherit shadow))
	"Face for the indent guides.")

(defface my/indent-bar-current
	'((t :inherit shadow))
	"Face for the indent guide at the current depth.")

;; code and config files, indentation carries no structure in prose
(use-package indent-bars
	:custom
	;; the same vertical character the editor guides use, a drawn bar needs stipple support the build may lack
	(indent-bars-prefer-character t)
	(indent-bars-color '(my/indent-bar))
	;; one color for every level instead of a color per depth
	(indent-bars-color-by-depth nil)
	;; a bar every tab stop, the guess reads a per mode offset that is four in most modes
	(indent-bars-spacing-override my/tab-width)
	(indent-bars-highlight-current-depth '(:face my/indent-bar-current))
	:hook ((prog-mode . indent-bars-mode)
				 (conf-mode . indent-bars-mode)))

;; code, text and conf buffers only, global versions would also hit dashboard, magit and pdfs
(dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook))
	(add-hook hook #'display-line-numbers-mode)
	(add-hook hook #'my/truncate-lines))
