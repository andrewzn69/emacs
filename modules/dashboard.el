;;; dashboard.el --- Start screen -*- lexical-binding: t; -*-

(require 'desktop)

;; recent files list for the recents entry
(recentf-mode 1)

;; no gnu emacs info hint in the echo area after startup
(advice-add 'display-startup-echo-area-message :override #'ignore)

;; defaults, local.el can override them
(defvar my/dashboard-banner (expand-file-name "assets/banner.txt" my/config-directory))
(defvar my/dashboard-footer-url "https://github.com/andrewzn69/emacs")
(defvar my/dashboard-menu
  '(("Recently opened files" nerd-icons-faicon "nf-fa-file_text" recentf-open)
    ("Reload last session" nerd-icons-octicon "nf-oct-history" my/load-session)
    ("Open org-agenda" nerd-icons-octicon "nf-oct-calendar" org-agenda)
    ("Open project" nerd-icons-octicon "nf-oct-briefcase" project-switch-project)
    ("Jump to bookmark" nerd-icons-octicon "nf-oct-bookmark" bookmark-jump)
    ("Open private configuration" nerd-icons-octicon "nf-oct-tools" my/open-config)))

;; save open files on quit, old file removed first so desktop save never asks to overwrite
(defun my/save-session ()
  (unless noninteractive
    (let ((file (desktop-full-file-name my/state-directory)))
      (when (file-exists-p file)
        (delete-file file))
      (desktop-save my/state-directory t))))

(add-hook 'kill-emacs-hook #'my/save-session)

(defun my/load-session ()
  (interactive)
  (if (file-exists-p (desktop-full-file-name my/state-directory))
      (desktop-read my/state-directory)
    (message "No saved session")))

;; file picker that starts in the cfg dir
(defun my/open-config ()
  (interactive)
  (let ((default-directory my/config-directory))
    (call-interactively #'find-file)))

;; one line per menu entry with icon, clickable label and key if bound
(defun my/dashboard-insert-menu (&rest _)
  (dolist (item my/dashboard-menu)
    (let* ((label (nth 0 item))
           (icon-fn (nth 1 item))
           (icon (nth 2 item))
           (command (nth 3 item))
           (key (where-is-internal command nil t)))
      (when (dashboard-display-icons-p)
        (insert (format "%-3s" (funcall icon-fn icon :face 'dashboard-heading))))
      (insert-text-button (format "%-30s" label)
                          'action (lambda (_) (call-interactively command))
                          'follow-link t
                          'face 'dashboard-heading
													;; marks entries the cursor can sit on
													'my/dashboard-menu t)
      (insert (propertize (if key (key-description key) "") 'face 'font-lock-constant-face)
              "\n\n"))))

;; start of every marked entry, top to bottom
(defun my/dashboard-menu-starts ()
	(let (starts)
		(save-excursion
			(goto-char (point-min))
			(while-let ((match (text-property-search-forward 'my/dashboard-menu t t)))
				(push (prop-match-beginning match) starts)))
		(nreverse starts)))

;; cursor goes to the entry on its line, else the entry above, else the first entry
(defun my/dashboard-snap-to-menu ()
	(let ((starts (my/dashboard-menu-starts))
				(bol (line-beginning-position))
				(eol (line-end-position)))
		(when starts
			(goto-char (or (seq-find (lambda (start) (<= bol start eol)) starts)
										 (car (last (seq-filter (lambda (start) (< start (point))) starts)))
										 (car starts))))))

;; moving past the last entry goes to the first and past the first goes to the last
(defun my/dashboard-next-item ()
  (interactive)
  (when-let* ((starts (my/dashboard-menu-starts)))
    (goto-char (or (seq-find (lambda (start) (> start (point))) starts)
                   (car starts)))))

(defun my/dashboard-previous-item ()
  (interactive)
  (when-let* ((starts (my/dashboard-menu-starts)))
    (goto-char (or (car (last (seq-filter (lambda (start) (< start (point))) starts)))
                   (car (last starts))))))

;; snaps right away and again after every command in the dashboard buffer
(defun my/dashboard-trap-cursor ()
	(add-hook 'post-command-hook #'my/dashboard-snap-to-menu nil t)
	(my/dashboard-snap-to-menu))

;; github icon linking to the cfg repo, plain text in a terminal
(defun my/dashboard-insert-footer ()
  (dashboard-insert-center
   (with-temp-buffer
     (insert-text-button (if (dashboard-display-icons-p)
                             (nerd-icons-codicon "nf-cod-octoface"
                                                 :face 'dashboard-footer-icon-face
                                                 :height 1.3
                                                 :v-adjust -0.15)
                           "github")
                         'action (lambda (_) (browse-url my/dashboard-footer-url))
                         'follow-link t
                         'my/dashboard-menu t)
     (buffer-string))
   "\n"))

(use-package nerd-icons)

(use-package dashboard
  :custom
  (dashboard-center-content t)
  (dashboard-vertically-center-content t)
	(dashboard-startup-banner my/dashboard-banner)
	;; banner with two empty lines below when set, a nil banner errors so it is left out
  ;; then menu, footer then load info
  (dashboard-startupify-list `(,@(when my/dashboard-banner
																	 '(dashboard-insert-banner
																		 dashboard-insert-newline
																		 dashboard-insert-newline))
															 dashboard-insert-items
                               dashboard-insert-newline
                               my/dashboard-insert-footer
                               dashboard-insert-newline
                               dashboard-insert-init-info))
  (dashboard-item-generators '((menu . my/dashboard-insert-menu)))
  (dashboard-items '(menu))
	:custom-face
	;; banner in the theme comment color
	(dashboard-text-banner ((t (:inherit font-lock-comment-face))))
  :config
	;; every render ends in dashboard mode, startup then moves the cursor to the top again
	(add-hook 'dashboard-mode-hook #'my/dashboard-trap-cursor)
	(add-hook 'dashboard-after-initialize-hook #'my/dashboard-snap-to-menu)
	;; line and widget movement jumps between menu items instead
	(dolist (command '(dashboard-next-line next-line widget-forward
										 evil-next-line evil-next-visual-line))
		(define-key dashboard-mode-map (vector 'remap command) #'my/dashboard-next-item))
  (dolist (command '(dashboard-previous-line previous-line widget-backward
										 evil-previous-line evil-previous-visual-line))
		(define-key dashboard-mode-map (vector 'remap command) #'my/dashboard-previous-item))
  ;; normal start shows the dashboard only when no file is passed
  (dashboard-setup-startup-hook)
  ;; emacsclient frames open the dashboard, daemon only so emacs with a file doesnt split the window
  (when (daemonp)
    (setq initial-buffer-choice #'dashboard-open)))
