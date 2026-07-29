;; early-init.el --- Early Initialization Optimization -*- lexical-binding: t; -*-


;; Place this in ~/.emacs.d/early-init.el

;; Set initial frame background to match your dark theme background immediately
(add-to-list 'default-frame-alist '(background-color . "#1a1e24"))
(add-to-list 'initial-frame-alist '(background-color . "#1a1e24"))

;; Prevent GUI flash from tool-bar/menu-bar rendering
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(scroll-bar-mode . nil) default-frame-alist)
