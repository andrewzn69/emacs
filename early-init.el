;;; early-init.el --- Runs before packages and the first frame -*- lexical-binding: t; -*-

;; repo folder, saved before user-emacs-directory is changed below
(defconst my/config-directory (file-name-directory load-file-name))

;; os checks and state dir location
(load (expand-file-name "core/platform" my/config-directory) nil 'nomessage)
(load (expand-file-name "core/paths" my/config-directory) nil 'nomessage)

;; create the state dir and its parents if missing
(make-directory my/state-directory t)
(setq user-emacs-directory my/state-directory)

;; native compile cache in the state dir, nix emacs edits the cache path list so emacs skips moving it
(when (featurep 'native-compile)
	(startup-redirect-eln-cache (expand-file-name "eln-cache" my/state-directory)))

;; built-in package.el stays off, straight.el manages packages
(setq package-enable-at-startup nil)

;; no menu bar, tool bar or scroll bars on any frame, set before the first frame is drawn
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(setq menu-bar-mode nil
			tool-bar-mode nil
			scroll-bar-mode nil)
