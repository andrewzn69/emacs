;;; icons.el --- Glyphs drawn across the config -*- lexical-binding: t; -*-

(defvar my/icons-diagnostics
	'((error . "")
	  (warning . "")
	  (info . "")
	  (hint . "")
	  (other . "")))

(defvar my/icons-git
	'((added . "")
	  (modified . "")
	  (removed . "")))

(defvar my/icons-symbol-kinds
	[("" . font-lock-variable-name-face)          ; File
	 ("" . font-lock-preprocessor-face)           ; Module
	 ("󰦮" . font-lock-preprocessor-face)           ; Namespace
	 ("" . font-lock-preprocessor-face)           ; Package
	 ("" . font-lock-type-face)                   ; Class
	 ("󰊕" . font-lock-function-name-face)          ; Method
	 ("" . font-lock-property-name-face)          ; Property
	 ("" . font-lock-property-name-face)          ; Field
	 ("" . font-lock-function-name-face)          ; Constructor
	 ("" . font-lock-type-face)                   ; Enum
	 ("" . font-lock-type-face)                   ; Interface
	 ("󰊕" . font-lock-function-name-face)          ; Function
	 ("󰀫" . font-lock-constant-face)               ; Variable
	 ("󰏿" . font-lock-constant-face)               ; Constant
	 ("" . font-lock-builtin-face)                ; String
	 ("󰎠" . font-lock-number-face)                 ; Number
	 ("󰨙" . font-lock-builtin-face)                ; Boolean
	 ("" . font-lock-type-face)                   ; Array
	 ("" . font-lock-type-face)                   ; Object
	 ("" . font-lock-property-name-face)          ; Key
	 ("" . font-lock-constant-face)               ; Null
	 ("" . font-lock-builtin-face)                ; EnumMember
	 ("󰆼" . font-lock-type-face)                   ; Struct
	 ("" . font-lock-warning-face)                ; Event
	 ("" . font-lock-operator-face)               ; Operator
	 ("" . font-lock-type-face)])                 ; TypeParameter

(defvar my/icons-branch '(powerline . "nf-pl-branch"))
(defvar my/icons-clock '(octicon . "nf-oct-clock"))
