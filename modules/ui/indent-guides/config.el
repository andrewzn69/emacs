;;; config.el --- Indent guides -*- lexical-binding: t; -*-

;; the theme sets both colors
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
