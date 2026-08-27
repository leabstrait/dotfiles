;; -*- lexical-binding: t; -*-

;; Make startup faster by reducing the frequency of garbage collection. This will be set back when startup finishes.
;; We also increase Read Process Output Max so Emacs can read more data.

;; Set garbage collector (from doom emacs)
;; About 0.02 faster
(setq gc-cons-threshold (* 1024 1024 128)  ; 128mb
      gc-cons-percentage 1.0) ; Disable the dynamic percentage trigger to ensure GC frequency is fixed.

;; Increase the amount of data which Emacs reads from the process
(setq read-process-output-max (* 1024 1024)) ; 1mb

;; Runtime performance
;; Dial the GC threshold back down so that garbage collection happens more frequently but in less time.
;; Make GC pauses faster by decreasing the threshold.
;; About 0.02 faster
(add-hook 'emacs-startup-hook
      (lambda ()
            (setq gc-cons-threshold (* 1024 1024 2) ; 2mb
                  gc-cons-percentage 0.2)))


;; Unset file-name-handler-alist
;; About 0.07 faster
(defvar last-file-name-handler-alist file-name-handler-alist)

(setq file-name-handler-alist nil)

(add-hook 'after-init-hook
          (lambda ()
            (setq file-name-handler-alist
                  last-file-name-handler-alist)))

;; Fix white flash on startup
;; Don't do it when using daemon or terminal, because it messes up the background color.
(unless (or (daemonp) (not initial-window-system))
  (setq default-frame-alist '(
                              (foreground-color . "white")
                              (background-color . "#181818"))))

;; Disable UI elements before UI initialization.
;; For faster startup times. It gives 0.05 sec.
(setq menu-bar-mode nil)         ; Disable the menu bar
(setq tool-bar-mode nil)         ; Disable the tool bar
(push '(vertical-scroll-bars) default-frame-alist) ; Disable the scroll bar

;;; FONTS
;; Startup about 0.01 faster
(set-face-attribute 'default nil
                    :font "FiraCode Nerd Font" ; Set your favorite type of font or download JetBrains Mono
                    :height 100
                    :weight 'medium)
;; This sets the default font on all graphical frames created after restarting Emacs.
;; Does the same thing as 'set-face-attribute default' above, but emacsclient fonts
;; are not right unless I also add this method of setting the default font.
 (add-to-list 'default-frame-alist '(font . "FiraCode Nerd Font")) ; Set your favorite font
(setq-default line-spacing 0.12)

(prefer-coding-system 'utf-8)

(when (eq system-type 'darwin)
  (let* ((brew-bin (or (executable-find "brew")
                       (if (file-exists-p "/opt/homebrew/bin/brew") "/opt/homebrew/bin/brew" "/usr/local/bin/brew")))
         (brew-prefix (when brew-bin (string-trim (shell-command-to-string (concat brew-bin " --prefix"))))))
    (when brew-prefix
      (let* ((gcc-prefix (concat brew-prefix "/opt/gcc"))
             (gcc-lib-dir (concat gcc-prefix "/lib/gcc/current"))
             ;; Find the architecture-specific subfolder (e.g., aarch64-apple-darwinXX or x86_64-apple-darwinXX)
             (target-subdirs (file-expand-wildcards (concat gcc-lib-dir "/gcc/*/*")))
             (paths (delete-dups
                     (append (list gcc-lib-dir gcc-prefix)
                             target-subdirs
                             (list (concat brew-prefix "/lib"))))))
        ;; Inject into LIBRARY_PATH so libgccjit finds the driver and specs
        (let ((existing (split-string (or (getenv "LIBRARY_PATH") "") ":" t)))
          (setenv "LIBRARY_PATH" (mapconcat #'identity (delete-dups (append paths existing)) ":"))))

      ;; Ensure macOS SDK headers are reachable
      (let ((sdk-path "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib"))
        (when (file-exists-p sdk-path)
          (setenv "LIBRARY_PATH (concat sdk-path ":" (getenv "LIBRARY_PATH"))"))))))
