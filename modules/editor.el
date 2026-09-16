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

;; cell at the column on the line at point
(defun my/column-highlight-line (column window)
	(let ((reached (move-to-column column))
				(overlay nil))
		(cond
		 ;; a tab spans several columns, the column either sits on it or inside it
		 ((or (and (= reached column) (eq (char-after) ?\t))
					(and (> reached column) (eq (char-before) ?\t)))
			;; point stops on a tab that starts at the column, past one it runs into
			(when (= reached column)
				(forward-char))
			;; drawn as spaces so only the cell at the column is colored
			(let ((start (save-excursion (backward-char) (current-column)))
						(end (current-column)))
				(setq overlay (make-overlay (1- (point)) (point)))
				(overlay-put overlay 'display
										 (concat (make-string (- column start) ?\s)
														 (propertize " " 'face 'my/column-highlight)
														 (make-string (- end column 1) ?\s)))))
		 ;; a wide character keeps its glyph so the whole character is colored
		 ((> reached column)
			(setq overlay (make-overlay (1- (point)) (point)))
			(overlay-put overlay 'face 'my/column-highlight))
		 ;; line ends before the column, padding and one colored cell after it
		 ((eolp)
			(setq overlay (make-overlay (point) (point)))
			(overlay-put overlay 'after-string
									 (concat (make-string (- column reached) ?\s)
													 (propertize " " 'face 'my/column-highlight))))
		 (t
			(setq overlay (make-overlay (point) (1+ (point))))
			(overlay-put overlay 'face 'my/column-highlight)))
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

;; indent guides, the theme sets the color
(defface my/indent-bar
	'((t :inherit shadow))
	"Face for the indent guides.")

;; code and config files, indentation carries no structure in prose
(use-package indent-bars
	:custom
	;; the same vertical character the editor guides use, a drawn bar needs stipple support the build may lack
	(indent-bars-prefer-character t)
	(indent-bars-color '(my/indent-bar))
	;; one color for every level instead of a color per depth
	(indent-bars-color-by-depth nil)
	;; first bar at the left edge, the package would start it one indent step in
	(indent-bars-starting-column 0)
	;; a bar every two columns in every mode, guessing per mode puts them elsewhere
	(indent-bars-spacing-override 2)
	;; blank lines follow their shallower neighbour
	(indent-bars-display-on-blank-lines 'least)
	;; no depth highlight, it colors that depth on every visible line instead of the block at point
	(indent-bars-highlight-current-depth nil)
	:hook ((prog-mode . indent-bars-mode)
				 (conf-mode . indent-bars-mode)))

;; code, text and conf buffers only, global versions would also hit dashboard, magit and pdfs
(dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook))
	(add-hook hook #'display-line-numbers-mode)
	(add-hook hook #'my/truncate-lines)
	(add-hook hook #'hl-line-mode)
	(add-hook hook #'my/column-highlight-mode))
