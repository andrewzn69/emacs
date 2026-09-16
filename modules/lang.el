;;; lang.el --- Language servers and major modes -*- lexical-binding: t; -*-

;; defaults, local.el can override them
;; modes a server is started for, each one needs its server on PATH
(defvar my/lsp-modes
	'(sh-mode c-mode c++-mode css-mode html-mode js-mode js-json-mode lua-mode
						python-mode csharp-mode latex-mode nix-mode yaml-mode terraform-mode
						dockerfile-mode typescript-mode markdown-mode go-mode rust-mode
						elixir-mode php-mode))

;; major modes emacs ships none for, the rest of the list is built in
(use-package nix-mode :defer t)
(use-package yaml-mode :defer t)
(use-package terraform-mode :defer t)
(use-package dockerfile-mode :defer t)
(use-package typescript-mode :defer t)
(use-package markdown-mode :defer t)
(use-package go-mode :defer t)
(use-package rust-mode :defer t)
(use-package elixir-mode :defer t)
(use-package php-mode :defer t)
;; highlighting only, no server ships for these templates
(use-package jinja2-mode :defer t)

;; stops the server for the buffer or starts one again
(defun my/lsp-toggle ()
	(interactive)
	(if (bound-and-true-p lsp-mode)
			(lsp-disconnect)
		(lsp-deferred)))

(use-package lsp-mode
	:init
	;; every lsp key goes through the leader, the built in prefix stays free
	(setq lsp-keymap-prefix nil)
	;; servers answer with far more at once than the default read size takes
	(setq read-process-output-max (* 1024 1024))
	:custom
	;; the built in checker, the modeline already carries a segment for it
	(lsp-diagnostics-provider :flymake)
	;; the popup reads the completion function directly, lsp wiring up its own would fight it
	(lsp-completion-provider :none)
	;; the sideline and the checker already show what these would repeat
	(lsp-modeline-diagnostics-enable nil)
	(lsp-modeline-code-actions-enable nil)
	;; the symbol path across the top of the window
	(lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
	;; how long typing has to stop before highlights and lenses refresh
	(lsp-idle-delay 0.5)
	;; the key popup lists the lsp keys under their prefix
	:hook (lsp-mode . lsp-enable-which-key-integration)
	:config
	;; only where a server is attached, K stays the manual lookup everywhere else
	(general-define-key
	 :states '(normal visual)
	 :keymaps 'lsp-mode-map
	 "K" #'lsp-ui-doc-glance
	 "g i" #'lsp-find-implementation
	 "g I" #'lsp-ui-peek-find-implementation)
	:general-config
	(my/leader
		"l" (cons "lsp" (make-sparse-keymap))
		"l D" #'lsp-find-definition
		"l d" #'lsp-find-declaration
		"l o" #'lsp-ui-imenu
		"l I" #'lsp-describe-session
		"l s" #'lsp-signature-activate
		"l E" #'eldoc-box-help-at-point
		"l t" #'my/lsp-toggle
		"l l" #'lsp-ui-sideline-mode
		"r" (cons "refactor" (make-sparse-keymap))
		"r a" #'lsp-execute-code-action
		"r r" #'lsp-rename
		"T" (cons "diagnostics" (make-sparse-keymap))
		"T t" #'flymake-show-project-diagnostics
		"T T" #'flymake-show-buffer-diagnostics
		"/" (cons "search" (make-sparse-keymap))
		"/ l" (cons "lsp" (make-sparse-keymap))
		"/ l r" #'lsp-ui-peek-find-references))

;; the problem under the cursor in a floating window, the checker feeds its text to eldoc
(use-package eldoc-box
	:defer t
	:custom
	(eldoc-box-clear-with-C-g t))

;; python goes through its own client, the bundled ones start a different server
(use-package lsp-pyright
	:after lsp-mode
	:demand t)

;; the server starts once the buffer is shown instead of while a file is being read
(dolist (mode my/lsp-modes)
	(add-hook (intern (format "%s-hook" mode)) #'lsp-deferred))

;; diagnostics beside the line and docs in a popup
(use-package lsp-ui
	:after lsp-mode
	:custom
	;; the line at point carries its own diagnostics and actions to the right
	(lsp-ui-sideline-show-diagnostics t)
	(lsp-ui-sideline-show-code-actions t)
	;; hover text belongs in the popup, the sideline row stays short
	(lsp-ui-sideline-show-hover nil)
	;; the popup opens on the key rather than following the cursor
	(lsp-ui-doc-show-with-cursor nil)
	(lsp-ui-doc-position 'at-point)
	:hook (lsp-mode . lsp-ui-mode))
