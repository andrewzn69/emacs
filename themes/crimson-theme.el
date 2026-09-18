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

	 ;; editor
	 `(default ((t :foreground ,fg1 :background ,bg0)))                    ; Normal
	 `(cursor ((t :background ,fg2)))                                       ; terminal cursor
	 `(fringe ((t :background ,bg0)))                                       ; SignColumn
	 `(hl-line ((t :background ,bg1 :extend t)))                            ; CursorLine
	 `(region ((t :background ,bg3)))                                       ; Visual
	 `(secondary-selection ((t :background ,bg3)))                          ; VisualNOS
	 `(highlight ((t :background ,bg1)))                                    ; CursorLine
	 `(line-number ((t :foreground ,bg4)))                                  ; LineNr
	 `(line-number-current-line ((t :foreground ,yellow :background ,bg1))) ; CursorLineNr
	 `(fill-column-indicator ((t :foreground ,bg1)))                        ; ColorColumn
	 `(show-paren-match ((t :background ,bg3 :weight bold)))                ; MatchParen
	 `(show-paren-mismatch ((t :foreground ,red :weight bold :inverse-video t))) ; Error
	 `(isearch ((t :foreground ,bg0 :background ,coral)))                   ; IncSearch
	 `(isearch-fail ((t :foreground ,bg0 :background ,red :weight bold)))   ; ErrorMsg
	 `(lazy-highlight ((t :foreground ,fg1 :background ,coral-bg)))         ; Search
	 `(match ((t :foreground ,fg1 :background ,coral-bg)))                  ; Search
	 `(vertical-border ((t :foreground ,surface2 :background ,bg0)))        ; WinSeparator
	 `(window-divider ((t :foreground ,surface2)))                          ; WinSeparator
	 `(window-divider-first-pixel ((t :foreground ,surface2)))              ; WinSeparator
	 `(window-divider-last-pixel ((t :foreground ,surface2)))               ; WinSeparator
	 ;; a box in the background color reads as padding and lifts the row off the text
	 `(header-line ((t :foreground ,fg4 :background ,bg0
										 :box (:line-width (8 . 4) :color ,bg0))))          ; WinBar
	 `(tooltip ((t :foreground ,fg1 :background ,surface0)))                ; NormalFloat
	 `(child-frame-border ((t :background ,surface0)))                      ; FloatBorder
	 `(tab-bar ((t :foreground ,bg4 :background ,bg1)))                     ; TabLineFill
	 `(tab-bar-tab ((t :foreground ,green :background ,bg1)))               ; TabLineSel
	 `(tab-bar-tab-inactive ((t :foreground ,bg4 :background ,bg1)))        ; TabLine
	 `(tab-line ((t :foreground ,bg4 :background ,bg1)))                    ; TabLineFill
	 `(link ((t :foreground ,blue :underline t)))                           ; Underlined
	 `(button ((t :foreground ,blue :underline t)))                         ; Underlined
	 `(shadow ((t :foreground ,gray)))                                      ; GruvboxGray
	 `(escape-glyph ((t :foreground ,fg4)))                                 ; SpecialKey
	 `(nobreak-space ((t :foreground ,fg4 :underline t)))                   ; SpecialKey
	 `(trailing-whitespace ((t :background ,red)))                          ; MiniTrailspace
	 `(whitespace-space ((t :foreground ,bg2)))                             ; Whitespace
	 `(whitespace-tab ((t :foreground ,bg2)))                               ; Whitespace
	 `(whitespace-newline ((t :foreground ,bg2)))                           ; Whitespace
	 `(my/indent-bar ((t :foreground ,bg2)))                                ; IblIndent
	 `(my/indent-bar-current ((t :foreground ,fg4)))                        ; MiniIndentscopeSymbol
	 `(error ((t :foreground ,red :weight bold)))                           ; GruvboxRedBold
	 `(warning ((t :foreground ,yellow :weight bold)))                      ; GruvboxYellowBold
	 `(success ((t :foreground ,green :weight bold)))                       ; GruvboxGreenBold

	 ;; minibuffer completion
	 `(minibuffer-prompt ((t :foreground ,red)))                            ; TelescopePromptPrefix
	 `(completions-common-part ((t :foreground ,orange)))                   ; TelescopeMatching
	 `(completions-highlight ((t :background ,bg1)))                        ; TelescopeSelection
	 `(completions-annotations ((t :foreground ,gray)))                     ; CmpItemMenu

	 ;; mode line
	 `(mode-line ((t :foreground ,fg4 :background ,surface0 :box nil)))     ; lualine section c
	 `(mode-line-active ((t :inherit mode-line)))
	 `(mode-line-inactive ((t :foreground ,fg4 :background ,surface0 :box nil))) ; lualine inactive
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

	 ;; syntax
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

	 ;; diagnostics
	 `(flymake-error ((t :underline (:style wave :color ,red))))            ; DiagnosticUnderlineError
	 `(flymake-warning ((t :underline (:style wave :color ,yellow))))       ; DiagnosticUnderlineWarn
	 `(flymake-note ((t :underline (:style wave :color ,blue))))            ; DiagnosticUnderlineInfo
	 `(compilation-error ((t :foreground ,red)))                            ; DiagnosticSignError
	 `(compilation-warning ((t :foreground ,yellow)))                       ; DiagnosticSignWarn
	 `(compilation-info ((t :foreground ,blue)))                            ; DiagnosticSignInfo

	 ;; breadcrumb
	 `(lsp-headerline-breadcrumb-path-face ((t :foreground ,fg1)))          ; NavicText
	 `(lsp-headerline-breadcrumb-symbols-face ((t :foreground ,fg1 :weight bold))) ; NavicText

	 ;; hover popup
	 `(lsp-ui-doc-background ((t :background ,bg0)))                        ; NormalFloat

	 ;; completion popup
	 `(corfu-default ((t :background ,bg0)))                                ; NormalFloat
	 `(corfu-current ((t :background ,coral-bg :extend t)))                 ; PmenuSel
	 `(corfu-border ((t :background ,coral)))                               ; FloatBorder
	 `(corfu-bar ((t :background ,bg4)))                                    ; PmenuThumb

	 ;; diffs
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

	 ;; git
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

	 ;; org
	 `(org-document-title ((t :foreground ,green :weight bold)))            ; @markup.heading
	 `(org-level-1 ((t :foreground ,green :weight bold)))                   ; @markup.heading
	 `(org-level-2 ((t :inherit org-level-1)))
	 `(org-level-3 ((t :inherit org-level-1)))
	 `(org-level-4 ((t :inherit org-level-1)))
	 `(org-level-5 ((t :inherit org-level-1)))
	 `(org-level-6 ((t :inherit org-level-1)))
	 `(org-level-7 ((t :inherit org-level-1)))
	 `(org-level-8 ((t :inherit org-level-1)))
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

	 ;; key hints
	 `(which-key-key-face ((t :foreground ,green :weight bold)))            ; WhichKey
	 `(which-key-separator-face ((t :foreground ,gray :slant italic)))      ; WhichKeySeparator
	 `(which-key-group-description-face ((t :foreground ,red)))             ; WhichKeyGroup
	 `(which-key-command-description-face ((t :foreground ,blue)))          ; WhichKeyDesc
	 `(which-key-local-map-description-face ((t :foreground ,blue)))        ; WhichKeyDesc
	 `(which-key-note-face ((t :foreground ,gray :slant italic)))           ; WhichKeyValue

	 ;; dashboard
	 `(dashboard-text-banner ((t :foreground ,fg1)))                        ; alpha header
	 `(dashboard-banner-logo-title ((t :foreground ,fg1)))                  ; alpha header
	 `(dashboard-heading ((t :foreground ,fg1)))                            ; alpha buttons
	 `(dashboard-items-face ((t :foreground ,fg1)))                         ; alpha buttons
	 `(dashboard-footer-face ((t :foreground ,orange)))                     ; alpha footer
	 `(dashboard-footer-icon-face ((t :foreground ,orange)))                ; alpha footer

	 ;; evil search
	 `(evil-ex-lazy-highlight ((t :foreground ,fg1 :background ,coral-bg))) ; Search
	 `(evil-ex-substitute-matches ((t :foreground ,fg1 :background ,coral-bg))) ; Search
	 `(evil-ex-substitute-replacement ((t :foreground ,bg0 :background ,coral))) ; IncSearch

	 ;; terminal colors
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
	 `(ansi-color-bright-white ((t :foreground ,fg1 :background ,fg1))))

	(custom-theme-set-variables
	 'crimson
	 ;; pdf pages in midnight mode use the editor text and background
	 `(pdf-view-midnight-colors '(,fg1 . ,bg0))
	 `(lsp-ui-doc-border ,coral)))                                          ; FloatBorder

(provide-theme 'crimson)

;;; crimson-theme.el ends here
