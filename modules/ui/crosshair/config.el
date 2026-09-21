;;; config.el --- Cursor row and column highlight -*- lexical-binding: t; -*-

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

;; code, text and conf buffers only, global versions would also hit dashboard, magit and pdfs
(dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook))
	(add-hook hook #'hl-line-mode)
	(add-hook hook #'my/column-highlight-mode))

;; org draws with display properties so a column counted in buffer text lands elsewhere
(defun my/column-highlight-disable ()
	(my/column-highlight-mode -1))

(add-hook 'org-mode-hook #'my/column-highlight-disable)
