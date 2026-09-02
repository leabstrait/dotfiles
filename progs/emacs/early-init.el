;; -*- lexical-binding: t; -*-

;; Record the precise start time to measure initialization performance.
(defconst my/startup-start-time (current-time))
(message "[early-init] Starting early-init sequence...")

;; Temporarily boost memory allocation thresholds during startup to accelerate
;; package loading and overall initialization speed.
(message "[performance] Boosting GC threshold and percentage...")
(setq gc-cons-threshold (* 1024 1024 128)
      gc-cons-percentage 1.0)

;; Restore the garbage collector to standard responsive parameters once
;; the startup sequence finishes, and log the transition.
(add-hook 'emacs-startup-hook
          (lambda ()
            (message "[startup] emacs-startup-hook triggered. Restoring standard GC...")
            (setq gc-cons-threshold (* 1024 1024 2)
                  gc-cons-percentage 0.2)
            (message "[startup] Emacs started in %.3f seconds with GC restored."
                     (float-time (time-subtract (current-time) my/startup-start-time)))))

;; Temporarily bypass file name handling overhead during startup to maximize
;; loading speed, restoring the original handler list post-initialization.
(message "[performance] Bypassing file-name-handler-alist...")
(defvar my/original-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)
(add-hook 'after-init-hook
          (lambda ()
            (message "[init] after-init-hook triggered. Restoring file-name-handler-alist...")
            (setq file-name-handler-alist my/original-file-name-handler-alist)
            (message "[init] File name handlers successfully restored.")))

;; Expand the maximum amount of data Emacs can read from child processes in a
;; single chunk, optimizing performance for external language servers.
(message "[performance] Increasing read-process-output-max to 4MB...")
(setq read-process-output-max (* 1024 1024 4))

;; Suppress native window elements before the initial frame is rendered to
;; completely eliminate startup flicker and reclaim screen real estate.
(message "[ui] Suppressing native scrollbars, menu bars, and tool bars...")
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;; Set a dark theme background color early in the frame lifecycle to prevent
;; the jarring white flash when launching graphical windows.
(unless (or (daemonp) (not initial-window-system))
  (message "[ui] Configuring early dark frame background colors...")
  (push '(foreground-color . "white") default-frame-alist)
  (push '(background-color . "#181818") default-frame-alist))

;; Establish default frame properties for any subsequent frames created
;; across client-server boundaries and adjust line padding.
(push '(font . "FiraCode Nerd Font") default-frame-alist)

;; Enforce UTF-8 as the universal default text encoding.
(message "[encoding] Setting default coding system to UTF-8...")
(prefer-coding-system 'utf-8)

(message "[early-init] Early-init execution complete.")
