;;; editor.el --- General editing behaviour -*- lexical-binding: t; -*-

;; defaults, local.el can override them
;; relative so line motion counts read off the gutter, t or visual also work
(defvar my/line-numbers-type 'relative)

;; reopening a file puts the cursor back where it was, positions saved in the state dir
(save-place-mode 1)

(setq display-line-numbers-type my/line-numbers-type)
;; width counted from the buffer lines up front so text doesnt shift when a longer number scrolls into view
(setq display-line-numbers-width-start t)

;; long lines run past the window edge instead of wrapping onto the next row
(defun my/truncate-lines ()
	(setq truncate-lines t))

;; code, text and conf buffers only, global versions would also hit dashboard, magit and pdfs
(dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook))
	(add-hook hook #'display-line-numbers-mode)
	(add-hook hook #'my/truncate-lines)
	(add-hook hook #'hl-line-mode))
