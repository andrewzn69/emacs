;;; config.el --- Git client -*- lexical-binding: t; -*-

(use-package magit
  ;; loads on the first magit command, C-x g or leader g g opens the status buffer
  :defer t
  :general
  (my/leader
    "g" (cons "git" (make-sparse-keymap))
    "g g" #'magit-status)
  :custom
  ;; small edits inside long lines get lost without it
  (magit-diff-refine-hunk t))

(use-package forge
  :after magit
  :preface
  ;; off before magit loads, evil collection binds forge instead
  (setq forge-add-default-bindings nil))

(use-package auth-source
  :straight nil
  :defer t
  :custom
  ;; encrypted file only, the default list also reads plain text ones
  (auth-sources '("~/.authinfo.gpg")))

(defun my/forge-merge-pullreq (pullreq)
	"Merge PULLREQ through the api with a merge commit."
	(interactive (list (progn (require 'forge)
														(or (forge-current-pullreq)
																(forge-read-pullreq "Merge pull request")))))
	(let ((pullreq (forge-get-pullreq pullreq)))
		;; the api merge resolves the head ref by branch name, so it has to exist
		(unless (forge--pullreq-branch-active pullreq)
			(forge--branch-pullreq pullreq))
		(forge-merge pullreq 'merge)))


(my/leader
	"g m" #'my/forge-merge-pullreq)
