;;; org.el --- Notes and agenda -*- lexical-binding: t; -*-

;; default, local.el can override it
(defvar my/org-directory "~/docs/org/")

(use-package org
	;; loads on the first org file or org command, not at startup
	:defer t
	:custom
	(org-directory my/org-directory)
	;; agenda collects todos from every org file in the notes dir, only if the dir exists here
	(org-agenda-files (when (file-directory-p my/org-directory)
											(list my/org-directory)))
	;; capture target when a template has no file of its own
	(org-default-notes-file (expand-file-name "notes.org" my/org-directory)))
