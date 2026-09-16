;;; ui.el --- Theme and font -*- lexical-binding: t; -*-

;; defaults
(defvar my/theme 'crimson)
(defvar my/font-family "JetBrainsMono Nerd Font")
;; size in points, the terminal is set to the same number
(defvar my/font-point-size 11.0)
(defvar my/font-weight "regular")

;; themes shipped in this repo
(add-to-list 'custom-theme-load-path (expand-file-name "themes" my/config-directory))
(load-theme my/theme t)

;; font only on gui frames and only if installed
(defun my/apply-font (&optional frame)
	(with-selected-frame (or frame (selected-frame))
		(when (and (display-graphic-p)
			         (find-font (font-spec :family my/font-family)))
			;; points land between pixels, 96 dpi is what the display stack converts at
			(let* ((exact (* my/font-point-size (/ 96.0 72.0)))
						 (rounded (round exact)))
				;; glyphs drawn at the unrounded size instead of the whole pixel emacs rounds to
				(setq ftcr-font-size-scale (/ exact rounded))
				;; leading off so the line box is rounded once instead of ascent and descent apart
				(set-face-attribute 'default nil :font
														(format "%s:pixelsize=%d:weight=%s:minspace=false"
																		my/font-family rounded my/font-weight))))))

;; apply now and again for every new frame the daemon opens
(my/apply-font)
(add-hook 'after-make-frame-functions #'my/apply-font)

;; icons use the same nerd font once any module loads nerd icons
(with-eval-after-load 'nerd-icons
	(setq nerd-icons-font-family my/font-family))
