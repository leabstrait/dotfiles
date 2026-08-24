;; early-init.el --- Early Initialization Optimization -*- lexical-binding: t; -*-

;; Make startup faster by reducing the frequency of garbage collection. This will be set back when startup finishes.
;; We also increase Read Process Output Max so Emacs can read more data.

;; Set garbage collector (from doom emacs)
;; About 0.02 faster
(setq gc-cons-threshold (* 1024 1024 128)  ; 128mb
      gc-cons-percentage 1.0) ; Disable the dynamic percentage trigger to ensure GC frequency is fixed.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; 1. Startup Speed Optimizations                                                ;;
;; (setq gc-cons-threshold (* 100 1024 1024)                                        ;;
;;       read-process-output-max (* 1024 1024)) ; 1MB max read size for fast LSP    ;;
;;                                                                                  ;;
;; (add-hook 'emacs-startup-hook                                                    ;;
;;   (lambda ()                                                                     ;;
;;           (setq gc-cons-threshold (* 2 1024 1024))))                             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Runtime performance
;; Dial the GC threshold back down so that garbage collection happens more frequently but in less time.
;; Make GC pauses faster by decreasing the threshold.
;; About 0.02 faster
(add-hook 'emacs-startup-hook (lambda ()
                                (setq gc-cons-threshold (* 1024 1024 2) ; 2mb
                                      gc-cons-percentage 0.2)))

;; Increase the amount of data which Emacs reads from the process
(setq read-process-output-max (* 1024 1024)) ; 1mb

;; Unset file-name-handler-alist
;; About 0.07 faster
(defvar last-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)
(add-hook 'after-init-hook
          (lambda ()
            (setq file-name-handler-alist last-file-name-handler-alist)))




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; 2. Package Management (Emacs 29+)                                      ;;
;; (require 'package)                                                        ;;
;; (setq package-archives '(("gnu"    . "https://elpa.gnu.org/packages/")    ;;
;;                          ("nongnu" . "https://elpa.nongnu.org/packages/") ;;
;;                          ("melpa"  . "https://melpa.org/packages/")))     ;;
;;                                                                           ;;
;; Fetch the package list automatically if it doesn't exist                  ;;
;; (unless package-archive-contents                                          ;;
;;   (package-refresh-contents))                                             ;;
;;                                                                           ;;
;; (require 'use-package)                                                    ;;
;; (setq use-package-always-ensure t)                                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;; Fix white flash on startup
;; Don't do it when using daemon or terminal, because it messes up the background color.
;; (unless (or (daemonp) (not initial-window-system))
;;   (setq default-frame-alist '(
;;                               (foreground-color . "white")
;;                               (background-color . "#181818"))))

;; Set initial frame background to match your dark theme background immediately
(add-to-list 'default-frame-alist '(background-color . "#1a1e24"))
(add-to-list 'initial-frame-alist '(background-color . "#1a1e24"))

(set-face-attribute 'mode-line nil :background "DarkSlateGray" :foreground "white")
(set-face-attribute 'mode-line-inactive nil :background "gray30" :foreground "gray70")


;; Disable UI elements before UI initialization.
;; For faster startup times. It gives 0.05 sec.
(setq menu-bar-mode nil)         ; Disable the menu bar
(setq tool-bar-mode nil)         ; Disable the tool bar
(push '(vertical-scroll-bars) default-frame-alist) ; Disable the scroll bar

;; Prevent GUI flash by disabling UI elements at the frame level
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars . nil) default-frame-alist) ; Fixed parameter name

;; Disable the modes natively before the graphical window even draws
(setq menu-bar-mode nil
      tool-bar-mode nil
      scroll-bar-mode nil)

;;; FONTS
;; Startup about 0.01 faster
(set-face-attribute 'default nil
                    ;; :font "JetBrains Mono" ; Set your favorite type of font or download JetBrains Mono
                    :font "FiraCode Nerd Font" ; Set your favorite type of font or download FiraCode Nerd Font Mono
                    :height 120
                    :weight 'medium)
;; This sets the default font on all graphical frames created after restarting Emacs.
;; Does the same thing as 'set-face-attribute default' above, but emacsclient fonts
;; are not right unless I also add this method of setting the default font.
(add-to-list 'default-frame-alist '(font . "FiraCode Nerd Font")) ; Set your favorite font

(setq-default line-spacing 0.12)

(prefer-coding-system 'utf-8)


;; Ligatures
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;; 3. Literate Configuration Load                                               ;;
 (let ((literate-config (expand-file-name "config.org" user-emacs-directory)))   ;;
   (if (file-exists-p literate-config)                                           ;;
       (org-babel-load-file literate-config)                                     ;;
     (message "Warning: config.org file not found in %s" user-emacs-directory))) ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; 4. Isolate Custom Variables
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

