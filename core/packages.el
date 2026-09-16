;;; packages.el --- Package manager setup -*- lexical-binding: t; -*-

;; lockfile lives in the repo, every machine installs the same commits
(setq straight-profiles
			`((nil . ,(expand-file-name "lock/default.el" my/config-directory))))

;; every use-package block installs its package through straight.el
(setq straight-use-package-by-default t)

;; straight.el's official bootstrap snippet
(defvar	bootstrap-version)
(let ((bootstrap-file
			 ;; straight.el's loader inside the state dir
			 (expand-file-name
				"straight/repos/straight.el/bootstrap.el"
				(or (bound-and-true-p straight-base-dir)
						user-emacs-directory)))
      (bootstrap-version 7))
	;; first start only, download and run the installer which clones straight.el
	(unless (file-exists-p bootstrap-file)
		(with-current-buffer
			  (url-retrieve-synchronously
				 "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
				 'silent 'inhibit-cookies)
			(goto-char (point-max))
			(eval-print-last-sexp)))
	;; every start, load straight.el
	(load bootstrap-file nil 'nomessage))

;; built-in use-package, straight.el hooks into it as soon as it loads
(require 'use-package)

;; the default threshold fills while a server and the popup allocate, so collection lands mid scroll
(use-package gcmh
	:custom
	;; high enough that typing and scrolling never reach it, low enough that the heap stays in memory
	(gcmh-high-cons-threshold (* 128 1024 1024))
	;; the wait before collecting scales with how long the last one took
	(gcmh-idle-delay 'auto)
	:config
	(gcmh-mode 1))
