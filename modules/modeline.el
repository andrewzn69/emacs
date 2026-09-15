;;; modeline.el --- Mode line -*- lexical-binding: t; -*-

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
	;; encoding only when it isnt utf 8 with the os line endings
	(doom-modeline-buffer-encoding 'nondefault)
	(doom-modeline-default-eol-type (if my/windows-p 1 0))
	;; minor mode lighters are hidden
	(projectile-dynamic-mode-line nil)
	:config
	;; column next to the line number
	(column-number-mode 1)
	;; state name on its state face in the selected window only, a state without its own face gets the mode line face
	(doom-modeline-def-segment my/evil-state
		(when (and (bound-and-true-p evil-local-mode) (doom-modeline--active))
			(let ((tag (evil-state-property evil-state :tag t)))
				(when (functionp tag)
					(setq tag (funcall tag)))
				(when (stringp tag)
					(propertize tag 'face (doom-modeline-face
																 (intern (format "doom-modeline-evil-%s-state" evil-state))))))))
	;; branch on the panel face in the selected window only
	(doom-modeline-def-segment my/vcs-branch
		(when (and vc-mode (doom-modeline--active))
			(let ((face (doom-modeline-face 'doom-modeline-panel))
						;; vc text minus the backend name and every state marker, percent doubled so the mode line prints it
						(branch (string-replace "%" "%%" (replace-regexp-in-string "\\`[[:space:]]*[[:alpha:]]*[-:@!?]" "" vc-mode))))
				(concat (propertize " " 'face face)
								(doom-modeline-icon 'powerline "nf-pl-branch" "" nil :face face)
								(propertize (concat " " branch " ") 'face face)))))
	;; every layout starts with the state block and branch, the bar, the space padded modals and the right side branch are dropped
	(doom-modeline-add-segment 'my/evil-state 'bar :before)
	(doom-modeline-add-segment 'my/vcs-branch 'my/evil-state :after)
	(doom-modeline-remove-segment 'bar)
	(doom-modeline-remove-segment 'modals)
	(doom-modeline-remove-segment 'vcs)
	(doom-modeline-mode 1))

;; match count while searching, drawn by the mode line
(use-package anzu
	:config
	(global-anzu-mode 1))
