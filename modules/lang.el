;;; lang.el --- Language servers and major modes -*- lexical-binding: t; -*-

;; defaults, local.el can override them
;; modes a server is started for, each one needs its server on PATH
(defvar my/lsp-modes
	'(sh-mode c-mode c++-mode css-mode html-mode js-mode js-json-mode lua-mode
						json-mode python-mode csharp-mode latex-mode nix-mode yaml-mode terraform-mode
						dockerfile-mode typescript-mode markdown-mode go-mode rust-mode
						elixir-mode php-mode))

;; major modes emacs ships none for, the rest of the list is built in
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

;; the fringe takes bitmaps only, the margin takes text so a glyph can be drawn there
(use-package flymake
	:straight nil
	:defer t
	:custom
	(flymake-indicator-type 'margins)
	;; copied onto the severity symbols when the checker loads, so setting it later does nothing
	(flymake-margin-indicators-string
	 ;; the glyphs draw two columns wide, so each carries a blank to keep the margin from clipping
	 `((error ,(concat (alist-get 'error my/icons-diagnostics) " ") compilation-error)
	   (warning ,(concat (alist-get 'warning my/icons-diagnostics) " ") compilation-warning)
	   ;; the protocol has four levels and the checker has three, so hints arrive as notes
	   (note ,(concat (alist-get 'info my/icons-diagnostics) " ") compilation-info))))

;; the checker messages for the line in a floating window, eldoc shows one source at a time and the server takes it
(defun my/diagnostic-box ()
	(interactive)
	(require 'eldoc-box)
	(if-let* ((diags (flymake-diagnostics (line-beginning-position)
																				(line-end-position))))
			(progn
				;; beside the cursor instead of the frame corner the hover popup uses
				(let ((eldoc-box-position-function eldoc-box-at-point-position-function))
					(eldoc-box--display (mapconcat #'flymake-diagnostic-text diags "\n\n")))
				;; polls until the cursor leaves the spot it opened at, then closes itself
				(setq eldoc-box--help-at-point-last-point (point))
				(run-with-timer 0.1 nil #'eldoc-box--help-at-point-cleanup))
		(message "no problem on this line")))

;; servers answer nothing for keywords and a key that does nothing reads as broken
(defun my/lsp-hover ()
	(interactive)
	(if (lsp:hover-contents
			 (lsp-request "textDocument/hover" (lsp--text-document-position-params)))
			(lsp-ui-doc-glance)
		(message "No information available")))

;; set per buffer so a major mode cannot keep the key, lua binds K to its own manual search
(defun my/lsp-keys ()
	(evil-local-set-key 'normal (kbd "K") #'my/lsp-hover)
	(evil-local-set-key 'normal (kbd "gi") #'lsp-find-implementation)
	(evil-local-set-key 'normal (kbd "gI") #'lsp-ui-peek-find-implementation))

;; stops the server for the buffer or starts one again
(defun my/lsp-toggle ()
	(interactive)
	(if (bound-and-true-p lsp-mode)
			(lsp-disconnect)
		(lsp-deferred)))

;; the bundled lookups want an icon pkg with a second font, the loaded one covers both
(defun my/lsp-symbol-icon (kind &optional feature)
	(when (and kind (lsp-icons--enabled-for-feature feature))
		(let ((cell (aref my/icons-symbol-kinds (1- kind))))
			(propertize (car cell) 'face (cdr cell)))))

(defun my/lsp-file-icon (ext &optional feature)
	(when (and ext (lsp-icons--enabled-for-feature feature))
		(nerd-icons-icon-for-extension ext)))

;; every piece is drawn behind a separator, so the row opens with one that separates nothing
(defun my/breadcrumb-strip-lead (string)
	(let ((lead (concat (lsp-headerline--arrow-icon) " ")))
		(if (string-prefix-p lead string)
				(substring string (length lead))
			string)))

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
	;; the file and the symbol path across the top of the window, the directories stay out
	(lsp-headerline-breadcrumb-segments '(file symbols))
	;; the severity of everything below a piece is drawn onto it as a wave in colors of its own
	(lsp-headerline-breadcrumb-enable-diagnostics nil)
	;; how long typing has to stop before highlights and lenses refresh
	(lsp-idle-delay 0.5)
	;; the key popup lists the lsp keys under their prefix, the normal state keys wait for a server
	:hook ((lsp-mode . lsp-enable-which-key-integration)
				 (lsp-after-open . my/lsp-keys))
	:config
	(advice-add 'lsp-icons-get-by-symbol-kind :override #'my/lsp-symbol-icon)
	(advice-add 'lsp-icons-get-by-file-ext :override #'my/lsp-file-icon)
	(advice-add 'lsp-headerline--build-string :filter-return #'my/breadcrumb-strip-lead)
	:general-config
	(my/leader
		"l" (cons "lsp" (make-sparse-keymap))
		"l D" #'lsp-find-definition
		"l d" #'lsp-find-declaration
		"l o" #'lsp-ui-imenu
		"l I" #'lsp-describe-session
		"l s" #'lsp-signature-activate
		"l E" #'my/diagnostic-box
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
	:defer t)

;; a parsing mode carries its own name, so the lineage is asked for rather than the name
(defun my/lsp-maybe-start ()
	(when (derived-mode-p my/lsp-modes)
		(lsp-deferred)))

;; the server starts once the buffer is shown instead of while a file is being read
(add-hook 'find-file-hook #'my/lsp-maybe-start)

;; diagnostics beside the line and docs in a popup
(use-package lsp-ui
	:after lsp-mode
	:custom
	;; the line at point carries its own diagnostics to the right
	(lsp-ui-sideline-show-diagnostics t)
	;; servers offer the same action on every line they flag, the leader key reaches them instead
	(lsp-ui-sideline-show-code-actions nil)
	;; hover text belongs in the popup, the sideline row stays short
	(lsp-ui-sideline-show-hover nil)
	;; the popup opens on the key rather than following the cursor
	(lsp-ui-doc-show-with-cursor nil)
	;; pointer tracking turns every pixel of mouse motion into a redisplay
	(lsp-ui-doc-show-with-mouse nil)
	(lsp-ui-doc-position 'at-point)
	:hook (lsp-mode . lsp-ui-mode))
