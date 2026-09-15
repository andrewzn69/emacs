;;; editor.el --- General editing behaviour -*- lexical-binding: t; -*-

;; defaults, local.el can override them
;; relative so line motion counts read off the gutter, t or visual also work
(defvar my/line-numbers-type 'relative)

;; reopening a file puts the cursor back where it was, positions saved in the state dir
(save-place-mode 1)

(setq display-line-numbers-type my/line-numbers-type)
;; width counted from the buffer lines up front so text doesnt shift when a longer number scrolls into view
(setq display-line-numbers-width-start t)

;; long lines run past the window edge instead of wrapping onto the next row
(defun my/truncate-lines ()
	(setq truncate-lines t))

;; cursor column in the cursor line color, no extension so the padding at short line ends stays one cell
(defface my/column-highlight
	'((t :inherit hl-line :extend nil))
	"Face for the cursor column.")

(defvar-local my/column-highlight-overlays nil)

(defun my/column-highlight-clear ()
	(mapc #'delete-overlay my/column-highlight-overlays)
	(setq my/column-highlight-overlays nil))

;; cell at the column on the line at point, a line ending before it gets padding and a colored space
(defun my/column-highlight-line (column window)
	(let* ((reached (move-to-column column))
				 (overlay (cond
									 ;; tab or wide character across the column, point lands after it
									 ((> reached column) (make-overlay (1- (point)) (point)))
									 ((not (eolp)) (make-overlay (point) (1+ (point))))
									 (t (make-overlay (point) (point))))))
		(if (= (overlay-start overlay) (overlay-end overlay))
				(overlay-put overlay 'after-string
										 (concat (make-string (- column reached) ?\s)
														 (propertize " " 'face 'my/column-highlight)))
			(overlay-put overlay 'face 'my/column-highlight))
		;; below the cursor line overlay and only in the window that was drawn for
		(overlay-put overlay 'priority -50)
		(overlay-put overlay 'window window)
		(push overlay my/column-highlight-overlays)))

;; every visible line but the cursor line, screen line motion skips folded text
(defun my/column-highlight-draw (&optional window start)
	(let ((window (or window (selected-window))))
		(when (and (eq window (selected-window))
							 (eq (window-buffer window) (current-buffer)))
			(my/column-highlight-clear)
			(let ((column (current-column))
						(cursor-line (line-beginning-position))
						(lines (window-body-height window))
						(more t))
				(save-excursion
					(goto-char (or start (window-start window)))
					(while (and more (> lines 0))
						(unless (= (point) cursor-line)
							(save-excursion (my/column-highlight-line column window)))
						(setq lines (1- lines)
									more (= (vertical-motion 1 window) 1))))))))

;; commands move the cursor or edit, scrolling shows other lines without one, a mode change drops the overlay list
(define-minor-mode my/column-highlight-mode
	"Highlight the cursor column in the selected window."
	:lighter nil
	(my/column-highlight-clear)
	(if my/column-highlight-mode
			(progn
				(add-hook 'post-command-hook #'my/column-highlight-draw nil t)
				(add-hook 'window-scroll-functions #'my/column-highlight-draw nil t)
				(add-hook 'change-major-mode-hook #'my/column-highlight-clear nil t)
				(my/column-highlight-draw))
		(remove-hook 'post-command-hook #'my/column-highlight-draw t)
		(remove-hook 'window-scroll-functions #'my/column-highlight-draw t)
		(remove-hook 'change-major-mode-hook #'my/column-highlight-clear t)))

;; code, text and conf buffers only, global versions would also hit dashboard, magit and pdfs
(dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook))
	(add-hook hook #'display-line-numbers-mode)
	(add-hook hook #'my/truncate-lines)
	(add-hook hook #'hl-line-mode)
	(add-hook hook #'my/column-highlight-mode))
