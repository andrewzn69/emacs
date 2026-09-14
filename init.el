;;; init.el --- Loads core, local settings and modules -*- lexical-binding: t; -*-

;; modules to load in order, local.el can add or remove them
(defvar my/modules '(ui dashboard editor evil org git))

;; pkg manager first, modules install pkgs through it
(load (expand-file-name "core/packages" my/config-directory) nil 'nomessage)

;; per machine overrides, loaded before modules so their defaults dont replace them
(let ((local (expand-file-name "local.el" my/config-directory)))
	(when (file-exists-p local)
		(load local nil 'nomessage)))

;; load modules/<name>.el for each entry in my/modules
(dolist (module my/modules)
	(load (expand-file-name (format "modules/%s" module) my/config-directory) nil 'nomessage))
