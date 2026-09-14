;;; pdf.el --- PDF reader -*- lexical-binding: t; -*-

;; big pdfs open without the 'file is large' prompt, added at startup so the first pdf skips it too
(defun my/pdf-skip-large-file-prompt (fn size op-type filename &optional offer-raw)
  (unless (and (stringp filename)
               (let ((case-fold-search t))
                 (string-match-p "\\.pdf\\'" filename)))
    (funcall fn size op-type filename offer-raw)))

(advice-add 'abort-if-file-too-large :around #'my/pdf-skip-large-file-prompt)

;; without epdfinfo the pdf opens as plain text with a hint instead of pdf view errors
(defun my/pdf-require-epdfinfo (fn &rest args)
  (if (or (pdf-info-running-p)
          (ignore-errors (pdf-info-check-epdfinfo) t))
      (apply fn args)
    (fundamental-mode)
    (message "Reading pdfs needs epdfinfo, run M-x pdf-tools-install to build it")))

;; closing a pdf also closes its annotation list and annotation contents
(defun my/pdf-kill-annot-buffers ()
  (when (buffer-live-p (bound-and-true-p pdf-annot-list-buffer))
    (kill-buffer pdf-annot-list-buffer))
  (when-let* ((contents (get-buffer "*Contents*")))
    (kill-buffer contents)))

(defun my/pdf-add-cleanup-hook ()
  (add-hook 'kill-buffer-hook #'my/pdf-kill-annot-buffers nil t))

;; no evil cursor drawn over the page, it makes the pdf flicker
(defun my/pdf-hide-evil-cursor ()
  (setq-local evil-normal-state-cursor (list nil)))

;; annotation list window without a mode line
(defun my/pdf-hide-mode-line ()
  (setq-local mode-line-format nil))

;; themes set midnight colors through this, pdfs in midnight mode get repainted with the new ones
(defun my/pdf-set-midnight-colors (symbol value)
  (set-default symbol value)
  (dolist (buffer (buffer-list))
    (with-current-buffer buffer
      (when (bound-and-true-p pdf-view-midnight-minor-mode)
        (pdf-view-midnight-minor-mode 1)))))

;; pdf links load org pdftools only when epdfinfo works, store only runs in pdf buffers so other org links never load it
(defun my/pdf-org-link (fn &optional pdf-buffers-only)
  (lambda (&rest args)
    (when (and (or (not pdf-buffers-only)
                   (derived-mode-p 'pdf-view-mode))
               (ignore-errors (require 'org-pdftools nil t))
               (file-executable-p pdf-info-epdfinfo-program))
      (apply fn args))))

(use-package pdf-tools
  ;; loads on the first pdf, found by file name or by the pdf header inside the file
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :magic ("%PDF" . pdf-view-mode)
  :custom
  ;; whole page visible when a pdf opens
  (pdf-view-display-size 'fit-page)
  ;; outline opens on the right side
  (pdf-outline-display-buffer-action '(display-buffer-in-side-window
                                       (side . right)
                                       (window-width . 40)))
  :config
  (advice-add 'pdf-view-mode :around #'my/pdf-require-epdfinfo)
  ;; registers pdf files and minor modes without checking or building epdfinfo
  (pdf-tools-install-noverify)
  (add-hook 'pdf-view-mode-hook #'my/pdf-add-cleanup-hook)
  (add-hook 'pdf-view-mode-hook #'my/pdf-hide-evil-cursor)
  (add-hook 'pdf-annot-list-mode-hook #'my/pdf-hide-mode-line)
  (put 'pdf-view-midnight-colors 'custom-set #'my/pdf-set-midnight-colors)
  ;; q closes the pdf
  (define-key pdf-view-mode-map (kbd "q") #'kill-current-buffer)
  (with-eval-after-load 'evil
    (evil-define-key 'normal pdf-view-mode-map (kbd "q") #'kill-current-buffer)))

;; remembers page and zoom per pdf through save place mode
(use-package saveplace-pdf-view
  :after pdf-view)

(use-package org-pdftools
  :defer t
  :init
  (with-eval-after-load 'org
    (org-link-set-parameters "pdf"
                             :follow (my/pdf-org-link #'org-pdftools-open)
                             :complete (my/pdf-org-link #'org-pdftools-complete-link)
                             :store (my/pdf-org-link #'org-pdftools-store-link t)
                             :export (my/pdf-org-link #'org-pdftools-export))))
