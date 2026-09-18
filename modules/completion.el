;;; completion.el --- Completion sources and matching -*- lexical-binding: t; -*-

;; defaults, local.el can override them
;; buffers longer than this are left out of the word scan
(defvar my/completion-scan-limit (* 1024 1024))

;; space separated pieces match in any order, so nix mod finds nix-mode
(use-package orderless
	:custom
	(completion-styles '(orderless basic))
	;; file names keep the built in style, partial completion expands a path segment at a time
	(completion-category-overrides '((file (styles partial-completion)))))

;; same mode buffers short enough to read without holding up a keystroke
(defun my/completion-scan-buffers ()
	(let ((mode major-mode) (this (current-buffer)))
		(cons this
					(seq-filter (lambda (buf)
												(and (not (eq buf this))
														 (eq mode (buffer-local-value 'major-mode buf))
														 (< (buffer-size buf) my/completion-scan-limit)))
											(buffer-list)))))

(defun my/completion-add-file ()
	(add-hook 'completion-at-point-functions #'cape-file -10 t))

;; last of the sources, so it only answers where nothing better did
(defun my/completion-add-dabbrev ()
	(add-hook 'completion-at-point-functions #'cape-dabbrev 20 t))

;; sources the language servers do not cover
(use-package cape
	:custom
	(cape-dabbrev-buffer-function #'my/completion-scan-buffers)
	:init
	;; added per buffer instead of everywhere, so a source is only live where it can help
	(add-hook 'prog-mode-hook #'my/completion-add-file)
	(dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook))
		(add-hook hook #'my/completion-add-dabbrev))
	;; the popup drops a query the moment another key lands, wasting whatever the server did
	(advice-add 'lsp-completion-at-point :around #'cape-wrap-noninterruptible))
