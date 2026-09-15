;;; modeline.el --- Mode line -*- lexical-binding: t; -*-

;; defaults, local.el can override them
(defvar my/modeline-time-format "%H:%M")

;; full state names instead of the short tags, evil declares them with defvar so values set before it loads stay
(setq evil-normal-state-tag " NORMAL "
      evil-insert-state-tag " INSERT "
      evil-visual-char-tag " VISUAL "
      evil-visual-line-tag " V-LINE "
      evil-visual-screen-line-tag " V-LINE "
      evil-visual-block-tag " V-BLOCK "
      evil-replace-state-tag " REPLACE "
      evil-operator-state-tag " O-PENDING "
      evil-motion-state-tag " MOTION "
      evil-emacs-state-tag " EMACS ")

(use-package doom-modeline
	:custom
	;; error and warning counts only
	(doom-modeline-check 'simple)
	;; path starts at the project folder
	(doom-modeline-buffer-file-name-style 'relative-from-project)
	;; mode icon drawn next to the mode name instead of in front of the path
	(doom-modeline-major-mode-icon nil)
	;; encoding only when it isnt utf 8 with the os line endings
	(doom-modeline-buffer-encoding 'nondefault)
	(doom-modeline-default-eol-type (if my/windows-p 1 0))
	;; minor mode lighters are hidden
	(projectile-dynamic-mode-line nil)
	:config
	;; face of the current evil state, normal state face without evil and the mode line face for a state without its own
	(defun my/modeline-state-face ()
		(doom-modeline-face (if (bound-and-true-p evil-local-mode)
														(intern (format "doom-modeline-evil-%s-state" evil-state))
													'doom-modeline-evil-normal-state)))
	;; state name on its state face in the selected window only
	(doom-modeline-def-segment my/evil-state
		(when (and (bound-and-true-p evil-local-mode) (doom-modeline--active))
			(let ((tag (evil-state-property evil-state :tag t)))
				(when (functionp tag)
					(setq tag (funcall tag)))
				(when (stringp tag)
					(propertize tag 'face (my/modeline-state-face))))))
	;; branch on the panel face in the selected window only
	(doom-modeline-def-segment my/vcs-branch
		(when (and vc-mode (doom-modeline--active))
			(let ((face (doom-modeline-face 'doom-modeline-panel))
						;; vc text minus the backend name and every state marker, percent doubled so the mode line prints it
						(branch (string-replace "%" "%%" (replace-regexp-in-string "\\`[[:space:]]*[[:alpha:]]*[-:@!?]" "" vc-mode))))
				(concat (propertize " " 'face face)
								(doom-modeline-icon 'powerline "nf-pl-branch" "" nil :face face)
								(propertize (concat " " branch " ") 'face face)))))
	;; mode icon for the mode name
	(doom-modeline-def-segment my/major-mode-icon
		(concat (doom-modeline-spc) (doom-modeline-display-icon (nerd-icons-icon-for-buffer))))
	;; share of the buffer above the window top on the panel face in the selected window only
	(doom-modeline-def-segment my/buffer-percent
		(when (doom-modeline--active)
			`(:propertize (" " (-3 "%p") " ") face ,(doom-modeline-face 'doom-modeline-panel))))
	;; line and column from one on the panel face in the selected window only
	(doom-modeline-def-segment my/buffer-position
		(when (doom-modeline--active)
			`(:propertize " %l:%C " face ,(doom-modeline-face 'doom-modeline-panel))))
	;; clock on the state face in the selected window only
	(doom-modeline-def-segment my/time
		(when (doom-modeline--active)
			(let ((face (my/modeline-state-face)))
				(concat (propertize " " 'face face)
								(doom-modeline-icon 'octicon "nf-oct-clock" "" nil :face face)
								(propertize (concat " " (format-time-string my/modeline-time-format) " ") 'face face)))))
	;; redraw on every full minute so the clock doesnt wait for input
	(run-at-time t 60 #'force-mode-line-update t)
	;; every layout starts with the state block and branch and ends with the clock, bar, modals, stock branch, stock time and stock position are dropped
	(doom-modeline-add-segment 'my/evil-state 'bar :before)
	(doom-modeline-add-segment 'my/vcs-branch 'my/evil-state :after)
	(doom-modeline-add-segment 'my/major-mode-icon 'major-mode :before)
	(doom-modeline-add-segment 'my/time 'time :after)
	;; percent and position before the clock, skipping the layouts that never showed a position
	(let ((doom-modeline-excluded-modelines '(minimal dashboard media pdf helm)))
		(doom-modeline-add-segment 'my/buffer-percent 'my/time :before)
		(doom-modeline-add-segment 'my/buffer-position 'my/time :before))
	(doom-modeline-remove-segment 'bar)
	(doom-modeline-remove-segment 'modals)
	(doom-modeline-remove-segment 'vcs)
	(doom-modeline-remove-segment 'time)
	(doom-modeline-remove-segment 'buffer-position)
	(doom-modeline-mode 1))

;; match count while searching, drawn by the mode line
(use-package anzu
	:config
	(global-anzu-mode 1))
