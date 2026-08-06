;;; init.el --- Core Bootstrapper -*- lexical-binding: t; -*-
;;; init.el --- Core Bootstrapper -*- lexical-binding: t; -*-

;; 1. Startup Speed Optimizations
(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)) ; 1MB max read size for fast LSP

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 2 1024 1024))))

;; 2. Package Management (Emacs 29+)
(require 'package)
(setq package-archives '(("gnu"    . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/packages/")
                         ("melpa"  . "https://melpa.org/packages/")))

;; Fetch the package list automatically if it doesn't exist
(unless package-archive-contents
  (package-refresh-contents))

(require 'use-package)
(setq use-package-always-ensure t)

;; 3. Literate Configuration Load
(let ((literate-config (expand-file-name "config.org" user-emacs-directory)))
  (if (file-exists-p literate-config)
      (org-babel-load-file literate-config)
    (message "Warning: config.org file not found in %s" user-emacs-directory)))

;; 4. Isolate Custom Variables
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))


(set-face-attribute 'mode-line nil :background "DarkSlateGray" :foreground "white")
(set-face-attribute 'mode-line-inactive nil :background "gray30" :foreground "gray70")
