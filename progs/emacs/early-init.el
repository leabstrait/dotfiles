;;; early-init.el --- Early Initialization Optimization -*- lexical-binding: t; -*-

;; Defer Garbage Collection heavily during startup
(setq gc-cons-threshold (* 50 1024 1024))

;; Prevent early UI flashes by stripping decorations before the frame is drawn
;; Clear layout clutter before initial display configuration maps spawn
(push '(scroll-bar-lines . 0) default-frame-alist)
(push '(tab-bar-lines . 0) default-frame-alist)
(push '(menu-bar-lines . 1) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars . nil) default-frame-alist)

;; Inhibit native compilation warning buffers from popping up
(setq native-comp-async-report-warnings-errors 'silent)

;; Completely disable startup splash screens
(setq inhibit-startup-message t
      inhibit-startup-screen t
      inhibit-startup-echo-area-message user-login-name
      native-comp-async-report-warnings-errors 'silent)
