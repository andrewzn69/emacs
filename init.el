;;; init.el --- Loads core, local settings and modules -*- lexical-binding: t; -*-

;; modules to load in order, local.el can add or remove them
;; pdf before evil so pdf tools is installed when evil collection compiles its pdf keys
(defvar my/modules '(ui modeline dashboard editor project pdf evil lang org git))

;; pkg manager first, modules install pkgs through it
(load (expand-file-name "core/packages" my/config-directory) nil 'nomessage)

;; leader map before local.el and modules so both can add keys to it
(load (expand-file-name "core/leader" my/config-directory) nil 'nomessage)

;; per machine overrides, loaded before modules so their defaults dont replace them
(let ((local (expand-file-name "local.el" my/config-directory)))
	(when (file-exists-p local)
		(load local nil 'nomessage)))

;; load modules/<name>.el for each entry in my/modules
(dolist (module my/modules)
	(load (expand-file-name (format "modules/%s" module) my/config-directory) nil 'nomessage))
