;;; config.el --- File manager -*- lexical-binding: t; -*-

(use-package nerd-icons)

;; quitting the last window of a file opens its dir instead of closing emacs
;; a buffer from emacsclient still finishes so its caller stops waiting
(defun my/dirvish-quit-to-dir (quit &optional force)
	(if (and (one-window-p)
					 buffer-file-name
					 (not (bound-and-true-p server-buffer-clients)))
			(let ((file buffer-file-name))
				;; the bang drops unsaved changes instead of asking
				(when force
					(set-buffer-modified-p nil))
				(when (kill-buffer)
					(dired-jump nil file)))
		(funcall quit force)))

;; every dired buffer opens as dirvish
(use-package dirvish
	:init
	(dirvish-override-dired-mode)
	:custom
	(dirvish-attributes '(nerd-icons file-time file-size))
	:config
	;; evil collection binds dired keys in normal state only, so emacs state leaves dired its own keys
	(with-eval-after-load 'evil
		(evil-set-initial-state 'dired-mode 'emacs)
		(advice-add 'evil-quit :around #'my/dirvish-quit-to-dir)))
