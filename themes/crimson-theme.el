;;; crimson-theme.el --- Crimson theme -*- lexical-binding: t; -*-

(deftheme crimson "Dark theme with the crimson palette.")

(let (;; nvim colorscheme colors with the crimson backgrounds, grays and diff colors
			(bg0 "#171A1C")
			(bg1 "#282C2D")
			(bg2 "#4D4C44")
			(bg3 "#4D4C44")
			(bg4 "#767161")
			(fg1 "#EBDBB2")
			(fg2 "#D2C4A1")
			(fg4 "#A49B81")
			(gray "#8C8570")
			(red "#FB4934")
			(green "#98971A")
			(yellow "#D79921")
			(blue "#83A598")
			(purple "#D3869B")
			(aqua "#8EC07C")
			(orange "#FE8019")
			(neutral-red "#CC241D")
			(neutral-green "#98971A")
			(neutral-yellow "#D79921")
			(neutral-blue "#458588")
			(neutral-purple "#B16286")
			(neutral-aqua "#689D6A")
			(dark-red "#452925")
			(dark-green "#2F3223")
			(dark-aqua "#362F24")
			;; crimson colors from the nvim overrides and the status line
			(coral "#B36656")
			(coral-bg "#3D2D2B")
			(surface0 "#232628")
			(surface2 "#2F3131"))

	(custom-theme-set-faces
	 'crimson

	 ;; absolute essentials
	 `(default ((t :foreground ,fg1 :background ,bg0)))                    ; Normal
	 `(cursor ((t :background ,fg2)))                                       ; terminal cursor
	 `(fringe ((t :background ,bg0)))                                       ; SignColumn

	 ;; basic and ungrouped styles
	 `(hl-line ((t :background ,bg1 :extend t)))                            ; CursorLine
	 `(region ((t :background ,bg3)))                                       ; Visual
	 `(secondary-selection ((t :background ,bg3)))                          ; VisualNOS
	 `(highlight ((t :background ,bg1)))                                    ; CursorLine
	 `(shadow ((t :foreground ,gray)))                                      ; GruvboxGray
	 `(fill-column-indicator ((t :foreground ,bg1)))                        ; ColorColumn
	 `(escape-glyph ((t :foreground ,fg4)))                                 ; SpecialKey
	 `(nobreak-space ((t :foreground ,fg4 :underline t)))                   ; SpecialKey
	 `(trailing-whitespace ((t :background ,red)))                          ; MiniTrailspace
	 `(error ((t :foreground ,red :weight bold)))                           ; GruvboxRedBold
	 `(warning ((t :foreground ,yellow :weight bold)))                      ; GruvboxYellowBold
	 `(success ((t :foreground ,green :weight bold)))                       ; GruvboxGreenBold
	 `(tooltip ((t :foreground ,fg1 :background ,surface0)))                ; NormalFloat
	 `(child-frame-border ((t :background ,surface0)))                      ; FloatBorder
	 ;; a box in the background color reads as padding and lifts the row off the text
	 `(header-line ((t :foreground ,fg4 :background ,bg0
										 :box (:line-width (8 . 4) :color ,bg0))))          ; WinBar
	 `(minibuffer-prompt ((t :foreground ,red)))                            ; TelescopePromptPrefix
	 ;; `(nobreak-hyphen ((t )))
	 ;; `(header-line-highlight ((t )))
	 ;; `(header-line-inactive ((t )))
	 ;; `(minibuffer-depth-indicator ((t )))

	 ;; buttons links and widgets
	 `(link ((t :foreground ,blue :underline t)))                           ; Underlined
	 `(button ((t :foreground ,blue :underline t)))                         ; Underlined
	 ;; `(link-visited ((t )))

	 ;; ansi-color
	 `(ansi-color-black ((t :foreground ,bg0 :background ,bg0)))
	 `(ansi-color-red ((t :foreground ,neutral-red :background ,neutral-red)))
	 `(ansi-color-green ((t :foreground ,neutral-green :background ,neutral-green)))
	 `(ansi-color-yellow ((t :foreground ,neutral-yellow :background ,neutral-yellow)))
	 `(ansi-color-blue ((t :foreground ,neutral-blue :background ,neutral-blue)))
	 `(ansi-color-magenta ((t :foreground ,neutral-purple :background ,neutral-purple)))
	 `(ansi-color-cyan ((t :foreground ,neutral-aqua :background ,neutral-aqua)))
	 `(ansi-color-white ((t :foreground ,fg4 :background ,fg4)))
	 `(ansi-color-bright-black ((t :foreground ,gray :background ,gray)))
	 `(ansi-color-bright-red ((t :foreground ,red :background ,red)))
	 `(ansi-color-bright-green ((t :foreground ,green :background ,green)))
	 `(ansi-color-bright-yellow ((t :foreground ,yellow :background ,yellow)))
	 `(ansi-color-bright-blue ((t :foreground ,blue :background ,blue)))
	 `(ansi-color-bright-magenta ((t :foreground ,purple :background ,purple)))
	 `(ansi-color-bright-cyan ((t :foreground ,aqua :background ,aqua)))
	 `(ansi-color-bright-white ((t :foreground ,fg1 :background ,fg1)))
	 ;; `(ansi-color-bold ((t )))

	 ;; compilation
	 `(compilation-error ((t :foreground ,red)))                            ; DiagnosticSignError
	 `(compilation-warning ((t :foreground ,yellow)))                       ; DiagnosticSignWarn
	 `(compilation-info ((t :foreground ,blue)))                            ; DiagnosticSignInfo
	 ;; `(compilation-line-number ((t )))
	 ;; `(compilation-column-number ((t )))
	 ;; `(compilation-mode-line-exit ((t )))
	 ;; `(compilation-mode-line-fail ((t )))
	 ;; `(compilation-mode-line-run ((t )))

	 ;; completions
	 `(completions-common-part ((t :foreground ,orange)))                   ; TelescopeMatching
	 `(completions-highlight ((t :background ,bg1)))                        ; TelescopeSelection
	 `(completions-annotations ((t :foreground ,gray)))                     ; CmpItemMenu
	 ;; `(completions-first-difference ((t )))

	 ;; corfu
	 `(corfu-default ((t :background ,bg0)))                                ; NormalFloat
	 `(corfu-current ((t :background ,coral-bg :extend t)))                 ; PmenuSel
	 `(corfu-border ((t :background ,coral)))                               ; FloatBorder
	 `(corfu-bar ((t :background ,bg4)))                                    ; PmenuThumb
	 ;; `(corfu-candidate-overlay-face ((t )))
	 ;; `(corfu-quick1 ((t )))
	 ;; `(corfu-quick2 ((t )))

	 ;; dashboard
	 `(dashboard-text-banner ((t :foreground ,fg1)))                        ; alpha header
	 `(dashboard-banner-logo-title ((t :foreground ,fg1)))                  ; alpha header
	 `(dashboard-heading ((t :foreground ,fg1)))                            ; alpha buttons
	 `(dashboard-items-face ((t :foreground ,fg1)))                         ; alpha buttons
	 `(dashboard-footer-face ((t :foreground ,orange)))                     ; alpha footer
	 `(dashboard-footer-icon-face ((t :foreground ,orange)))                ; alpha footer

	 ;; diff-mode
	 `(diff-added ((t :background ,dark-green :extend t)))                  ; DiffAdd
	 `(diff-removed ((t :background ,dark-red :extend t)))                  ; DiffDelete
	 `(diff-changed ((t :background ,dark-aqua :extend t)))                 ; DiffChange
	 `(diff-refine-added ((t :foreground ,bg0 :background ,yellow)))        ; DiffText
	 `(diff-refine-removed ((t :foreground ,bg0 :background ,yellow)))      ; DiffText
	 `(diff-refine-changed ((t :foreground ,bg0 :background ,yellow)))      ; DiffText
	 `(diff-file-header ((t :foreground ,orange)))                          ; diffFile
	 `(diff-header ((t :foreground ,blue)))                                 ; diffLine
	 `(diff-hunk-header ((t :foreground ,blue)))                            ; diffLine
	 `(diff-index ((t :background ,dark-aqua :extend t)))                   ; diffIndexLine
	 ;; `(diff-context ((t )))
	 ;; `(diff-changed-unspecified ((t )))
	 ;; `(diff-indicator-added ((t )))
	 ;; `(diff-indicator-changed ((t )))
	 ;; `(diff-indicator-removed ((t )))
	 ;; `(diff-error ((t )))
	 ;; `(diff-function ((t )))
	 ;; `(diff-nonexistent ((t )))

	 ;; doom-modeline
	 `(doom-modeline-panel ((t :foreground ,fg4 :background ,surface2)))    ; lualine section b
	 `(doom-modeline-evil-normal-state ((t :foreground ,bg0 :background ,coral :weight bold)))            ; lualine normal section a
	 `(doom-modeline-evil-operator-state ((t :foreground ,bg0 :background ,coral :weight bold)))          ; lualine normal section a
	 `(doom-modeline-evil-motion-state ((t :foreground ,bg0 :background ,coral :weight bold)))            ; lualine normal section a
	 `(doom-modeline-evil-insert-state ((t :foreground ,bg0 :background ,neutral-blue :weight bold)))     ; lualine insert section a
	 `(doom-modeline-evil-visual-state ((t :foreground ,bg0 :background ,neutral-yellow :weight bold)))   ; lualine visual section a
	 `(doom-modeline-evil-replace-state ((t :foreground ,bg0 :background ,neutral-red :weight bold)))     ; lualine replace section a
	 `(doom-modeline-evil-emacs-state ((t :foreground ,bg0 :background ,neutral-purple :weight bold)))    ; lualine command section a
	 `(doom-modeline-urgent ((t :foreground ,red :weight bold)))            ; DiagnosticError
	 `(doom-modeline-warning ((t :foreground ,yellow :weight bold)))        ; DiagnosticWarn
	 `(doom-modeline-info ((t :foreground ,green :weight bold)))            ; DiagnosticOk

	 ;; evil-mode
	 `(evil-ex-lazy-highlight ((t :foreground ,fg1 :background ,coral-bg))) ; Search
	 `(evil-ex-substitute-matches ((t :foreground ,fg1 :background ,coral-bg))) ; Search
	 `(evil-ex-substitute-replacement ((t :foreground ,bg0 :background ,coral))) ; IncSearch
	 ;; `(evil-ex-commands ((t )))
	 ;; `(evil-ex-info ((t )))
	 ;; `(evil-ex-search ((t )))

	 ;; flymake
	 `(flymake-error ((t :underline (:style wave :color ,red))))            ; DiagnosticUnderlineError
	 `(flymake-warning ((t :underline (:style wave :color ,yellow))))       ; DiagnosticUnderlineWarn
	 `(flymake-note ((t :underline (:style wave :color ,blue))))            ; DiagnosticUnderlineInfo
	 ;; `(flymake-error-echo ((t )))
	 ;; `(flymake-warning-echo ((t )))
	 ;; `(flymake-note-echo ((t )))
	 ;; `(flymake-error-echo-at-eol ((t )))
	 ;; `(flymake-warning-echo-at-eol ((t )))
	 ;; `(flymake-note-echo-at-eol ((t )))
	 ;; `(flymake-error-fringe ((t )))
	 ;; `(flymake-warning-fringe ((t )))
	 ;; `(flymake-note-fringe ((t )))
	 ;; `(flymake-end-of-line-diagnostics-face ((t )))

	 ;; font-lock
	 `(font-lock-comment-face ((t :foreground ,gray :slant italic)))        ; Comment
	 `(font-lock-comment-delimiter-face ((t :inherit font-lock-comment-face))) ; Comment
	 `(font-lock-doc-face ((t :foreground ,green :slant italic)))           ; String
	 `(font-lock-doc-markup-face ((t :foreground ,orange)))                 ; SpecialComment
	 `(font-lock-keyword-face ((t :foreground ,red)))                       ; Keyword
	 `(font-lock-builtin-face ((t :foreground ,orange)))                    ; Special
	 `(font-lock-function-name-face ((t :foreground ,green :weight bold)))   ; Function
	 `(font-lock-function-call-face ((t :foreground ,green :weight bold)))  ; Function
	 `(font-lock-variable-name-face ((t :foreground ,fg1)))                 ; @variable
	 `(font-lock-variable-use-face ((t :foreground ,fg1)))                  ; @variable
	 `(font-lock-property-name-face ((t :foreground ,blue)))                ; Identifier
	 `(font-lock-property-use-face ((t :foreground ,blue)))                 ; Identifier
	 `(font-lock-type-face ((t :foreground ,yellow)))                       ; Type
	 `(font-lock-constant-face ((t :foreground ,purple)))                   ; Constant
	 `(font-lock-number-face ((t :foreground ,purple)))                     ; Number
	 `(font-lock-string-face ((t :foreground ,green :slant italic)))        ; String
	 `(font-lock-escape-face ((t :foreground ,orange)))                     ; SpecialChar
	 `(font-lock-regexp-face ((t :foreground ,green :slant italic)))        ; String
	 `(font-lock-regexp-grouping-backslash ((t :foreground ,orange)))       ; SpecialChar
	 `(font-lock-regexp-grouping-construct ((t :foreground ,orange)))       ; SpecialChar
	 `(font-lock-preprocessor-face ((t :foreground ,aqua)))                 ; PreProc
	 `(font-lock-negation-char-face ((t :foreground ,orange)))              ; Operator
	 `(font-lock-operator-face ((t :foreground ,orange)))                   ; Operator
	 `(font-lock-punctuation-face ((t :foreground ,orange)))                ; Delimiter
	 `(font-lock-bracket-face ((t :foreground ,orange)))                    ; Delimiter
	 `(font-lock-delimiter-face ((t :foreground ,orange)))                  ; Delimiter
	 `(font-lock-misc-punctuation-face ((t :foreground ,orange)))           ; Delimiter
	 `(font-lock-warning-face ((t :foreground ,red :weight bold)))          ; WarningMsg

	 ;; indent-bars
	 `(my/indent-bar ((t :foreground ,bg2)))                                ; IblIndent
	 `(my/indent-bar-current ((t :foreground ,fg4)))                        ; MiniIndentscopeSymbol

	 ;; isearch, occur and the like
	 `(isearch ((t :foreground ,bg0 :background ,coral)))                   ; IncSearch
	 `(isearch-fail ((t :foreground ,bg0 :background ,red :weight bold)))   ; ErrorMsg
	 `(lazy-highlight ((t :foreground ,fg1 :background ,coral-bg)))         ; Search
	 `(match ((t :foreground ,fg1 :background ,coral-bg)))                  ; Search
	 ;; `(isearch-group-1 ((t )))
	 ;; `(isearch-group-2 ((t )))

	 ;; line numbers
	 `(line-number ((t :foreground ,bg4)))                                  ; LineNr
	 `(line-number-current-line ((t :foreground ,yellow :background ,bg1))) ; CursorLineNr
	 ;; `(line-number-major-tick ((t )))
	 ;; `(line-number-minor-tick ((t )))

	 ;; lsp
	 `(lsp-headerline-breadcrumb-path-face ((t :foreground ,fg1)))          ; NavicText
	 `(lsp-headerline-breadcrumb-symbols-face ((t :foreground ,fg1 :weight bold))) ; NavicText
	 ;; `(lsp-headerline-breadcrumb-separator-face ((t )))
	 ;; `(lsp-headerline-breadcrumb-project-prefix-face ((t )))
	 ;; `(lsp-headerline-breadcrumb-unknown-project-prefix-face ((t )))
	 ;; `(lsp-headerline-breadcrumb-path-error-face ((t )))
	 ;; `(lsp-headerline-breadcrumb-path-warning-face ((t )))
	 ;; `(lsp-headerline-breadcrumb-path-info-face ((t )))
	 ;; `(lsp-headerline-breadcrumb-path-hint-face ((t )))
	 ;; `(lsp-headerline-breadcrumb-symbols-error-face ((t )))
	 ;; `(lsp-headerline-breadcrumb-symbols-warning-face ((t )))
	 ;; `(lsp-headerline-breadcrumb-symbols-info-face ((t )))
	 ;; `(lsp-headerline-breadcrumb-symbols-hint-face ((t )))
	 ;; `(lsp-modeline-code-actions-face ((t )))
	 ;; `(lsp-modeline-code-actions-preferred-face ((t )))
	 ;; `(lsp-signature-posframe ((t )))
	 ;; `(lsp-face-rename ((t )))
	 ;; `(lsp-details-face ((t )))
	 ;; `(lsp-lens-mouse-face ((t )))

	 ;; lsp-ui
	 `(lsp-ui-doc-background ((t :background ,bg0)))                        ; NormalFloat
	 ;; `(lsp-ui-doc-header ((t )))
	 ;; `(lsp-ui-peek-filename ((t )))
	 ;; `(lsp-ui-peek-header ((t )))
	 ;; `(lsp-ui-peek-highlight ((t )))
	 ;; `(lsp-ui-peek-line-number ((t )))
	 ;; `(lsp-ui-peek-list ((t )))
	 ;; `(lsp-ui-peek-peek ((t )))
	 ;; `(lsp-ui-peek-selection ((t )))
	 ;; `(lsp-ui-sideline-code-action ((t )))
	 ;; `(lsp-ui-sideline-current-symbol ((t )))
	 ;; `(lsp-ui-sideline-symbol ((t )))
	 ;; `(lsp-ui-sideline-symbol-info ((t )))

	 ;; magit
	 `(magit-section-highlight ((t :background ,bg1 :extend t)))            ; CursorLine
	 `(magit-section-heading ((t :foreground ,green :weight bold)))         ; Title
	 `(magit-diff-file-heading ((t :foreground ,orange)))                   ; diffFile
	 `(magit-diff-file-heading-highlight ((t :foreground ,orange :background ,bg1 :extend t))) ; diffFile
	 `(magit-diff-hunk-heading ((t :foreground ,blue :extend t)))           ; diffLine
	 `(magit-diff-hunk-heading-highlight ((t :foreground ,blue :background ,bg1 :extend t))) ; diffLine
	 `(magit-diff-context ((t :foreground ,fg1 :extend t)))                 ; Normal
	 `(magit-diff-context-highlight ((t :foreground ,fg1 :background ,bg1 :extend t))) ; CursorLine
	 `(magit-diff-added ((t :background ,dark-green :extend t)))            ; DiffAdd
	 `(magit-diff-added-highlight ((t :background ,dark-green :extend t)))  ; DiffAdd
	 `(magit-diff-removed ((t :background ,dark-red :extend t)))            ; DiffDelete
	 `(magit-diff-removed-highlight ((t :background ,dark-red :extend t)))  ; DiffDelete
	 `(magit-diff-base ((t :background ,dark-aqua :extend t)))              ; DiffChange
	 `(magit-diff-base-highlight ((t :background ,dark-aqua :extend t)))    ; DiffChange
	 `(magit-diffstat-added ((t :foreground ,green)))                       ; GitSignsAdd
	 `(magit-diffstat-removed ((t :foreground ,red)))                       ; GitSignsDelete
	 `(magit-branch-local ((t :foreground ,blue)))                          ; Identifier
	 `(magit-branch-remote ((t :foreground ,green)))                        ; GruvboxGreen
	 `(magit-hash ((t :foreground ,gray)))                                  ; GruvboxGray
	 `(magit-log-author ((t :foreground ,orange)))                          ; Special
	 `(magit-log-date ((t :foreground ,gray)))                              ; GruvboxGray
	 ;; `(magit-section ((t )))
	 ;; `(magit-section-heading-selection ((t )))
	 ;; `(magit-section-secondary-heading ((t )))
	 ;; `(magit-diff-file-heading-selection ((t )))
	 ;; `(magit-diff-hunk-heading-selection ((t )))
	 ;; `(magit-diff-hunk-region ((t )))
	 ;; `(magit-diff-lines-boundary ((t )))
	 ;; `(magit-diff-lines-heading ((t )))
	 ;; `(magit-dimmed ((t )))
	 ;; `(magit-filename ((t )))
	 ;; `(magit-head ((t )))
	 ;; `(magit-branch-upstream ((t )))
	 ;; `(magit-branch-warning ((t )))
	 ;; `(magit-tag ((t )))
	 ;; `(magit-refname ((t )))
	 ;; `(magit-refname-pullreq ((t )))
	 ;; `(magit-refname-stash ((t )))
	 ;; `(magit-refname-wip ((t )))
	 ;; `(magit-keyword ((t )))
	 ;; `(magit-keyword-squash ((t )))
	 ;; `(magit-log-graph ((t )))
	 ;; `(magit-header-line ((t )))
	 ;; `(magit-header-line-key ((t )))
	 ;; `(magit-header-line-log-select ((t )))
	 ;; `(magit-mode-line-process ((t )))
	 ;; `(magit-mode-line-process-error ((t )))
	 ;; `(magit-process-ok ((t )))
	 ;; `(magit-process-ng ((t )))
	 ;; `(magit-bisect-good ((t )))
	 ;; `(magit-bisect-bad ((t )))
	 ;; `(magit-bisect-skip ((t )))
	 ;; `(magit-blame-name ((t )))
	 ;; `(magit-blame-date ((t )))
	 ;; `(magit-blame-hash ((t )))
	 ;; `(magit-blame-summary ((t )))
	 ;; `(magit-blame-highlight ((t )))
	 ;; `(magit-blame-dimmed ((t )))
	 ;; `(magit-cherry-equivalent ((t )))
	 ;; `(magit-cherry-unmatched ((t )))
	 ;; `(magit-reflog-commit ((t )))
	 ;; `(magit-reflog-amend ((t )))
	 ;; `(magit-reflog-merge ((t )))
	 ;; `(magit-reflog-checkout ((t )))
	 ;; `(magit-reflog-reset ((t )))
	 ;; `(magit-reflog-rebase ((t )))
	 ;; `(magit-reflog-cherry-pick ((t )))
	 ;; `(magit-reflog-remote ((t )))
	 ;; `(magit-reflog-other ((t )))
	 ;; `(magit-sequence-pick ((t )))
	 ;; `(magit-sequence-stop ((t )))
	 ;; `(magit-sequence-part ((t )))
	 ;; `(magit-sequence-head ((t )))
	 ;; `(magit-sequence-drop ((t )))
	 ;; `(magit-sequence-done ((t )))
	 ;; `(magit-sequence-onto ((t )))
	 ;; `(magit-sequence-exec ((t )))
	 ;; `(magit-signature-good ((t )))
	 ;; `(magit-signature-bad ((t )))
	 ;; `(magit-signature-untrusted ((t )))
	 ;; `(magit-signature-expired ((t )))
	 ;; `(magit-signature-expired-key ((t )))
	 ;; `(magit-signature-revoked ((t )))
	 ;; `(magit-signature-error ((t )))

	 ;; mode line
	 `(mode-line ((t :foreground ,fg4 :background ,surface0 :box nil)))     ; lualine section c
	 `(mode-line-active ((t :inherit mode-line)))
	 `(mode-line-inactive ((t :foreground ,fg4 :background ,surface0 :box nil))) ; lualine inactive
	 ;; `(mode-line-buffer-id ((t )))
	 ;; `(mode-line-emphasis ((t )))
	 ;; `(mode-line-highlight ((t )))

	 ;; orderless
	 ;; `(orderless-match-face-0 ((t )))
	 ;; `(orderless-match-face-1 ((t )))
	 ;; `(orderless-match-face-2 ((t )))
	 ;; `(orderless-match-face-3 ((t )))

	 ;; org
	 ;; heading levels are styled under outline, org inherits them
	 `(org-document-title ((t :foreground ,coral :weight bold)))            ; @markup.heading
	 `(org-document-info ((t :foreground ,fg1)))                            ; @markup
	 `(org-document-info-keyword ((t :foreground ,aqua)))                   ; @keyword.directive
	 `(org-meta-line ((t :foreground ,aqua)))                               ; @keyword.directive
	 `(org-block-begin-line ((t :foreground ,aqua :extend t)))              ; @keyword.directive
	 `(org-block-end-line ((t :foreground ,aqua :extend t)))                ; @keyword.directive
	 `(org-block ((t :foreground ,fg1 :extend t)))                          ; @markup
	 `(org-code ((t :foreground ,green :slant italic)))                     ; @markup.raw
	 `(org-verbatim ((t :foreground ,green :slant italic)))                 ; @markup.raw
	 `(org-link ((t :foreground ,blue :underline t)))                       ; @markup.link
	 `(org-footnote ((t :foreground ,blue :underline t)))                   ; @markup.link
	 `(org-todo ((t :foreground ,bg0 :background ,yellow :weight bold :slant italic))) ; Todo
	 `(org-done ((t :foreground ,orange :weight bold :slant italic)))       ; Done
	 `(org-checkbox ((t :foreground ,orange)))                              ; @markup.list
	 `(org-list-dt ((t :foreground ,orange)))                               ; @markup.list
	 `(org-table ((t :foreground ,fg1)))                                    ; @markup
	 `(org-date ((t :foreground ,purple)))                                  ; Constant
	 `(org-formula ((t :foreground ,orange)))                               ; @markup.math
	 `(org-tag ((t :foreground ,gray :weight bold)))                        ; GruvboxGray
	 `(org-special-keyword ((t :foreground ,gray :slant italic)))           ; Comment
	 `(org-drawer ((t :foreground ,gray :slant italic)))                    ; Comment
	 `(org-ellipsis ((t :foreground ,gray :background ,bg1 :slant italic))) ; Folded

	 ;; org-modern
	 ;; the label parent is left alone, it carries font metrics rather than color
	 `(org-modern-tag ((t :inherit org-modern-label :foreground ,fg1 :background ,surface2)))
	 ;; set outright because the inherited inverse video expects a foreground only todo face
	 ;; the cursor line paints over the fill so the dark text needs a light fallback
	 `(org-modern-todo ((t :inherit org-modern-label :foreground ,bg0 :background ,yellow :distant-foreground ,yellow :weight semibold)))
	 `(org-modern-done ((t :inherit org-modern-label :foreground ,gray :background ,bg1)))
	 `(org-modern-priority ((t :inherit org-modern-label :foreground ,bg0 :background ,red :distant-foreground ,red :weight semibold)))
	 `(org-modern-date-active ((t :inherit org-modern-label :foreground ,fg1 :background ,surface2)))
	 `(org-modern-time-active ((t :inherit org-modern-label :foreground ,bg0 :background ,coral :distant-foreground ,coral :weight semibold)))
	 `(org-modern-date-inactive ((t :inherit org-modern-label :foreground ,fg4 :background ,bg1)))
	 `(org-modern-time-inactive ((t :inherit org-modern-label :foreground ,fg4 :background ,bg1)))
	 `(org-modern-progress-complete ((t :foreground ,bg0 :background ,green :distant-foreground ,green)))
	 `(org-modern-progress-incomplete ((t :foreground ,fg4 :background ,bg1)))
	 `(org-modern-horizontal-rule ((t :underline ,surface2 :extend t)))
	 ;; `(org-modern-symbol ((t )))
	 ;; `(org-modern-block-name ((t )))
	 ;; `(org-modern-habit ((t )))
	 ;; `(org-modern-internal-target ((t )))
	 ;; `(org-modern-radio-target ((t )))

	 ;; outline
	 ;; org level faces inherit these so markdown and info headings match
	 ;; the top three carry a size step, deeper ones stay at body size
	 `(outline-1 ((t :foreground ,red :weight bold :height 1.3)))           ; @markup.heading
	 `(outline-2 ((t :foreground ,orange :weight bold :height 1.2)))
	 `(outline-3 ((t :foreground ,yellow :weight normal :height 1.1)))
	 `(outline-4 ((t :foreground ,green :weight normal)))
	 `(outline-5 ((t :foreground ,blue :weight normal)))
	 `(outline-6 ((t :foreground ,purple :weight normal)))
	 `(outline-7 ((t :foreground ,aqua :weight normal)))
	 `(outline-8 ((t :foreground ,gray :weight normal)))

	 ;; show-paren-mode
	 `(show-paren-match ((t :background ,bg3 :weight bold)))                ; MatchParen
	 `(show-paren-mismatch ((t :foreground ,red :weight bold :inverse-video t))) ; Error
	 ;; `(show-paren-match-expression ((t )))

	 ;; tab-bar-mode
	 `(tab-bar ((t :foreground ,bg4 :background ,bg1)))                     ; TabLineFill
	 `(tab-bar-tab ((t :foreground ,green :background ,bg1)))               ; TabLineSel
	 `(tab-bar-tab-inactive ((t :foreground ,bg4 :background ,bg1)))        ; TabLine
	 ;; `(tab-bar-tab-group-current ((t )))
	 ;; `(tab-bar-tab-group-inactive ((t )))
	 ;; `(tab-bar-tab-highlight ((t )))
	 ;; `(tab-bar-tab-ungrouped ((t )))

	 ;; tab-line-mode
	 `(tab-line ((t :foreground ,bg4 :background ,bg1)))                    ; TabLineFill
	 ;; `(tab-line-tab ((t )))
	 ;; `(tab-line-tab-current ((t )))
	 ;; `(tab-line-tab-inactive ((t )))
	 ;; `(tab-line-tab-modified ((t )))
	 ;; `(tab-line-highlight ((t )))
	 ;; `(tab-line-close-highlight ((t )))

	 ;; vertico
	 ;; `(vertico-current ((t )))

	 ;; which-key
	 `(which-key-key-face ((t :foreground ,green :weight bold)))            ; WhichKey
	 `(which-key-separator-face ((t :foreground ,gray :slant italic)))      ; WhichKeySeparator
	 `(which-key-group-description-face ((t :foreground ,red)))             ; WhichKeyGroup
	 `(which-key-command-description-face ((t :foreground ,blue)))          ; WhichKeyDesc
	 `(which-key-local-map-description-face ((t :foreground ,blue)))        ; WhichKeyDesc
	 `(which-key-note-face ((t :foreground ,gray :slant italic)))           ; WhichKeyValue
	 ;; `(which-key-highlighted-command-face ((t )))
	 ;; `(which-key-special-key-face ((t )))

	 ;; whitespace-mode
	 `(whitespace-space ((t :foreground ,bg2)))                             ; Whitespace
	 `(whitespace-tab ((t :foreground ,bg2)))                               ; Whitespace
	 `(whitespace-newline ((t :foreground ,bg2)))                           ; Whitespace
	 ;; `(whitespace-big-indent ((t )))
	 ;; `(whitespace-empty ((t )))
	 ;; `(whitespace-hspace ((t )))
	 ;; `(whitespace-indentation ((t )))
	 ;; `(whitespace-line ((t )))
	 ;; `(whitespace-space-after-tab ((t )))
	 ;; `(whitespace-space-before-tab ((t )))
	 ;; `(whitespace-trailing ((t )))

	 ;; window-divider-mode
	 `(vertical-border ((t :foreground ,surface2 :background ,bg0)))        ; WinSeparator
	 `(window-divider ((t :foreground ,surface2)))                          ; WinSeparator
	 `(window-divider-first-pixel ((t :foreground ,surface2)))              ; WinSeparator
	 `(window-divider-last-pixel ((t :foreground ,surface2))))              ; WinSeparator

	(custom-theme-set-variables
	 'crimson
	 ;; pdf pages in midnight mode use the editor text and background
	 `(pdf-view-midnight-colors '(,fg1 . ,bg0))
	 `(lsp-ui-doc-border ,coral)))                                          ; FloatBorder

(provide-theme 'crimson)

;;; crimson-theme.el ends here
