;;; config.el --- File manager -*- lexical-binding: t; -*-

(use-package nerd-icons)

;; quitting the last window of a file opens its dir instead of closing emacs, the sidebar does not count
;; a buffer from emacsclient still finishes so its caller stops waiting
(defun my/dirvish-quit-to-dir (quit &optional force)
	(if (and (eq (selected-window) (window-main-window))
					 buffer-file-name
					 (not (bound-and-true-p server-buffer-clients)))
			(let ((file buffer-file-name))
				;; the bang drops unsaved changes instead of asking
				(when force
					(set-buffer-modified-p nil))
				(when (kill-buffer)
					(dired-jump nil file)))
		(funcall quit force)))

;; return unfolds a folder in the sidebar, everywhere else it enters it as in dired
(defun my/dirvish-ret ()
	(interactive)
	(let ((file (dired-get-filename nil t)))
		(if (and file
						 (window-parameter nil 'window-side)
						 (file-directory-p file))
				(dirvish-subtree-toggle)
			(dired-find-file))))

;; new entries start at the entry under the cursor, a folder itself or the folder holding a file
;; the listing dir alone would be the project root for anything inside an unfolded folder
(defun my/dirvish-target-dir ()
	(let ((file (dired-get-filename nil t)))
		(cond ((not file) (dired-current-directory))
					((file-directory-p file) (file-name-as-directory (expand-file-name file)))
					(t (file-name-directory file)))))

(defun my/dirvish-create-file (file)
	(interactive (list (read-file-name "Create empty file: " (my/dirvish-target-dir))))
	(dired-create-empty-file file))

(defun my/dirvish-create-directory (directory)
	(interactive (list (read-file-name "Create directory: " (my/dirvish-target-dir))))
	(dired-create-directory directory))

;; the sidebar is a tree, so . and .. go, along with autosave and lock files
(defun my/dirvish-side-omit (buffer)
	(with-current-buffer buffer
		(dired-omit-mode 1)))

;; every dired buffer opens as dirvish
(use-package dirvish
	:init
	(dirvish-override-dired-mode)
	:custom
	(dirvish-attributes '(nerd-icons file-time file-size))
	;; the sidebar is a tree, folders expand in place
	(dirvish-side-attributes '(subtree-state nerd-icons))
	;; window keys reach the sidebar like any other window, closing the other windows still leaves it
	(dirvish-side-window-parameters '((no-delete-other-windows . t)))
	;; nested folders indent with blanks, the default draws a guide line per level
	(dirvish-subtree-prefix "  ")
	;; omitting runs on every sidebar refresh, its count message would repeat each time
	(dired-omit-verbose nil)
	:config
	;; the sidebar keeps the current file selected and moves to the root of a new project
	(dirvish-side-follow-mode 1)
	(define-key dirvish-mode-map (kbd "TAB") #'dirvish-subtree-toggle)
	(define-key dirvish-mode-map (kbd "RET") #'my/dirvish-ret)
	;; filter as you type and add a file, dired leaves / free and ships its a command disabled
	(define-key dirvish-mode-map (kbd "/") #'dirvish-narrow)
	(define-key dirvish-mode-map (kbd "a") #'my/dirvish-create-file)
	(define-key dirvish-mode-map (kbd "+") #'my/dirvish-create-directory)
	;; runs for every buffer the sidebar creates and for no other dirvish buffer
	(with-eval-after-load 'dirvish-side
		(advice-add 'dirvish-side-root-conf :after #'my/dirvish-side-omit))
	(with-eval-after-load 'evil
		;; evil collection binds dired keys in normal state only, motion state keeps the leader and C-w without them
		(evil-set-initial-state 'dired-mode 'motion)
		;; dired and dirvish keys win over the motion ones, the leader still wins over both
		(evil-make-overriding-map dirvish-mode-map 'motion)
		(advice-add 'evil-quit :around #'my/dirvish-quit-to-dir))
	:general-config
	(my/leader
		"e" #'dirvish-side))
