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
	(my/localleader
	 :keymaps 'org-mode-map
	 "#" #'org-update-statistics-cookies
	 "'" #'org-edit-special
	 "*" #'org-ctrl-c-star
	 "-" #'org-ctrl-c-minus
	 "." #'org-goto
	 "A" #'org-archive-subtree-default
	 "e" #'org-export-dispatch
	 "f" #'org-footnote-action
	 "h" #'org-toggle-heading
	 "i" #'org-toggle-item
	 "n" #'org-store-link
	 "o" #'org-set-property
	 "q" #'org-set-tags-command
	 "t" #'org-todo
	 "T" #'org-todo-list
	 "x" #'org-toggle-checkbox
	 "b" '(:ignore t :which-key "table")
	 "b -" #'org-table-insert-hline
	 "b a" #'org-table-align
	 "b b" #'org-table-blank-field
	 "b c" #'org-table-create-or-convert-from-region
	 "b e" #'org-table-edit-field
	 "b f" #'org-table-edit-formulas
	 "b h" #'org-table-field-info
	 "b r" #'org-table-recalculate
	 "b R" #'org-table-recalculate-buffer-tables
	 "b s" #'org-table-sort-lines
	 "b d" '(:ignore t :which-key "delete")
	 "b d c" #'org-table-delete-column
	 "b d r" #'org-table-kill-row
	 "b i" '(:ignore t :which-key "insert")
	 "b i c" #'org-table-insert-column
	 "b i h" #'org-table-insert-hline
	 "b i H" #'org-table-hline-and-move
	 "b i r" #'org-table-insert-row
	 "d" '(:ignore t :which-key "date/deadline")
	 "d d" #'org-deadline
	 "d s" #'org-schedule
	 "d t" #'org-time-stamp
	 "d T" #'org-time-stamp-inactive
	 "l" '(:ignore t :which-key "links")
	 "l l" #'org-insert-link
	 "l L" #'org-insert-all-links
	 "l s" #'org-store-link
	 "l S" #'org-insert-last-stored-link
	 "l t" #'org-toggle-link-display
	 "p" '(:ignore t :which-key "priority")
	 "p d" #'org-priority-down
	 "p p" #'org-priority
	 "p u" #'org-priority-up
	 "s" '(:ignore t :which-key "tree/subtree")
	 "s a" #'org-toggle-archive-tag
	 "s A" #'org-archive-subtree-default
	 "s b" #'org-tree-to-indirect-buffer
	 "s c" #'org-clone-subtree-with-time-shift
	 "s d" #'org-cut-subtree
	 "s h" #'org-promote-subtree
	 "s j" #'org-move-subtree-down
	 "s k" #'org-move-subtree-up
	 "s l" #'org-demote-subtree
	 "s n" #'org-narrow-to-subtree
	 "s N" #'widen
	 "s r" #'org-refile
	 "s s" #'org-sparse-tree
	 "s S" #'org-sort)
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
