;;; dashboard.el --- Start screen -*- lexical-binding: t; -*-

(require 'desktop)

;; recent files list for the recents entry
(recentf-mode 1)

;; no gnu emacs info hint in the echo area after startup
(advice-add 'display-startup-echo-area-message :override #'ignore)

;; defaults, local.el can override them
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
                          'face 'dashboard-heading)
      (insert (propertize (if key (key-description key) "") 'face 'font-lock-constant-face)
              "\n\n"))))

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
                         'follow-link t)
     (buffer-string))
   "\n"))

(use-package nerd-icons)

(use-package dashboard
  :custom
  (dashboard-center-content t)
  (dashboard-vertically-center-content t)
  ;; menu then footer then load info
  (dashboard-startupify-list '(dashboard-insert-items
                               dashboard-insert-newline
                               my/dashboard-insert-footer
                               dashboard-insert-newline
                               dashboard-insert-init-info))
  (dashboard-item-generators '((menu . my/dashboard-insert-menu)))
  (dashboard-items '(menu))
  :config
  ;; normal start shows the dashboard only when no file is passed
  (dashboard-setup-startup-hook)
  ;; emacsclient frames open the dashboard, daemon only so emacs with a file doesnt split the window
  (when (daemonp)
    (setq initial-buffer-choice #'dashboard-open)))
