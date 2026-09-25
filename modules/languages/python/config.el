;;; config.el --- Python -*- lexical-binding: t; -*-

;; python goes through its own client, the bundled ones start a different server
(use-package lsp-pyright
			:after lsp-mode
			:demand t)
