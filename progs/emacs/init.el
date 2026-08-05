;;; init.el --- Core Bootstrapper -*- lexical-binding: t; -*-

;; Optimize garbage collection thresholds during load cycles
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 2 1024 1024))))

;; Standardize package manager tracking engines
(require 'package)
(setq package-archives '(("gnu"   . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org")))
(package-initialize)

;; Force dynamic index sync if cache records are missing
(unless package-archive-contents
  (package-refresh-contents))

;; Bootstrap 'use-package' deployment
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

;; Globally mandate auto-fetching for missing declarations
(setq use-package-always-ensure t)

;; Execute target configurations written out inside config.org
(let ((literate-config (expand-file-name "config.org" user-emacs-directory)))
  (if (file-exists-p literate-config)
      (org-babel-load-file literate-config)
    (message "Warning: config.org file not found in %s" user-emacs-directory)))

;; Load generated user-interface custom vars safely
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))
