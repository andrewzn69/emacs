;;; org.el --- Notes and agenda -*- lexical-binding: t; -*-

;; default, local.el can override it
(defvar my/org-directory "~/docs/org/")

(use-package org
	;; loads on the first org file or org command, not at startup
	:defer t
	:general
	;; capture on its own key, agenda in the open group
	(my/leader
	 "X" #'org-capture
	 "o" (cons "open" (make-sparse-keymap))
	 "o a" #'org-agenda)
	:custom
	(org-directory my/org-directory)
	;; agenda collects todos from every org file in the notes dir, only if the dir exists here
	(org-agenda-files (when (file-directory-p my/org-directory)
											(list my/org-directory)))
	;; capture target when a template has no file of its own
	(org-default-notes-file (expand-file-name "notes.org" my/org-directory))
	:config
	(require 'org-mouse))

;; buffer local so the toggle only ever runs in org buffers
(defun my/org-appear-evil-hooks ()
	(add-hook 'evil-insert-state-entry-hook #'org-appear-manual-start nil t)
	(add-hook 'evil-insert-state-exit-hook #'org-appear-manual-stop nil t))

(use-package org-appear
	:hook ((org-mode . org-appear-mode)
				 (org-mode . my/org-appear-evil-hooks))
	:custom
	;; manual hands the trigger to the evil hooks instead of the cursor
	(org-appear-trigger 'manual)
	;; org hides link syntax so the toggle has to cover it
	(org-appear-autolinks t)
	;; entities and scripts hide once org modern turns them on
	(org-appear-autoentities t)
	(org-appear-autosubmarkers t))

(defface my/org-priority-a
	'((t :inherit error))
	"Face for the highest priority label.")

(defface my/org-priority-b
	'((t :inherit warning))
	"Face for the middle priority label.")

(defface my/org-priority-c
	'((t :inherit shadow))
	"Face for the lowest priority label.")

;; styling only, the hiding it switches on is handed back by org appear
(use-package org-modern
	:hook ((org-mode . org-modern-mode)
				 (org-agenda-finalize . org-modern-agenda))
	:custom
	;; tags draw as labels next to the heading so aligning them to a column fights it
	(org-auto-align-tags nil)
	(org-tags-column 0)
	(org-agenda-tags-column 0)
	(org-hide-emphasis-markers t)
	(org-pretty-entities t)
	(org-ellipsis "…")
	;; round bullets per level instead of the fold arrows
	(org-modern-star 'replace)
	;; same unicode block so every state renders at one size
	(org-modern-checkbox '((?X . "▣")
												 (?- . "▤")
												 (?\s . "□")))
	(org-modern-priority-faces '((?A . my/org-priority-a)
															 (?B . my/org-priority-b)
															 (?C . my/org-priority-c)))
	:custom-face
	;; label metrics follow the font so they live here rather than in the theme
	;; the shipped condensed width has no cut in this font and falls back to another family
	(org-modern-label ((t (:height 1.0 :width normal :weight regular :underline nil)))))
