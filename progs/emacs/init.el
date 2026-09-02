;; -*- lexical-binding: t; -*-

(let ((config-org (expand-file-name "config.org" user-emacs-directory))
      (config-el  (expand-file-name "config.el" user-emacs-directory)))

  ;; Automatically re-tangle config.org if it has been modified
  ;; more recently than config.el, or if config.el doesn't exist yet.
  (when (and (file-exists-p config-org)
             (or (not (file-exists-p config-el))
                 (file-newer-than-file-p config-org config-el)))
    (message "Changes detected in config.org. Starting tangle process...")
    (require 'org)
    (org-babel-tangle-file config-org config-el)
    (message "Successfully completed tangling: %s -> %s" config-org config-el)))

;; Load the generated configuration file with fallback logging
(let ((config-el (expand-file-name "config.el" user-emacs-directory)))
  (if (file-exists-p config-el)
      (progn
        (message "Loading Emacs configuration from %s" config-el)
        (load config-el nil 'nomessage))
    (message "Error: Expected configuration file %s does not exist." config-el)))
