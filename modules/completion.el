;;; completion.el --- Completion popup at point -*- lexical-binding: t; -*-

;; defaults, local.el can override them
;; characters typed before the popup opens on its own
(defvar my/completion-prefix 2)
(defvar my/completion-delay 0.1)

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

;; sources the language servers do not cover
(use-package cape
	:init
	;; file paths anywhere, words from open buffers, symbols while editing elisp
	(add-hook 'completion-at-point-functions #'cape-file)
	(add-hook 'completion-at-point-functions #'cape-dabbrev)
	(add-hook 'emacs-lisp-mode-hook
						(lambda ()
							(add-hook 'completion-at-point-functions #'cape-elisp-symbol nil t))))
