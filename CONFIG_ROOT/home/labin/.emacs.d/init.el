;; Initialize package sources
(require 'package)
(package-initialize)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(unless package-archive-contents 	
   (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Themeing
(use-package doom-themes
  :init (load-theme 'doom-one-light t))

;; Doom Modeline
(use-package doom-modeline
  :custom ((doom-modeline-height 10)))
  :init (doom-modeline-mode 1)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Give some breathing room
(set-fringe-mode 5)

;; Show column number
(column-number-mode)

;; Show line numbers
(global-display-line-numbers-mode t)

;; Set up the visible bell
(setq visible-bell t)

;; Font face
(set-face-attribute 'default nil :font "Fira Code" :height 90)



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(rainbow-delimiters doom-modeline doom-themes use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
