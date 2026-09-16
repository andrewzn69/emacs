;;; editor.el --- General editing behaviour -*- lexical-binding: t; -*-

;; defaults, local.el can override them
;; relative so line motion counts read off the gutter, t or visual also work
(defvar my/line-numbers-type 'relative)
(defvar my/tab-width 2)

;; reopening a file puts the cursor back where it was, positions saved in the state dir
(save-place-mode 1)

(setq display-line-numbers-type my/line-numbers-type)
;; width counted from the buffer lines up front so text doesnt shift when a longer number scrolls into view
(setq display-line-numbers-width-start t)

(setq-default tab-width my/tab-width)

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

;; the cell painted onto whatever is drawn at the spot already, indent guides claim the same characters
(defun my/column-highlight-cell (base offset width)
	(let* ((newline (and base (string-suffix-p "\n" base)))
				 (body (cond (newline (substring base 0 -1))
										 (base base)
										 (t "")))
				 (need (max (1+ offset) (or width 0)))
				 (cell (concat body (make-string (max 0 (- need (length body))) ?\s))))
		(add-face-text-property offset (1+ offset) 'my/column-highlight t cell)
		(if newline (concat cell "\n") cell)))

;; cell at the column on the line at point
(defun my/column-highlight-line (column window)
	(let* ((eol (line-end-position))
				 (reached (move-to-column column))
				 (overlay nil))
		;; a guide bar drawn on the newline is one atomic string and column motion crosses the line end inside it
		(when (> (point) eol)
			(goto-char eol)
			(setq reached (current-column)))
		(cond
		 ;; a tab spans several columns, the column either sits on it or inside it
		 ((or (and (= reached column) (eq (char-after) ?\t))
					(and (> reached column) (eq (char-before) ?\t)))
			;; point stops on a tab that starts at the column, past one it runs into
			(when (= reached column)
				(forward-char))
			;; drawn as spaces so only the cell at the column is colored
			(let ((start (save-excursion (backward-char) (current-column)))
						(end (current-column))
						;; a guide bar may already sit inside this tab
						(base (get-char-property (1- (point)) 'display)))
				(setq overlay (make-overlay (1- (point)) (point)))
				(overlay-put overlay 'display
										 (my/column-highlight-cell (and (stringp base) base)
																							 (- column start)
																							 (- end start)))))
		 ;; a wide character keeps its glyph so the whole character is colored
		 ((> reached column)
			(setq overlay (make-overlay (1- (point)) (point)))
			(overlay-put overlay 'face 'my/column-highlight))
		 ;; line ends before the column, padding and one colored cell after it
		 ((eolp)
			;; a blank line carries only its newline and the guides draw their bars on it
			(let ((base (and (not (eobp)) (get-char-property (point) 'display))))
				(if (stringp base)
						(progn
							(setq overlay (make-overlay (point) (1+ (point))))
							(overlay-put overlay 'display
													 (my/column-highlight-cell base (- column reached) nil)))
					(setq overlay (make-overlay (point) (point)))
					(overlay-put overlay 'after-string
											 (my/column-highlight-cell nil (- column reached) nil)))))
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

;; indent guides, the theme sets both colors
(defface my/indent-bar
	'((t :inherit shadow))
	"Face for the indent guides.")

(defface my/indent-bar-current
	'((t :inherit shadow))
	"Face for the indent guide at the current depth.")

;; code and config files, indentation carries no structure in prose
(use-package indent-bars
	:custom
	;; the same vertical character the editor guides use, a drawn bar needs stipple support the build may lack
	(indent-bars-prefer-character t)
	(indent-bars-color '(my/indent-bar))
	;; one color for every level instead of a color per depth
	(indent-bars-color-by-depth nil)
	;; a bar every tab stop, the guess reads a per mode offset that is four in most modes
	(indent-bars-spacing-override my/tab-width)
	(indent-bars-highlight-current-depth '(:face my/indent-bar-current))
	:hook ((prog-mode . indent-bars-mode)
				 (conf-mode . indent-bars-mode)))

;; code, text and conf buffers only, global versions would also hit dashboard, magit and pdfs
(dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook))
	(add-hook hook #'display-line-numbers-mode)
	(add-hook hook #'my/truncate-lines)
	(add-hook hook #'hl-line-mode)
	(add-hook hook #'my/column-highlight-mode))
