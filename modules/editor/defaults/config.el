;;; config.el --- General editing behaviour -*- lexical-binding: t; -*-

;; default, local.el can override it
(defvar my/tab-width 2)

;; reopening a file puts the cursor back where it was, positions saved in the state dir
(save-place-mode 1)

(setq-default tab-width my/tab-width)

;; plain yank prefers the kill ring when the clipboard has not changed
(keymap-global-set "C-S-v" #'clipboard-yank)

;; long lines run past the window edge instead of wrapping onto the next row
(defun my/truncate-lines ()
	(setq truncate-lines t))

;; code, text and conf buffers only, the global version would also hit dashboard, magit and pdfs
(dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook))
	(add-hook hook #'my/truncate-lines))
