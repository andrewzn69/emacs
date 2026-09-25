;;; lang.el --- Diagnostics -*- lexical-binding: t; -*-

;; the fringe takes bitmaps only, the margin takes text so a glyph can be drawn there
(use-package flymake
	:straight nil
	:defer t
	:custom
	(flymake-indicator-type 'margins)
	;; copied onto the severity symbols when the checker loads, so setting it later does nothing
	(flymake-margin-indicators-string
	 ;; the glyphs draw two columns wide, so each carries a blank to keep the margin from clipping
	 `((error ,(concat (alist-get 'error my/icons-diagnostics) " ") compilation-error)
	   (warning ,(concat (alist-get 'warning my/icons-diagnostics) " ") compilation-warning)
	   ;; the protocol has four levels and the checker has three, so hints arrive as notes
	   (note ,(concat (alist-get 'info my/icons-diagnostics) " ") compilation-info))))

;; the checker messages for the line in a floating window, eldoc shows one source at a time and the server takes it
(defun my/diagnostic-box ()
	(interactive)
	(require 'eldoc-box)
	(if-let* ((diags (flymake-diagnostics (line-beginning-position)
																				(line-end-position))))
			(progn
				;; beside the cursor instead of the frame corner the hover popup uses
				(let ((eldoc-box-position-function eldoc-box-at-point-position-function))
					(eldoc-box--display (mapconcat #'flymake-diagnostic-text diags "\n\n")))
				;; polls until the cursor leaves the spot it opened at, then closes itself
				(setq eldoc-box--help-at-point-last-point (point))
				(run-with-timer 0.1 nil #'eldoc-box--help-at-point-cleanup))
		(message "no problem on this line")))

;; the problem under the cursor in a floating window, the checker feeds its text to eldoc
(use-package eldoc-box
	:defer t)
