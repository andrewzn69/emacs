;;; config.el --- Syntax parsing -*- lexical-binding: t; -*-

;; the build ships a grammar for every language, so the parsing modes take over from the old ones
(use-package treesit
	:straight nil
	:custom
	;; a grammar missing here means the build lacks it, and nothing can compile one at run time
	(treesit-auto-install-grammar 'never)
	;; the lower levels leave field access, brackets and operators plain
	(treesit-font-lock-level 4)
	(treesit-enabled-modes t))
