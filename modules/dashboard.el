;;; dashboard.el --- Start screen -*- lexical-binding: t; -*-

(require 'desktop)

;; recent files list for the recents entry
(recentf-mode 1)

;; no gnu emacs info hint in the echo area after startup
(advice-add 'display-startup-echo-area-message :override #'ignore)

;; defaults, local.el can override them
(defvar my/dashboard-banner (expand-file-name "assets/lain.txt" my/config-directory))
(defvar my/dashboard-banner-height 0.8)
(defvar my/dashboard-footer-url "https://github.com/andrewzn69/emacs")
(defvar my/dashboard-menu
  '(("Recently opened files" nerd-icons-faicon "nf-fa-file_text" recentf-open-files)
    ("Reload last session" nerd-icons-octicon "nf-oct-history" my/load-session)
    ("Open org-agenda" nerd-icons-octicon "nf-oct-calendar" org-agenda)
    ("Open project" nerd-icons-octicon "nf-oct-briefcase" projectile-switch-project)
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

;; banner in a smaller font, centered by its scaled width, the prefix space gets the same face so lines shrink too
(defun my/dashboard-insert-banner ()
  (let* ((text (with-temp-buffer
                 (insert-file-contents my/dashboard-banner)
                 (buffer-string)))
         (scale (if (display-graphic-p) my/dashboard-banner-height 1))
         (width (apply #'max (mapcar #'string-width (split-string text "\n"))))
         (prefix (propertize " "
                             'face 'dashboard-text-banner
                             'display `(space :align-to (- center ,(/ (* width scale) 2.0)))))
         (start (point)))
    (insert text)
    (add-text-properties start (point)
                         `(face dashboard-text-banner line-prefix ,prefix wrap-prefix ,prefix))))

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
                          ;; label and command, shown in the echo area when the cursor moves onto the entry
                          'help-echo (format "%s (%s)" label
                                             (propertize (symbol-name command) 'face 'font-lock-constant-face))
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
                     (car starts)))))
  ;; hl line runs before this hook, so the highlight is redrawn after the cursor moves
  (when (bound-and-true-p hl-line-mode)
    (hl-line-highlight)))

;; every entry is a button, so button movement wraps at both ends and echoes the entry help
(defun my/dashboard-next-item ()
  (interactive)
  (forward-button 1 t t t))

(defun my/dashboard-previous-item ()
  (interactive)
  (backward-button 1 t t t))

;; highlight covers the entry text only, not the empty space to the window edge
(defun my/dashboard-line-range ()
  (cons (line-beginning-position) (line-end-position)))

;; snaps right away and again after every command in the dashboard buffer
(defun my/dashboard-trap-cursor ()
  (setq-local hl-line-range-function #'my/dashboard-line-range)
  (hl-line-mode 1)
  (add-hook 'post-command-hook #'my/dashboard-snap-to-menu nil t)
  (my/dashboard-snap-to-menu))

;; old padding removed, then half the free window height added as empty lines on top
;; measured in pixels because the banner lines are shorter than normal lines
(defun my/dashboard-center-vertically (window)
  (with-silent-modifications
    (save-excursion
      (goto-char (point-min))
      (delete-region (point) (progn (skip-chars-forward "\n") (point)))
      (let ((lines (floor (- (window-body-height window t)
                             (cdr (window-text-pixel-size window)))
                          (* 2 (default-line-height)))))
        (when (> lines 0)
          (insert (make-string lines ?\n))))))
  ;; scroll back to the top, a window too short for the selected entry picks its own start
  (set-window-start window (point-min) t))

;; recenters when a window shows the dashboard or changes size, and right away after a render
(defun my/dashboard-keep-centered ()
  (add-hook 'window-size-change-functions #'my/dashboard-center-vertically nil t)
  (when-let* ((window (get-buffer-window nil t)))
    (my/dashboard-center-vertically window)))

;; evil collection binds q to quit window in read only modes, removing it lets q record macros
(defun my/dashboard-unbind-q (mode &rest _)
  (when (eq mode 'dashboard)
    (evil-define-key* 'normal dashboard-mode-map "q" nil)))

(add-hook 'evil-collection-setup-hook #'my/dashboard-unbind-q)

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
                         'help-echo (format "Open github page (%s)"
                                            (propertize my/dashboard-footer-url 'face 'font-lock-constant-face))
                         'my/dashboard-menu t)
     (buffer-string))
   "\n"))

(use-package nerd-icons)

(use-package dashboard
  :custom
  (dashboard-center-content t)
  ;; banner with two empty lines below when set, then menu, footer and load info
  (dashboard-startupify-list `(,@(when my/dashboard-banner
                                   '(my/dashboard-insert-banner
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
  ;; banner in the theme comment color and a smaller font
  (dashboard-text-banner ((t (:inherit font-lock-comment-face :height ,my/dashboard-banner-height))))
  :config
	;; every render ends in dashboard mode, startup then moves the cursor to the top again
	(add-hook 'dashboard-mode-hook #'my/dashboard-trap-cursor)
  (add-hook 'dashboard-mode-hook #'my/dashboard-keep-centered)
	(add-hook 'dashboard-after-initialize-hook #'my/dashboard-snap-to-menu)
	;; line and widget movement jumps between menu items instead
	(dolist (command '(dashboard-next-line next-line widget-forward
										 evil-next-line evil-next-visual-line))
		(define-key dashboard-mode-map (vector 'remap command) #'my/dashboard-next-item))
  (dolist (command '(dashboard-previous-line previous-line widget-backward
										 evil-previous-line evil-previous-visual-line))
		(define-key dashboard-mode-map (vector 'remap command) #'my/dashboard-previous-item))
  ;; mouse wheel does nothing so the centered content stays in place
  (define-key dashboard-mode-map [remap mwheel-scroll] #'ignore)
  ;; normal start shows the dashboard only when no file is passed
  (dashboard-setup-startup-hook)
  ;; emacsclient frames open the dashboard, daemon only so emacs with a file doesnt split the window
  (when (daemonp)
    (setq initial-buffer-choice #'dashboard-open)))
