;;; tools/magit/config.el -*- lexical-binding: t; -*-

(defvar +magit-hub-features
  '(pull-request-merge commit-browse completion)
  "TODO")


;;
;; Plugins
;;

(def-package! magit
  :defer t
  :config
  (setq magit-completing-read-function
        (if (featurep! :completion ivy)
            #'ivy-completing-read
          #'magit-builtin-completing-read)
        magit-revision-show-gravatars '("^Author:     " . "^Commit:     "))

  (set! :popup "^\\(?:\\*magit\\|magit:\\)" :ignore)
  ;; no mode-line in magit popups
  (add-hook 'magit-popup-mode-hook #'hide-mode-line-mode)
  ;; Clean up after magit by properly killing buffers
  (map! :map magit-status-mode-map [remap magit-mode-bury-buffer] #'+magit/quit))


(def-package! magit-blame :after git-timemachine)


(def-package! magithub
  :when (featurep! +hub)
  :after magit
  :preface
  (setq magithub-dir (concat doom-etc-dir "magithub/"))
  :init
  (setq magithub-clone-default-directory "~/"
        magithub-preferred-remote-method 'clone_url)
  :config
  (magithub-feature-autoinject +magit-hub-features))


(def-package! magit-gitflow
  :hook (magit-mode . turn-on-magit-gitflow))


(def-package! evil-magit
  :when (featurep! :feature evil +everywhere)
  :after magit
  :init (setq evil-magit-state 'normal)
  :config
  (map! :map (magit-mode-map magit-blame-read-only-mode-map)
        doom-leader-key nil))
