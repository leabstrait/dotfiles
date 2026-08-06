;; early-init.el --- Early Initialization Optimization -*- lexical-binding: t; -*-

;; Set initial frame background to match your dark theme background immediately
(add-to-list 'default-frame-alist '(background-color . "#1a1e24"))
(add-to-list 'initial-frame-alist '(background-color . "#1a1e24"))

;; Prevent GUI flash by disabling UI elements at the frame level
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars . nil) default-frame-alist) ; Fixed parameter name

;; Disable the modes natively before the graphical window even draws
(setq menu-bar-mode nil
      tool-bar-mode nil
      scroll-bar-mode nil)
