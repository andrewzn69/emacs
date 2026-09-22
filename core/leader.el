;;; leader.el --- Leader key map -*- lexical-binding: t; -*-

;; one prefix map holds every leader key, modules add theirs with the definer in their use-package block
(defvar my/leader-map (make-sparse-keymap))
;; one place for the key, the dashboard menu shows it in front of each entry key
(defvar my/leader-key "SPC")
;; mode specific commands, each module binds its own under this
(defvar my/localleader-key "m")

(use-package general
  :config
  (general-create-definer my/leader :keymaps 'my/leader-map)
  ;; bound per mode map rather than in the leader map, so a mode only shows its own keys
  (general-create-definer my/localleader
    :states '(normal visual motion insert emacs)
    :prefix (concat my/leader-key " " my/localleader-key)
    :non-normal-prefix (concat "M-" my/leader-key " " my/localleader-key))
  ;; space in states that dont type text, alt space in insert and emacs state
  ;; bound in the override map, which comes before every mode keymap, so no mode can take the leader
  (with-eval-after-load 'evil
    (general-define-key
     :states '(normal visual motion insert emacs)
     :keymaps 'override
     :prefix-map 'my/leader-map
     :prefix my/leader-key
     :non-normal-prefix "M-SPC"))
  ;; built in commands, a string paired with a map names the group in the key popup
  (my/leader
    "." #'find-file
    "," #'switch-to-buffer
    ":" #'execute-extended-command
    "RET" #'bookmark-jump
    "u" #'universal-argument
    "b" (cons "buffer" (make-sparse-keymap))
    "b b" #'switch-to-buffer
    "b i" #'ibuffer
    "b k" #'kill-current-buffer
    "b n" #'next-buffer
    "b p" #'previous-buffer
    "b r" #'revert-buffer
    "f" (cons "file" (make-sparse-keymap))
    "f f" #'find-file
    "f s" #'save-buffer
    "h" (cons "help" help-map)
    "q" (cons "quit" (make-sparse-keymap))
    "q q" #'save-buffers-kill-terminal))

;; popup listing the next keys after a pause, built in so straight skips it
(use-package which-key
  :straight nil
  :custom
  ;; once open, the popup follows each further key almost at once
  (which-key-idle-secondary-delay 0.1)
  ;; keys sorted alphabetically with lower and upper case mixed
  (which-key-sort-order #'which-key-key-order-alpha)
  (which-key-sort-uppercase-first nil)
  ;; wider columns and a taller popup, so it doesnt turn into one long line
  (which-key-add-column-padding 1)
  (which-key-min-display-lines 7)
  ;; own side window slot so it doesnt replace other popups
  (which-key-side-window-slot -10)
  ;; remapped keys show the command that actually runs
  (which-key-compute-remaps t)
  (which-key-ellipsis "…")
  :config
  (which-key-mode 1))
