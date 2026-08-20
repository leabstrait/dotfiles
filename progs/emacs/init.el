;; -*- lexical-binding: t; -*-

(defun start/org-babel-tangle-config ()
  "Automatically tangle our init.org config file and refresh `package-quickstart'.
Credit to Emacs From Scratch for this one!"
  (interactive)
  (when (string-equal (file-name-directory (buffer-file-name))
                      (expand-file-name user-emacs-directory))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle)
      (package-quickstart-refresh))))  ;; (only works with package.el)

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'start/org-babel-tangle-config)))

(defun start/display-startup-time ()
  "Display Emacs startup time and number of garbage collections."
  (interactive)
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                    (time-subtract after-init-time before-init-time)))
           gcs-done))

(add-hook 'emacs-startup-hook #'start/display-startup-time)

(require 'use-package-ensure) ; Load use-package-always-ensure
(setq use-package-always-ensure t) ; Always ensures that a package is installed

(setq package-archives '(("melpa" . "https://melpa.org/packages/") ; Sets default package repositories
                         ("elpa" . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/"))) ; For Eat Terminal

(setq package-quickstart t) ; For blazingly fast startup times, this line makes startup miles faster

(use-package async
  :defer t
  :custom
  (dired-async-mode t)
  (async-bytecomp-package-mode t)
  (async-bytecomp-allowed-packages '(all))
  (async-package-do-action t))

(use-package emacs
  :custom
  ;; Still needed for terminals
  (menu-bar-mode nil)         ; Disable the menu bar
  (scroll-bar-mode nil)       ; Disable the scroll bar
  (tool-bar-mode nil)         ; Disable the tool bar

  ;;(inhibit-startup-screen t)  ; Disable welcome screen

  (delete-selection-mode t)   ; Select text and delete it by typing.
  (electric-indent-mode nil)  ; Turn off the weird indenting that Emacs does by default.
  (electric-pair-mode t)      ; Turns on automatic parens pairing

  (blink-cursor-mode nil)     ; Don't blink cursor
  (global-auto-revert-mode t) ; Automatically reload file and show changes if the file has changed
  ;; (use-short-answers t)   ; Since Emacs 29, `yes-or-no-p' will use `y-or-n-p'

  ;; (dired-kill-when-opening-new-dired-buffer t) ; Dired doesn't create new buffer
  ;; (dired-mouse-drag-files t) ; Enable Drag and Drop support in dired (Only works in X11)

  ;; (recentf-mode t) ; Enable recent file mode
  ;; (context-menu-mode t) ; Right-click menu
  ;; (savehist-mode t) ; Enables save history mode

  ;; (global-visual-line-mode t)           ; Enable line wrapping (NOTE: breaks vundo)
  (global-display-line-numbers-mode t)  ; Display line numbers
  ;; (display-line-numbers-type 'relative) ; Relative line numbers
  (global-hl-line-mode t)               ; Highlight current line

  (native-comp-async-report-warnings-errors 'silent) ; Don't show native comp errors
  (warning-minimum-level :error) ; Only show errors in warnings buffer

  (mouse-wheel-progressive-speed nil) ; Disable progressive speed when scrolling
  (scroll-conservatively 10) ; Smooth scrolling
  (scroll-margin 8)

  ;; (pixel-scroll-precision-mode t) ; Precise pixel scrolling. i.e. smooth scrolling (GUI only)
  ;; (pixel-scroll-precision-use-momentum nil)

  (indent-tabs-mode nil) ; Only use spaces for indentation
  (tab-width 4)
  (sgml-basic-offset 4) ; Set Html mode indentation to 4
  (c-ts-mode-indent-offset 4) ; Fix weird indentation in c-ts (C, C++)
  (go-ts-mode-indent-offset 4) ; Fix weird indentation in go-ts

  ;; (display-fill-column-indicator-column 80) ; Set line length indicator to 80 characters
  (whitespace-style '(face tabs tab-mark trailing))

  (make-backup-files nil) ; Stop creating ~ backup files
  (auto-save-default nil) ; Stop creating # auto save files
  (delete-by-moving-to-trash t)
  :hook
  (prog-mode . hs-minor-mode) ; Enable folding hide/show globally
  ;; (prog-mode . display-fill-column-indicator-mode) ; Display line length indicator
  (prog-mode . whitespace-mode)
  :config
  ;; Move customization variables to a separate file and load it, avoid filling up init.el with unnecessary variables
  (setq custom-file (locate-user-emacs-file "custom-vars.el"))
  (load custom-file 'noerror 'nomessage)
  :bind (
         ([escape] . keyboard-escape-quit) ; Makes Escape quit prompts (Minibuffer Escape)
         ;; Zooming In/Out
         ("C-+" . text-scale-increase)
         ("C--" . text-scale-decrease)
         ("<C-wheel-up>" . text-scale-increase)
         ("<C-wheel-down>" . text-scale-decrease)))

(use-package which-key
  :ensure nil ; Don't install which-key because it's now built-in
  :hook (after-init . which-key-mode)
  :diminish
  :custom
  (which-key-side-window-location 'bottom)
  (which-key-sort-order #'which-key-key-order-alpha) ; Same as default, except single characters are sorted alphabetically
  (which-key-sort-uppercase-first nil)
  (which-key-add-column-padding 1) ; Number of spaces to add to the left of each column
  (which-key-min-display-lines 6)  ; Increase the minimum lines to display because the default is only 1
  (which-key-idle-delay 0.3)       ; Set the time delay (in seconds) for the which-key popup to appear
  (which-key-allow-imprecise-window-fit nil)) ; Fixes which-key window slipping out in Emacs Daemon

(defun start/open-init-file ()
  "Open init.org configuration file."
  (interactive)
  (find-file "~/.emacs.d/init.org"))

(defun start/reload-config()
  "Reload Emacs config."
  (interactive)
  (load-file "~/.emacs.d/init.el"))

(use-package general
  ;; :after (evil) ; <- evil
  :config
  ;; (general-evil-setup) ; <- evil
  ;; Set up 'C-SPC' as the leader key
  (general-create-definer start/leader-keys
    ;; :states '(normal insert visual motion emacs) ; <- evil
    :keymaps 'override
    :prefix "C-SPC"
    :global-prefix "C-SPC") ; Set global leader key so we can access our keybindings from any state

  (start/leader-keys
    "." '(find-file :wk "Find file")
    "," '(embark-act :wk "Embark act")
    "TAB" '(comment-line :wk "Comment lines")
    "c" '(eat :wk "Eat terminal")
    "g" '(magit-status :wk "Magit status")
    "q" '(flymake-show-buffer-diagnostics :wk "Flymake buffer diagnostic")
    ;; Projectile
    "p" '(projectile-command-map :wk "Projectile")
    "s p" '(projectile-discover-projects-in-search-path :wk "Search for projects"))

  (start/leader-keys
    "d" '(:ignore t :wk "Buffers & Dired")
    "d i" '(ibuffer :wk "Ibuffer")
    "d j" '(dired-jump :wk "Dired jump to current")
    "d k" '(kill-current-buffer :wk "Kill current buffer")

    "d n" '(next-buffer :wk "Next buffer")
    "d p" '(previous-buffer :wk "Previous buffer")
    "d r" '(revert-buffer :wk "Reload buffer")
    "d s" '(consult-buffer :wk "Switch buffer")
    "d v" '(dired :wk "Open dired"))

  (start/leader-keys
    "e" '(:ignore t :wk "Languages")
    "e a" '(eglot-code-actions :wk "Eglot code actions")
    "e d" '(eldoc-doc-buffer :wk "Eldoc Buffer")
    "e e" '(eglot-reconnect :wk "Eglot Reconnect")
    "e f" '(eglot-format :wk "Eglot Format")
    "e i" '(xref-find-definitions :wk "Find definition")
    "e l" '(consult-flymake :wk "Consult Flymake")

    "e n" '(flymake-goto-next-error :wk "Flymake next error")
    "e p" '(flymake-goto-prev-error :wk "Flymake previous error")
    "e r" '(eglot-rename :wk "Eglot Rename")
    "e s" '(xref-find-references :wk "Find references")
    "e v" '(:ignore t :wk "Elisp")
    "e v b" '(eval-buffer :wk "Evaluate elisp in buffer")
    "e v r" '(eval-region :wk "Evaluate elisp in region"))

  (start/leader-keys
    "m" '(:ignore t :wk "Bookmarks & Registers")
    ;; Bookmarks
    "m a" '(bookmark-set :wk "Bookmark Set")
    "m b" '(bookmark-bmenu-list :wk "Bookmark bmenu list")
    "m c" '(consult-bookmark :wk "Consult Bookmark")
    "m d" '(bookmark-jump :wk "Bookmark Jump")
    "m r" '(bookmark-delete :wk "Bookmark Delete")
    "m R" '(bookmark-delete-all :wk "Bookmark Delete All")
    ;; Registers
    "m s" '(consult-register :wk "Consult register")
    "m k" '(jump-to-register :wk "Jump to register")
    "m e" '(point-to-register :wk "Point to register"))

  (start/leader-keys
    "r" '(:ignore t :wk "Reload & Packages") ; To get more help use C-h commands (describe variable, function, etc.)
    ;; Mason.el
    "r i" '(mason-install :wk "Mason install")
    "r m" '(mason-manager :wk "Mason manager")
    "r l" '(mason-update-all :wk "Mason update all")
    ;; Package-menu-mode
    "r p" '(list-packages :wk "List packages")
    "r c" '(package-menu-clear-filter :wk "Package clear filters")
    "r n" '(package-menu-filter-by-name :wk "Package filter by name")
    "r N" '(package-menu-filter-by-name-or-description :wk "Package filter by name or description")
    "r s" '(package-menu-filter-by-status :wk "Package filter by status")
    "r u" '(package-menu-filter-upgradable :wk "Package filter by upgradable")
    ;; Session and Configuration Management
    "r q" '(save-buffers-kill-emacs :wk "Quit Emacs and Daemon")
    "r r" '(start/reload-config :wk "Reload Emacs config"))

  (start/leader-keys
    "s" '(:ignore t :wk "Search")
    "s c" '(start/open-init-file :wk "Open init file")
    "s f" '(consult-fd :wk "Search files with fd")
    "s g" '(consult-ripgrep :wk "Search with ripgrep")
    "s i" '(consult-imenu :wk "Search Imenu buffer locations") ; This one is really cool
    "s l" '(consult-line :wk "Search line")
    "s r" '(consult-recent-file :wk "Search recent files"))

  (start/leader-keys
    "t" '(:ignore t :wk "Toggle")
    "t t" '(visual-line-mode :wk "Toggle truncated lines (wrap)")
    "t l" '(display-line-numbers-mode :wk "Toggle line numbers")))

;; Fix general.el leader key not working instantly in messages buffer with evil mode
;;(use-package emacs
;;  :after (evil general)
;;  :ghook ('after-init-hook
;;          (lambda (&rest _)
;;            (when-let ((messages-buffer (get-buffer "*Messages*")))
;;              (with-current-buffer messages-buffer
;;                (evil-normalize-keymaps))))
;;          nil nil t))

(use-package undo-fu
  :defer t
  :config
  ;; Increase undo history limits to reduce likelihood of data loss
  (setq undo-limit (* 1024 1024 64)          ; 64mb  (default is 160kb)
        undo-strong-limit (* 1024 1024 96)   ; 96mb  (default is 240kb)
        undo-outer-limit (* 1024 1024 960))) ; 960mb (default is 24mb)

(use-package undo-fu-session
  :hook (after-init . undo-fu-session-global-mode)
  :custom (undo-fu-session-incompatible-files '("\\.gpg$" "/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'"))
  :config
  (when (executable-find "zstd")
    ;; There are other algorithms available, but zstd is the fastest, and speed
    ;; is our priority within Emacs
    (setq undo-fu-session-compression 'zst)))

(use-package vundo
  :defer t
  :custom
  (vundo-glyph-alist vundo-unicode-symbols)
  (vundo-compact-display t))
