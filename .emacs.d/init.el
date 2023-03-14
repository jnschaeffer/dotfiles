(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

;; paths
(setenv "PATH" (concat (getenv "PATH") ":~/go/bin"))
(setq exec-path (append exec-path '("~/go/bin")))

;; spellcheck
(setq ispell-program-name "hunspell")
(setq ispell-dictionary "en_US")

;; packages
(use-package project
  :config
  (defun project-find-go-module (dir)
    (when-let ((root (locate-dominating-file dir "go.mod")))
      (cons 'go-module root)))

  (cl-defmethod project-root ((project (head go-module)))
    (cdr project)))

(use-package magit
  :ensure t
  :config
  (setq auto-revert-buffer-list-filter
        'magit-auto-revert-repository-buffer-p))

(use-package eglot
  :ensure t
  :init
  (defun eglot-format-buffer-on-save ()
    (add-hook 'before-save-hook #'eglot-format-buffer -10 t))
  (add-hook 'project-find-functions #'project-find-go-module))

(use-package go-mode
  :ensure t
  :hook ((go-mode . eglot-ensure)
         (go-mode . eglot-format-buffer-on-save)))

(use-package mermaid-mode
  :ensure t)

(use-package markdown-mode
  :ensure t)

(use-package rfc-mode
  :ensure t)

(use-package yaml-mode
  :ensure t)

(use-package dockerfile-mode
  :ensure t)

;; indentz
(setq js-indent-level 2)

;; tramp stuff
;; disable VC, magit does the thing:
;; https://www.gnu.org/software/emacs/manual/html_node/tramp/Frequently-Asked-Questions.html
(setq vc-handled-backends nil)
(setq tramp-verbose 1)
(with-eval-after-load "tramp"
  (setq tramp-use-ssh-controlmaster-options nil)
  (add-to-list 'tramp-connection-properties
               (list (regexp-quote "/ssh:")
                     "direct-async-process" t)))

(setq-default indent-tabs-mode nil)
(setq-default column-number-mode 1)

;; mermaid stuff
(setq mermaid-mmdc-location "/usr/local/bin/docker")
(setq mermaid-flags "run -u 502 -v /tmp:/tmp ghcr.io/mermaid-js/mermaid-cli/mermaid-cli:9.1.6")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(kandinsky))
 '(custom-safe-themes
   '("d09c75617fa7ba510c0990b0f9e477a0ae0c0791af3f1dd9f4a53ef2d7b299ac" default))
 '(package-selected-packages
   '(dockerfile-mode multi-vterm use-package vterm eglot docker-tramp rfc-mode mermaid-mode markdown-mode flycheck yaml-mode rego-mode go-mode typescript-mode magit))
 '(warning-suppress-types '((auto-save))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :extend nil :stipple nil :background "#f7f4ed" :foreground "#242322" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 100 :width normal :foundry "nil" :family "Monaco")))))
