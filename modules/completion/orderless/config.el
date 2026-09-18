;;; config.el --- Completion matching -*- lexical-binding: t; -*-

;; space separated pieces match in any order, so nix mod finds nix-mode
(use-package orderless
	:custom
	(completion-styles '(orderless basic))
	;; file names keep the built in style, partial completion expands a path segment at a time
	(completion-category-overrides '((file (styles partial-completion)))))
