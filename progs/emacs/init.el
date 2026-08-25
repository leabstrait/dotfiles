;; -*- lexical-binding: t; -*-

(require 'org)
(require 'ob-tangle)

(let ((config-org (expand-file-name "config.org" user-emacs-directory))
      (config-el  (expand-file-name "config.el" user-emacs-directory)))

  (when (and (file-exists-p config-org)
             (or (not (file-exists-p config-el))
                 (file-newer-than-file-p config-org config-el)))

    (message "Tangling %s -> %s"
             config-org
             config-el)

    (org-babel-tangle-file config-org config-el)))

(load (expand-file-name "config.el" user-emacs-directory)
      nil
      'nomessage)