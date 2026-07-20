(setq-default toggle-truncate-lines t) ; Always truncate long lines
(setq truncate-lines t)

;; Explicitly enforce showing all elements from Options > Show/Hide
(when (fboundp 'tool-bar-mode) (tool-bar-mode 1))
(when (fboundp 'menu-bar-mode) (menu-bar-mode 1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode 0))

(column-number-mode t)
(display-battery-mode t)
(display-time-mode t)
(size-indication-mode t)
(tab-bar-mode t)

(setq indicate-empty-lines t)
(setq indicate-buffer-boundaries '((top . left) (bottom . left) (up . left) (down . left)))

(set-frame-font "NotoSansM Nerd Font Mono-11" nil t)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)

;; Disable line numbers in specific buffers where they don't make sense
(dolist (mode '(term-mode-hook
                shell-mode-hook
                eshell-mode-hook
                magit-status-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Disable text wrapping globally (lines truncate at the window edge)
(setq-default truncate-lines t)

;; Enable soft wrapping automatically only for text and documentation modes
(add-hook 'text-mode-hook 'visual-line-mode)
(add-hook 'markdown-mode-hook 'visual-line-mode)
(add-hook 'org-mode-hook 'visual-line-mode)

;; Enable built-in auto-save when Emacs is idle for 1 second
(auto-save-visited-mode 1)
(setq auto-save-visited-interval 1)

;; Save files automatically whenever Emacs loses focus
(add-hook 'focus-out-hook (lambda () (save-some-buffers t)))

;; Delete all trailing whitespace before saving a file
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Ensure there is exactly one newline at the end of the file
(setq require-final-newline t)
(setq mode-require-final-newline t)

;; 1. Base styles to monitor (excluding hardcoded backgrounds)
(setq whitespace-style '(face spaces space-mark tabs tab-mark trailing))

;; Enable minimal whitespace visibility globally
(global-whitespace-mode 1)

;; Automatically reload files changed on disk globally
(global-auto-revert-mode 1)

;; Also auto-reload non-file buffers like Dired directories
(setq global-auto-revert-non-file-buffers t)

;; Make Emacs check files instantly using file system notifications (instead of a slow timer)
(setq auto-revert-use-notify t)

;; Load the theme immediately as it comes from the factory
(load-theme 'modus-vivendi t)

(defun ediff-clipboard-with-file (file-name)
  "Compare FILE-NAME with the clipboard."
  (interactive "fCompare file with clipboard: ")
  (let ((clip-buf (generate-new-buffer "*clipboard*")))
    (with-current-buffer clip-buf
      (insert (or (and (fboundp 'gui-get-selection)
		       (gui-get-selection 'CLIPBOARD))
		  (current-kill 0)))
      (set-buffer-modified-p nil))
    (let ((ediff-after-quit-hook-internal
	   (list (lambda ()
		   (when (buffer-live-p clip-buf)
		     (kill-buffer clip-buf))))))
      (ediff-buffers clip-buf
		     (find-file-noselect file-name)))))

;; Bind to a convenient key, e.g., C-c e c
(global-set-key (kbd "C-c e c") 'ediff-clipboard-with-file)

(setq ediff-split-window-function 'split-window-horizontally)
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

(use-package helm
  :ensure t
  :init
  (helm-mode 1)
  :config
  (setq helm-allow-mouse t)
  (customize-set-variable 'helm-ff-lynx-style-map t)

  (define-key global-map [remap list-buffers] 'helm-buffers-list)
  (define-key global-map [remap execute-extended-command] 'helm-M-x)
  (define-key global-map [remap find-file] 'helm-find-files)
  (define-key global-map [remap switch-to-buffer] #'helm-mini))

(with-eval-after-load 'helm
  (define-key helm-map (kbd "<tab>") 'helm-next-line)
  (define-key helm-map (kbd "<backtab>") 'helm-previous-line)
  (define-key helm-map (kbd "<right>") 'helm-execute-persistent-action)
  (define-key helm-map (kbd "<left>") 'helm-execute-persistent-action))

(with-eval-after-load 'helm
  (unless (boundp 'completion-in-region-function)
    (define-key lisp-interaction-mode-map [remap completion-at-point] 'helm-lisp-completion-at-point)
    (define-key emacs-lisp-mode-map       [remap completion-at-point] 'helm-lisp-completion-at-point)))

(use-package undo-tree
  :ensure t
  :init
  (global-undo-tree-mode 1)
  :config
  (setq undo-tree-visualizer-timestamps t)
  (setq undo-tree-visualizer-diff t)
  (setq undo-tree-auto-save-history nil)

  (global-unset-key (kbd "C-z"))
  (global-set-key (kbd "C-z") 'undo-only)
  (global-set-key (kbd "C-S-z") 'undo-tree-redo))

(require 'symbol-overlay)

(global-set-key
 (kbd "<C-mouse-3>")
 (lambda (event)
   (interactive "e")
   (save-excursion
     (goto-char (posn-point (event-start event)))
     (symbol-overlay-put))))

(use-package expand-region
  :ensure t
  :bind (("C-S-SPC" . er/expand-region)
         ("C-SPC" . (lambda ()
                      (interactive)
                      (if (use-region-p)
                          (er/contract-region 1)
                        (call-interactively 'set-mark-command))))))

(use-package yafolding
  :ensure t
  :hook ((prog-mode . yafolding-mode)))

(require 'yasnippet)
(require 'yasnippet-snippets)
(yas-reload-all)
(add-hook 'prog-mode-hook 'yas-minor-mode-on)
(add-hook 'org-mode-hook 'yas-minor-mode-on)

(use-package magit
  :commands magit-status
  :bind ("C-x g" . magit-status))

(global-set-key (kbd "C-x C-l") 'magit-log-buffer-file)  ; unbind (downcase-region)

(setq transient-default-level 7)

(use-package org
    :defer t
    :config
    (setq org-ellipsis " ▾"
          org-hide-leading-stars t
          org-log-done 'time))


(setq org-adapt-indentation t) ; edit structure (indent content also)
(setq org-support-shift-select t) ; enable text-selection when possible
(add-hook 'org-mode-hook 'lambda() (require 'org-mouse))

(use-package which-key
  :init
  (which-key-mode)
  :config
  (setq which-key-idle-delay 0.3))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook ((python-mode . lsp-deferred)
         (js-mode . lsp-deferred)
         (js2-mode . lsp-deferred)
         (typescript-mode . lsp-deferred)
         (html-mode . lsp-deferred))
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (setq lsp-enable-indentation t
        lsp-diagnostics-provider :flycheck)
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :commands lsp-ui-mode
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-doc-enable t
        lsp-ui-sideline-enable t))

(use-package python
  :mode ("\\.py\\'" . python-mode)
  :config
  (setq lsp-pylsp-plugins-ruff-enabled t
        lsp-pylsp-plugins-pyright-enabled t
        lsp-pylsp-plugins-flake8-enabled nil
        lsp-pylsp-plugins-mccabe-enabled nil
        lsp-pylsp-plugins-pycodestyle-enabled nil))

(use-package web-mode
  :mode ("\\.mjs\\'" . web-mode))

(global-set-key (kbd "C-S-t") 'project-shell)
(global-set-key (kbd "C-S-f") 'project-find-file)
(global-set-key (kbd "C-S-g") 'project-find-regexp)

(add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)
(setq magit-process-apply-ansi-colors t)

(use-package vterm
  :ensure t
  :config
  ;; Max out scrollback history limit
  (setq vterm-max-scrollback 10000)

  ;; Map your default shell shell binary explicitly
  (setq vterm-shell "/bin/bash") ; Swap with "/bin/zsh" if applicable

  ;; Explicitly keep your minimal 4-space layout preferences intact inside terms
  (setq-default tab-width 4))

;; Bind a quick shortcut to launch or toggle the terminal instance instantly
(keymap-global-set "C-c t" 'vterm)

;; Use spaces instead of tabs globally
(setq-default indent-tabs-mode nil)

;; Set default fallback indentation width to 4 spaces
(setq-default tab-width 4)
(setq-default c-basic-offset 4)

(use-package web-mode
  :ensure t
  :mode (("\\.djhtml\\'" . web-mode)
         ("\\.html\\.djhtml\\'" . web-mode))
  :init
  ;; Turn on modern tree-sitter context parsing if available
  (setq web-mode-enable-tree-sitter t)
  :config
  ;; Force Django engine for djhtml extensions
  (setq web-mode-engines-alist
        '(("django" . "\\.djhtml\\'")))

  ;; Configure Web-Mode matching 4-space indentation layout
  (setq web-mode-markup-indent-offset 4)
  (setq web-mode-css-indent-offset 4)
  (setq web-mode-code-indent-offset 4)
  (setq web-mode-sql-indent-offset 4)

  ;; HTML tag behavior automation
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-enable-auto-closing t)
  (setq web-mode-enable-auto-quoting t)

  ;; Hook up company-mode for inline completion popup inside template tags
  (add-hook 'web-mode-hook
            (lambda ()
              (when (fboundp 'company-mode)
                (company-mode 1)))))

(use-package company
  :ensure t
  :defer t
  :init
  (global-company-mode 1)
  :config
  ;; Speed up context popups for a snappier feel
  (setq company-idle-delay 0.1)
  (setq company-minimum-prefix-length 1))

;; Reserved for terminal shell customization

;; Reserved for orchestration configurations

;; Reserved for alternative interactive layouts
