;;; config.el --- Line numbers in the margin -*- lexical-binding: t; -*-

;; default, local.el can override it
;; relative or visual also work
(defvar my/line-numbers-type t)

(setq display-line-numbers-type my/line-numbers-type)
;; width counted from the buffer lines up front so text doesnt shift when a longer number scrolls into view
(setq display-line-numbers-width-start t)

;; code, text and conf buffers only, the global version would also hit dashboard, magit and pdfs
(dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook))
	(add-hook hook #'display-line-numbers-mode))
