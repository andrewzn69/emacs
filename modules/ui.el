;;; ui.el --- Theme and font -*- lexical-binding: t; -*-

;; defaults
(defvar my/theme 'gruvbox-dark-hard)
(defvar my/font-family "JetBrainsMono Nerd Font")
(defvar my/font-height 140)

;; autothemer json export cmds call json encode without loading json
(with-eval-after-load 'autothemer
  (require 'json))

(use-package gruvbox-theme
	:config
	(load-theme my/theme t))

;; font only on gui frames and only if installed
(defun my/apply-font (&optional frame)
	(with-selected-frame (or frame (selected-frame))
		(when (and (display-graphic-p)
			         (find-font (font-spec :family my/font-family)))
			(set-face-attribute 'default nil :family my/font-family :height my/font-height))))

;; apply now and again for every new frame the daemon opens
(my/apply-font)
(add-hook 'after-make-frame-functions #'my/apply-font)

;; icons use the same nerd font once any module loads nerd icons
(with-eval-after-load 'nerd-icons
	(setq nerd-icons-font-family my/font-family))
