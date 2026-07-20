''
;;; init.el --- Core Bootstrapper -*- lexical-binding: t; -*-

;; Restore normal GC performance threshold after Emacs is ready
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 2 1024 1024))))

;; Set up package management repositories
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa"  . "https://elpa.gnu.org/packages/")))
(package-initialize)

;; Bootstrap 'use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-repositories)
  (package-install 'use-package))

;; Auto-install missing packages declared via use-package
(setq use-package-always-ensure t)

;; Compile and load the literate configuration file from config.org
(let ((literate-config (expand-file-name "config.org" user-emacs-directory)))
  (if (file-exists-p literate-config)
      (org-babel-load-file literate-config)
    (message "Warning: config.org file not found in %s" user-emacs-directory)))

;; Keep Emacs-generated Custom settings isolated from manually written configuration
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))
