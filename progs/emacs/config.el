;; Automated Third-Party Package Cleanup
(use-package no-littering
  :ensure t
  :config
  ;; This automatically configures directories to ~/.emacs.d/var/ and etc/
  (setq backup-directory-alist
        `(("." . ,(expand-file-name "var/backup/" user-emacs-directory))))
  (setq auto-save-file-name-transforms
        `((".*" ,(expand-file-name "var/auto-save/" user-emacs-directory) t))))


(setq-default toggle-truncate-lines t) ; Always truncate long lines
(setq truncate-lines t)
(delete-selection-mode 1) ; Overwrite selected text globally

;; Explicitly enforce showing all elements from Options > Show/Hide
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

(column-number-mode t)
(display-battery-mode t)
(display-time-mode t)
(size-indication-mode t)
(global-tab-line-mode t)

;;(setq indicate-empty-lines t)
(setq indicate-buffer-boundaries '((top . left) (bottom . left) (up . left) (down . left)))

(set-frame-font "FiraCode Nerd Font-10.5" nil t) ;


      (use-package ligature
:config
;; Enable the "www" ligature in every possible major mode
(ligature-set-ligatures 't '("www"))
;; Enable traditional ligature support in eww-mode, if the
;; `variable-pitch' face supports it
(ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))
;; Enable all Cascadia and Fira Code ligatures in programming modes
(ligature-set-ligatures 'prog-mode
                      '(;; == === ==== => =| =>>=>=|=>==>> ==< =/=//=// =~
                        ;; =:= =!=
                        ("=" (rx (+ (or ">" "<" "|" "/" "~" ":" "!" "="))))
                        ;; ;; ;;;
                        (";" (rx (+ ";")))
                        ;; && &&&
                        ("&" (rx (+ "&")))
                        ;; !! !!! !. !: !!. != !== !~
                        ("!" (rx (+ (or "=" "!" "\." ":" "~"))))
                        ;; ?? ??? ?:  ?=  ?.
                        ("?" (rx (or ":" "=" "\." (+ "?"))))
                        ;; %% %%%
                        ("%" (rx (+ "%")))
                        ;; |> ||> |||> ||||> |] |} || ||| |-> ||-||
                        ;; |->>-||-<<-| |- |== ||=||
                        ;; |==>>==<<==<=>==//==/=!==:===>
                        ("|" (rx (+ (or ">" "<" "|" "/" ":" "!" "}" "\]"
                                        "-" "=" ))))
                        ;; \\ \\\ \/
                        ("\\" (rx (or "/" (+ "\\"))))
                        ;; ++ +++ ++++ +>
                        ("+" (rx (or ">" (+ "+"))))
                        ;; :: ::: :::: :> :< := :// ::=
                        (":" (rx (or ">" "<" "=" "//" ":=" (+ ":"))))
                        ;; // /// //// /\ /* /> /===:===!=//===>>==>==/
                        ("/" (rx (+ (or ">"  "<" "|" "/" "\\" "\*" ":" "!"
                                        "="))))
                        ;; .. ... .... .= .- .? ..= ..<
                        ("\." (rx (or "=" "-" "\?" "\.=" "\.<" (+ "\."))))
                        ;; -- --- ---- -~ -> ->> -| -|->-->>->--<<-|
                        ("-" (rx (+ (or ">" "<" "|" "~" "-"))))
                        ;; *> */ *)  ** *** ****
                        ("*" (rx (or ">" "/" ")" (+ "*"))))
                        ;; www wwww
                        ("w" (rx (+ "w")))
                        ;; <> <!-- <|> <: <~ <~> <~~ <+ <* <$ </  <+> <*>
                        ;; <$> </> <|  <||  <||| <|||| <- <-| <-<<-|-> <->>
                        ;; <<-> <= <=> <<==<<==>=|=>==/==//=!==:=>
                        ;; << <<< <<<<
                        ("<" (rx (+ (or "\+" "\*" "\$" "<" ">" ":" "~"  "!"
                                        "-"  "/" "|" "="))))
                        ;; >: >- >>- >--|-> >>-|-> >= >== >>== >=|=:=>>
                        ;; >> >>> >>>>
                        (">" (rx (+ (or ">" "<" "|" "/" ":" "=" "-"))))
                        ;; #: #= #! #( #? #[ #{ #_ #_( ## ### #####
                        ("#" (rx (or ":" "=" "!" "(" "\?" "\[" "{" "_(" "_"
                                     (+ "#"))))
                        ;; ~~ ~~~ ~=  ~-  ~@ ~> ~~>
                        ("~" (rx (or ">" "=" "-" "@" "~>" (+ "~"))))
                        ;; __ ___ ____ _|_ __|____|_
                        ("_" (rx (+ (or "_" "|"))))
                        ;; Fira code: 0xFF 0x12
                        ("0" (rx (and "x" (+ (in "A-F" "a-f" "0-9")))))
                        ;; Fira code:
                        "Fl"  "Tl"  "fi"  "fj"  "fl"  "ft"
                        ;; The few not covered by the regexps.
                        "{|"  "[|"  "]#"  "(*"  "}#"  "$>"  "^="))
;; Enables ligature checks globally in all buffers. You can also do it
;; per mode with `ligature-mode'.
(global-ligature-mode t))

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default c-basic-offset 4)

(global-display-line-numbers-mode 1)

;; Disable line numbers in specific buffers where they don't make sense
(dolist (mode '(term-mode-hook
                shell-mode-hook
                eshell-mode-hook
                vterm-mode-hook
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

;; =============================================================================
;; 1. Built-in Dark Base Theme & Color Definitions
;; =============================================================================

;; Load built-in dark theme (modus-vivendi is built-in as of Emacs 28+)
(load-theme 'modus-vivendi t)

(defvar my/accent-primary   "#00adb5" "Primary active accent.")
(defvar my/accent-muted     "#008389" "Muted accent for structural borders.")
(defvar my/accent-bg-soft   "#1b4950" "Soft background tint for active selections.")
(defvar my/dark-bg          "#1a1e24" "Base dark background.")
(defvar my/panel-bg         "#222831" "Elevated surface/panel background.")
(defvar my/text-bright      "#eeeeee" "High-contrast text.")

(custom-set-faces
  ;; Core Editor Faces
  `(default ((t (:background ,my/dark-bg :foreground ,my/text-bright))))
  `(cursor ((t (:background ,my/accent-primary))))
  `(region ((t (:background ,my/accent-bg-soft :foreground ,my/text-bright))))
  `(hl-line ((t (:background ,my/panel-bg))))
  `(fringe ((t (:background ,my/dark-bg :foreground ,my/accent-muted))))
  `(vertical-border ((t (:foreground ,my/accent-muted))))
  `(minibuffer-prompt ((t (:foreground ,my/accent-primary :weight bold))))
  `(link ((t (:foreground ,my/accent-primary :underline t))))

  ;; Mode Line Focus
  `(mode-line ((t (:background ,my/panel-bg :foreground ,my/accent-primary :box (:line-width 1 :color ,my/accent-primary)))))
  `(mode-line-inactive ((t (:background ,my/dark-bg :foreground "#8f9ba8" :box (:line-width 1 :color "#2d3748")))))
  `(mode-line-buffer-id ((t (:foreground ,my/accent-primary :weight bold))))

  ;; Search
  `(isearch ((t (:background ,my/accent-primary :foreground ,my/dark-bg :weight bold))))
  `(lazy-highlight ((t (:background ,my/accent-bg-soft :foreground ,my/accent-primary)))))

;; =============================================================================
;; 2. Package-Specific Accent Integrations
;; =============================================================================

;; Helm & Helm-Core
(with-eval-after-load 'helm
  (custom-set-faces
   `(helm-selection ((t (:background ,my/accent-bg-soft :foreground ,my/accent-primary :weight bold))))
   `(helm-match ((t (:foreground ,my/accent-primary :weight bold))))
   `(helm-source-header ((t (:background ,my/panel-bg :foreground ,my/accent-primary :weight bold :height 1.1))))
   `(helm-header ((t (:background ,my/dark-bg :foreground ,my/accent-primary))))
   `(helm-candidate-number ((t (:foreground ,my/accent-muted :weight bold))))
   `(helm-separator ((t (:foreground ,my/accent-muted))))))

;; Company
(with-eval-after-load 'company
  (custom-set-faces
   `(company-tooltip-selection ((t (:background ,my/accent-bg-soft :foreground ,my/accent-primary :weight bold))))
   `(company-tooltip-common ((t (:foreground ,my/accent-primary :weight bold))))
   `(company-scrollbar-fg ((t (:background ,my/accent-primary))))
   `(company-scrollbar-bg ((t (:background ,my/panel-bg))))))

;; Magit & Magit-Todos
(with-eval-after-load 'magit
  (custom-set-faces
   `(magit-section-heading ((t (:foreground ,my/accent-primary :weight bold))))
   `(magit-branch-local ((t (:foreground ,my/accent-primary :weight bold))))
   `(magit-branch-current ((t (:foreground ,my/accent-primary :box (:line-width 1 :color ,my/accent-primary)))))
   `(magit-diff-hunk-heading ((t (:background ,my/panel-bg :foreground ,my/accent-primary))))
   `(magit-diff-hunk-heading-highlight ((t (:background ,my/accent-bg-soft :foreground ,my/accent-primary))))))

;; Flycheck
(with-eval-after-load 'flycheck
  (custom-set-faces
   `(flycheck-fringe-warning ((t (:foreground ,my/accent-primary))))
   `(flycheck-fringe-info ((t (:foreground ,my/accent-primary))))))

;; LSP UI (Peak/Doc Popups)
(with-eval-after-load 'lsp-ui
  (custom-set-faces
   `(lsp-ui-peek-header ((t (:background ,my/panel-bg :foreground ,my/accent-primary :weight bold))))
   `(lsp-ui-peek-selection ((t (:background ,my/accent-bg-soft :foreground ,my/accent-primary))))
   `(lsp-ui-peek-highlight ((t (:foreground ,my/accent-primary :weight bold))))
   `(lsp-ui-doc-background ((t (:background ,my/panel-bg))))))

;; Symbol-Overlay
(with-eval-after-load 'symbol-overlay
  (custom-set-faces
   `(symbol-overlay-default-face ((t (:background ,my/accent-bg-soft :foreground ,my/accent-primary :weight bold))))))

;; Hl-Todo
(with-eval-after-load 'hl-todo
  (add-to-list 'hl-todo-keyword-faces `("TODO" . ,my/accent-primary))
  (add-to-list 'hl-todo-keyword-faces `("FIXME" . "#ff4500")))

;; Posframe (Borders)
(with-eval-after-load 'posframe
  (custom-set-faces
   `(posframe-border ((t (:background ,my/accent-primary))))))

;; Web-Mode / Markdown-Mode
(with-eval-after-load 'web-mode
  (custom-set-faces
   `(web-mode-html-tag-face ((t (:foreground ,my/accent-primary :weight bold))))
   `(web-mode-html-attr-name-face ((t (:foreground "#4fc3f7"))))))

(with-eval-after-load 'markdown-mode
  (custom-set-faces
   `(markdown-header-face-1 ((t (:foreground ,my/accent-primary :weight bold :height 1.2))))
   `(markdown-header-face-2 ((t (:foreground "#38bdf8" :weight bold))))))

(use-package winner)
(winner-mode 1)

(defun my/toggle-window-zoom ()
  "Toggle between maximizing the current window and restoring the split layout."
  (interactive)
  (if (one-window-p)
      (winner-undo)
    (delete-other-windows)))

;; Bind the toggle function to a convenient key combination
(global-set-key (kbd "C-c z") 'my/toggle-window-zoom)

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

(use-package helm
  :ensure t
  :config
  (setq helm-display-function #'helm-display-buffer-in-own-frame
        helm-commands-using-frame '(helm-M-x helm-find-files helm-mini)))

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
  (setq undo-tree-auto-save-history t)
  ;; Fixed to prevent polluting project directories with .~undo-tree files
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/var/undo-tree/")))

  (global-unset-key (kbd "C-z"))
  (global-set-key (kbd "C-z") 'undo-only)
  (global-set-key (kbd "C-S-z") 'undo-tree-redo))

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

(use-package magit
  :commands magit-status
  :bind ("C-x g" . magit-status))

(global-set-key (kbd "C-x C-l") 'magit-log-buffer-file)  ; unbind (downcase-region)

(setq transient-default-level 7)

(use-package org
  :defer t
  :config
  (setq org-ellipsis " \u25be"
        org-hide-leading-stars t
        org-log-done 'time))

(setq org-adapt-indentation t) ; edit structure (indent content also)
(setq org-support-shift-select t) ; enable text-selection when possible

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

(add-hook 'python-mode-hook #'flycheck-mode)
(use-package python
  :mode ("\\.py\\'" . python-mode)
  :config
  (setq
   lsp-pylsp-plugins-ruff-enabled t
   lsp-pylsp-plugins-pyright-enabled nil
   lsp-pylsp-plugins-flake8-enabled nil
   lsp-pylsp-plugins-mccabe-enabled nil
   lsp-pylsp-plugins-pycodestyle-enabled nil))

(add-to-list 'auto-mode-alist '("\\.mjs\\'" . js-ts-mode))

;; 1. Define custom Flycheck checker for Biome
(with-eval-after-load 'flycheck
  (flycheck-define-checker javascript-biome
                           "A JavaScript/TypeScript syntax and style checker using Biome."
                           :command ("biome" "check" "--reporter=github" (eval (buffer-file-name)))
                           :error-patterns
                           ((error line-start "::error file=" (file-name) ",line=" line ",col=" column "::" (message) line-end)
                            (warning line-start "::warning file=" (file-name) ",line=" line ",col=" column "::" (message) line-end))
                           :modes (js-mode js-ts-mode typescript-mode typescript-ts-mode jsx-ts-mode tsx-ts-mode))

  (add-to-list 'flycheck-checkers 'javascript-biome)
  (flycheck-add-next-checker 'javascript-eslint 'javascript-biome))

;; 3. Buffer setup hook
(defun my/js-ts-mode-setup ()
  "Setup Flycheck and force ESLint to run first."
  (setq-local flycheck-checker 'javascript-eslint)
  (flycheck-mode))

(add-hook 'js-ts-mode-hook #'my/js-ts-mode-setup)
(add-hook 'js-ts-mode-hook #'lsp)

;; Enable LSP for CSS modes
(add-hook 'css-mode-hook #'lsp)
(add-hook 'css-ts-mode-hook #'lsp)

;; Fixed the indent-bars crash by ensuring the compat dependency exists
(use-package compat
  :ensure t)

(use-package indent-bars
  :ensure t
  :hook ((prog-mode yaml-mode conf-mode) . indent-bars-mode))

(global-set-key (kbd "C-S-t") 'project-shell)
(global-set-key (kbd "C-S-f") 'project-find-file)
(global-set-key (kbd "C-S-g") 'project-find-regexp)

(add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)
(setq magit-process-apply-ansi-colors t)

(use-package vterm
       :ensure t
       :bind ("C-x t" . vterm)            ; Bind C-x t to launch vterm
       :custom
       (vterm-max-scrollback 10000)       ; Increase scrollback history limit
       :config
       ;; Automatically kill the vterm buffer when the shell process exits
       (add-hook 'vterm-exit-functions
                 (lambda (buf event)
                   (let ((buffer-window (get-buffer-window buf)))
                     (when buffer-window
                       (delete-window buffer-window))
                     (kill-buffer buf)))))


     (use-package multi-vterm
       :ensure t
       :after vterm
       :bind ("C-x M-t" . multi-vterm))

(use-package posframe
  :ensure t)

(use-package vterm-toggle
  :ensure t
  :after (vterm posframe)
  :bind ("C-`" . vterm-toggle)
  :config
  ;; Tell vterm-toggle to use posframe for a floating GUI window
  (setq vterm-toggle-use-posframe t)

  ;; Define the floating window size and appearance (centered)
  (setq vterm-toggle-posframe-style 'center)
  (setq vterm-toggle-posframe-width 90)
  (setq vterm-toggle-posframe-height 25))

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
:config
;; Safely spin up the auto-completion engine across frames
(global-company-mode 1)

;; Tweak responsiveness variables for instant typing feedback
(setq company-idle-delay 0.1)
(setq company-minimum-prefix-length 1))

;; Eshell: Emacs' built-in, platform-agnostic shell.
(use-package eshell
  :bind ("C-c e s" . eshell)
  :config
  ;; Clear eshell buffer alias
  (defun eshell/clear ()
    "Clear the eshell buffer."
    (let ((inhibit-read-only t))
      (erase-buffer)
      (eshell-send-input)))

  ;; Save command history globally
  (setq eshell-hist-ignoredups t
        eshell-save-history-on-exit t))

;; Dockerfile highlighting
(use-package dockerfile-mode
  :ensure t
  :mode "Dockerfile\\'")

;; YAML highlighting for Ansible/K8s/Docker-Compose
(use-package yaml-mode
  :ensure t
  :mode "\\.yml\\'")

;; NOTE: This config primarily relies on Helm (Section 3).
;; Vertico and Marginalia are configured here as fallbacks or future
;; replacements, but are left disabled by default to prevent conflicts.

(use-package vertico
  :ensure t
  :defer t
  :config
  ;; (vertico-mode 1) ; Uncomment to switch from Helm to Vertico
  (setq vertico-cycle t))

(use-package marginalia
  :ensure t
  :defer t
  :config
  ;; (marginalia-mode 1) ; Uncomment to enable minibuffer annotations
  )
