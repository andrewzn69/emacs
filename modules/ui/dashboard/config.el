;;; config.el --- Start screen -*- lexical-binding: t; -*-

;;; Settings

;; defaults, local.el can override them
(defvar my/dashboard-banner (expand-file-name "assets/lain.txt" my/config-directory))
(defvar my/dashboard-banner-height 0.8)
;; spaces between the longest menu label and the key column
(defvar my/dashboard-key-gap 10)
(defvar my/dashboard-footer-url "https://github.com/andrewzn69/emacs")
(defvar my/dashboard-menu
  '(("Recently opened files" nerd-icons-faicon "nf-fa-file_text" recentf-open-files)
    ("Open org-agenda" nerd-icons-octicon "nf-oct-calendar" org-agenda)
    ("Open project" nerd-icons-octicon "nf-oct-briefcase" projectile-switch-project)
    ("Jump to bookmark" nerd-icons-octicon "nf-oct-bookmark" bookmark-jump)
    ("Open private configuration" nerd-icons-octicon "nf-oct-tools" my/open-config)))

;;; Commands

;; recent files list for the recents entry
(recentf-mode 1)

;; file picker that starts in the cfg dir
(defun my/open-config ()
  (interactive)
  (let ((default-directory my/config-directory))
    (call-interactively #'find-file)))

;; recent files and cfg under the leader
(my/leader
  "f r" #'recentf-open-files
  "f p" #'my/open-config)

;;; Banner

;; banner in a smaller font, the prefix space gets the same face so lines shrink too
(defun my/dashboard-insert-banner ()
  (let* (;; height set here so a theme styling the banner face cant change the size
         (face `(:inherit dashboard-text-banner :height ,my/dashboard-banner-height))
         (text (propertize (with-temp-buffer
                             (insert-file-contents my/dashboard-banner)
                             (buffer-string))
                           'face face))
         ;; rendered width of the widest line in default columns, the same measure the menu is centered by
         ;; so the smaller face and the font that draws the glyphs both count
         (width (/ (string-pixel-width text) (float (frame-char-width))))
         (prefix (propertize " "
                             'face face
                             'display `(space :align-to (- center ,(/ width 2)))))
         (start (point)))
    (insert text)
    (add-text-properties start (point)
                         `(line-prefix ,prefix wrap-prefix ,prefix))))

;;; Menu

;; key column starts a fixed gap after the longest label, so every key lines up
(defun my/dashboard-label-width ()
  (+ my/dashboard-key-gap
     (apply #'max (mapcar (lambda (item) (string-width (car item))) my/dashboard-menu))))

;; one line per menu entry with icon, clickable label and key if bound
(defun my/dashboard-insert-menu (&rest _)
  (dolist (item my/dashboard-menu)
    (let* ((label (nth 0 item))
           (icon-fn (nth 1 item))
           (icon (nth 2 item))
           (command (nth 3 item))
           ;; leader map searched on its own, a plain lookup at startup shows evil state names or the emacs own keys
           (key (if-let* ((leader (where-is-internal command (list my/leader-map) t)))
                    (concat my/leader-key " " (key-description leader))
                  (key-description (where-is-internal command nil t)))))
      (when (dashboard-display-icons-p)
        (insert (format "%-3s" (funcall icon-fn icon :face 'dashboard-heading))))
      (insert-text-button (string-pad label (my/dashboard-label-width))
                          'action (lambda (_) (call-interactively command))
                          'follow-link t
                          'face 'dashboard-heading
                          ;; label and command, shown in the echo area when the cursor moves onto the entry
                          'help-echo (format "%s (%s)" label
                                             (propertize (symbol-name command) 'face 'font-lock-constant-face))
													;; marks entries the cursor can sit on
													'my/dashboard-menu t)
      (insert (propertize key 'face 'font-lock-constant-face)
              "\n\n"))))

;;; Footer

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

;;; Cursor

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
  ;; a mouse drag or a visual state key leaves no selection behind
  (when (and (bound-and-true-p evil-local-mode) (evil-visual-state-p))
    (evil-exit-visual-state))
  (when (region-active-p)
    (deactivate-mark))
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

;; mouse hover prints the entry help in the echo area like keyboard movement, tooltips stay on everywhere else
(defun my/dashboard-echo-hover-help ()
  (setq-local show-help-function #'tooltip-show-help-non-mode))

;;; Centering

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

;;; Keys

;; evil collection binds q to quit window in read only modes, removing it lets q record macros
(defun my/dashboard-unbind-q (mode &rest _)
  (when (eq mode 'dashboard)
    (evil-define-key* 'normal dashboard-mode-map "q" nil)))

(add-hook 'evil-collection-setup-hook #'my/dashboard-unbind-q)

;;; Packages

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
  :config
	;; every render ends in dashboard mode, startup then moves the cursor to the top again
	(add-hook 'dashboard-mode-hook #'my/dashboard-trap-cursor)
  (add-hook 'dashboard-mode-hook #'my/dashboard-keep-centered)
  (add-hook 'dashboard-mode-hook #'my/dashboard-echo-hover-help)
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
