;;; paths.el --- Per-machine state directory -*- lexical-binding: t; -*-

(defconst my/state-directory
	(file-name-as-directory
		(expand-file-name
		 "emacs"
		 (cond
			(my/windows-p (getenv "LOCALAPPDATA"))
			(my/macos-p "~/Library/Application Support")
			(t (let ((xdg (getenv "XDG_STATE_HOME")))
					 (if (or (null xdg) (string= xdg "")) "~/.local/state" xdg)))))))
