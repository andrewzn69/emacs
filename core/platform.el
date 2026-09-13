;;; platform.el --- OS checks -*- lexical-binding: t; -*-

(defconst my/linux-p (eq system-type 'gnu/linux))
(defconst my/macos-p (eq system-type 'darwin))
(defconst my/windows-p (eq system-type 'windows-nt))
