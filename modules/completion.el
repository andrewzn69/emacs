;;; completion.el --- Completion popup at point -*- lexical-binding: t; -*-

;; defaults, local.el can override them
;; characters typed before the popup opens on its own
(defvar my/completion-prefix 2)
(defvar my/completion-delay 0.25)
;; buffers longer than this are left out of the word scan
(defvar my/completion-scan-limit (* 1024 1024))

;; space separated pieces match in any order, so nix mod finds nix-mode
(use-package orderless
	:custom
	(completion-styles '(orderless basic))
	;; file names keep the built in style, partial completion expands a path segment at a time
	(completion-category-overrides '((file (styles partial-completion)))))

;; the popup itself
(use-package corfu
	:custom
	;; opens while typing instead of waiting for a key
	(corfu-auto t)
	(corfu-auto-prefix my/completion-prefix)
	(corfu-auto-delay my/completion-delay)
	;; nothing is chosen until a candidate is moved to, so return inserts what was typed
	(corfu-preselect 'prompt)
	;; moving past either end wraps around
	(corfu-cycle t)
	;; the popup closes as soon as nothing matches rather than sitting empty
	(corfu-quit-no-match t)
	:config
	(global-corfu-mode 1)
	;; docs for the candidate under the cursor in a second popup
	(corfu-popupinfo-mode 1)
	:general-config
	;; evil takes C-n and C-p in insert state for its own completion
	(:keymaps 'corfu-map
	 "TAB" #'corfu-next
	 "S-TAB" #'corfu-previous
	 "C-n" #'corfu-next
	 "C-p" #'corfu-previous
	 "C-e" #'corfu-quit
	 "C-d" #'corfu-popupinfo-scroll-down
	 "C-f" #'corfu-popupinfo-scroll-up)
	;; asks for candidates without waiting for the prefix count
	(:states '(insert emacs)
	 "S-SPC" #'completion-at-point
	 "C-\\" #'completion-at-point))

;; kind icons down the left of the popup, the same nerd font the rest of the ui uses
(use-package nerd-icons-corfu
	:after corfu
	:config
	(add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

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

(defun my/completion-add-elisp ()
	(add-hook 'completion-at-point-functions #'cape-elisp-symbol nil t))

;; sources the language servers do not cover
(use-package cape
	:custom
	(cape-dabbrev-buffer-function #'my/completion-scan-buffers)
	:init
	;; added per buffer instead of everywhere, so a source is only live where it can help
	(add-hook 'prog-mode-hook #'my/completion-add-file)
	(dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook))
		(add-hook hook #'my/completion-add-dabbrev))
	(add-hook 'emacs-lisp-mode-hook #'my/completion-add-elisp)
	;; the popup drops a query the moment another key lands, wasting whatever the server did
	(advice-add 'lsp-completion-at-point :around #'cape-wrap-noninterruptible))
