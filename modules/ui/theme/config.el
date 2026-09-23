;;; config.el --- Theme -*- lexical-binding: t; -*-

;; defaults
(defvar my/theme 'crimson)

;; themes shipped in this repo
(add-to-list 'custom-theme-load-path (expand-file-name "themes" my/config-directory))

;; cloned only where it is picked, the recipe carries the source because it is not on melpa
(when (string-prefix-p "everforest" (symbol-name my/theme))
	(straight-use-package '(everforest :type git :host github :repo "theorytoe/everforest-emacs"))
	;; straight builds outside the theme search path
	(let ((file (locate-library "everforest-hard-dark-theme")))
		(when file
			(add-to-list 'custom-theme-load-path (file-name-directory file)))))

(load-theme my/theme t)
