;;; init.el --- Loads core, local settings and modules -*- lexical-binding: t; -*-

;; modules to load in order, local.el can add or remove them
;; pdf before evil so pdf tools is installed when evil collection compiles its pdf keys
(defvar my/modules '(ui/theme ui/font ui/modeline ui/dashboard ui/crosshair editor project tools/pdf editor/evil tools/treeshitter lang languages/python completion/corfu completion/orderless completion/vertico languages/org tools/magit))

;; pkg manager first, modules install pkgs through it
(load (expand-file-name "core/packages" my/config-directory) nil 'nomessage)

;; leader map before local.el and modules so both can add keys to it
(load (expand-file-name "core/leader" my/config-directory) nil 'nomessage)

;; glyphs before local.el and modules so both can change what is drawn
(load (expand-file-name "core/icons" my/config-directory) nil 'nomessage)

;; per machine overrides, loaded before modules so their defaults dont replace them
(let ((local (expand-file-name "local.el" my/config-directory)))
	(when (file-exists-p local)
		(load local nil 'nomessage)))

;; each entry is a file or a folder holding config
(dolist (module my/modules)
	(let* ((base (expand-file-name (format "modules/%s" module) my/config-directory))
				 (file (if (file-exists-p (concat base ".el")) base (expand-file-name "config" base))))
		(load file nil 'nomessage)))
