;; -*- lexical-binding: t; -*-
(require 'package)
(push "~/.emacs.d/lisp" load-path)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; paths
(setenv "PATH" (concat (getenv "PATH") ":~/go/bin:/nix/var/nix/profiles/default/bin"))
(setq exec-path (append exec-path '("~/go/bin" "/nix/var/nix/profiles/default/bin/nix")))

;; spellcheck
(setq ispell-program-name "aspell")

;; general formatting
(setq-default subword-mode t)

;; tree sitting
(setq treesit-language-source-alist
   '((bash "https://github.com/tree-sitter/tree-sitter-bash" "v0.23.3")
     (cmake "https://github.com/uyha/tree-sitter-cmake")
     (css "https://github.com/tree-sitter/tree-sitter-css")
     (elisp "https://github.com/Wilfred/tree-sitter-elisp")
     (go "https://github.com/tree-sitter/tree-sitter-go" "v0.23.4")
     (gomod "https://github.com/camdencheek/tree-sitter-go-mod")
     (html "https://github.com/tree-sitter/tree-sitter-html")
     (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "v0.23.3" "src")
     (json "https://github.com/tree-sitter/tree-sitter-json")
     (make "https://github.com/alemuller/tree-sitter-make")
     (markdown "https://github.com/tree-sitter-grammars/tree-sitter-markdown" "v0.2.3" "tree-sitter-markdown/src")
     (markdown-inline "https://github.com/tree-sitter-grammars/tree-sitter-markdown" "v0.2.3" "tree-sitter-markdown-inline/src")
     (nix "https://github.com/nix-community/tree-sitter-nix")
     (python "https://github.com/tree-sitter/tree-sitter-nix")
     (python "https://github.com/tree-sitter/tree-sitter-python")
     (rust "https://github.com/tree-sitter/tree-sitter-rust" "v0.23.3")
     (toml "https://github.com/tree-sitter/tree-sitter-toml")
     (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
     (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
     (yaml "https://github.com/ikatyang/tree-sitter-yaml")))

;; eglot
(setq eglot-server-programs
      '(((typescript-ts-mode tsx-ts-mode) "typescript-language-server" "--stdio")
        ((go-ts-mode) "gopls")
        ((rust-mode) "rust-analyzer")))

;; org
(require 'ol-man)
(setq org-agenda-files '("~/org/zet.org"))
(setq org-refile-targets '(("~/org/zet.org" . (:maxlevel . 5))))
(setq org-id-link-to-org-use-id t)
(setq org-agenda-restore-windows-after-quit t)
(setq org-agenda-follow-indirect t)
(setq org-agenda-start-with-follow-mode t)
(setq org-capture-templates
      '(("a" "Analysis" entry (file+headline "~/org/zet.org" "Unfiled") "* %^{Title}\n:PROPERTIES:\n:ID: %(org-id-new)\n:TIMESTAMP: %t\n:END:\n\n%?")
        ("f" "File" entry (file+headline "~/org/zet.org" "Unfiled") "* %^{Title} (%f)\n:PROPERTIES:\n:ID: %(org-id-new)\n:TIMESTAMP: %t\n:END:\n\n%?\n\n[[%L][Source]]")
        ("l" "Link" entry (file+headline "~/org/zet.org" "Unfiled") "* %^{Title}\n:PROPERTIES:\n:ID: %(org-id-new)\n:TIMESTAMP: %t\n:END:\n\n%?\n\n[[%^{URL}][Source]]")
        ("r" "Reference" entry (file+headline "~/org/zet.org" "Unfiled") "* %^{Title}\n:PROPERTIES:\n:ID: %(org-id-new)\n:TIMESTAMP: %t\n:END:\n\n%?\n\n[[%L][Source]]")))

(use-package org
  :config
  (require 'ox-md)
  :hook
  ((org-mode . visual-line-mode))
  :bind
  (("C-c l" . org-store-link)
   ("C-c a" . org-agenda)
   ("C-c c" . org-capture)))

;; distraction

(setopt display-time-mode t)
(setopt display-battery-mode t)
(setopt display-time-24hr-format t)
(setopt tool-bar-mode nil)
(setopt menu-bar-mode nil)
(global-set-key (kbd "C-x m") #'man)

;; tramp

(setq system-auth-sources '((gnu/linux . (:source (:secrets "Login")))
                            (darwin . (:source (:macos-generic-keychain "")))))

(defun choose-auth-sources ()
  "Chooses an appropriate value for auth-sources based on system-type. If
no source exists for the current system type, the function returns the
default value for auth-sources."
  (let ((system-source (alist-get system-type system-auth-sources)))
    (if system-source
        (list system-source)
      '("~/.authinfo" "~/.authinfo.gpg" "~/.netrc"))))

(setq auth-sources (choose-auth-sources))

;; AI

(defun pilish-sandbox ()
  (let* ((proj (project-current))
         (proj-root (if proj (project-root proj) default-directory))
         (root-path (expand-file-name proj-root)))
    `("bwrap"
      "--ro-bind" "/usr" "/usr"
      "--symlink" "/usr/bin" "/bin"
      "--symlink" "/usr/lib" "/lib"
      "--symlink" "/usr/lib64" "/lib64"
      "--dev" "/dev"
      "--ro-bind" "/etc" "/etc"
      "--ro-bind" "/home/john/.nvm" "/home/john/.nvm"
      "--ro-bind" "/home/john/.local/bin" "/home/john/.local/bin"
      "--ro-bind" "/home/john/.kube/config" "/home/john/.kube/config"
      "--ro-bind" "/home/john/.minikube" "/home/john/.minikube"
      "--bind" "/home/john/.pi" "/home/john/.pi"
      "--bind" ,root-path ,root-path
      "--chdir" ,root-path
      "--"
      "pi")))

(advice-add 'pilish :before
            (lambda (&rest _)
              (setq pilish-executable (pilish-sandbox))))

;; Packages
(use-package project
  :config
  (setq project-vc-extra-root-markers '("Cargo.toml" "go.mod" "tsconfig.json")))

(use-package magit
  :ensure t
  :config
  (setq auto-revert-buffer-list-filter
        'magit-auto-revert-repository-buffer-p))

(use-package mermaid-mode
  :ensure t)

(use-package markdown-mode
  :ensure t
  :hook
  ((markdown-mode . visual-line-mode)))

(use-package rfc-mode
  :ensure t)

(use-package yaml-mode
  :ensure t)

(use-package dockerfile-mode
  :ensure t)

(use-package rust-mode
  :ensure t
  :init
  (setq rust-mode-treesitter-derive t)
  (setq rust-format-on-save t)
  :hook ((rust-mode . eglot-ensure)))

(use-package terraform-mode
  :ensure t
  :init
  (setq terraform-command "tofu"))

(use-package prettier-js
  :ensure t
  :init
  (setq prettier-js-use-modules-bin t))

(use-package git-link
  :ensure t
  :bind (("C-c g l" . git-link)))

(use-package protobuf-mode
  :ensure t)

(use-package envrc
  :ensure t
  :hook (after-init . envrc-global-mode))

(use-package go-ts-mode
  :mode "\\.go\\'"
  :ensure t
  :hook ((go-ts-mode . eglot-ensure)
         (before-save . eglot-format-buffer)))

(use-package go-mod-ts-mode
  :mode "/go.mod\\'"
  :hook
  (go-ts-mode . eglot-ensure)
  (before-save-hook . eglot-format-buffer))

(use-package man
  :bind (("C-x m" . man)))

(use-package nix-ts-mode
  :mode "\\.nix\\'")

(use-package consult
  :ensure t
  :bind (("M-s g" . consult-git-grep)))

(defun maybe-use-prettier ()
  "Enable `prettier-js-mode' if an rc file is located."
  (if (locate-dominating-file default-directory ".prettierrc")
      (prettier-js-mode +1)))

(use-package typescript-ts-mode
  :mode "\\.ts\\'"
  :hook
  ((typescript-ts-mode . maybe-use-prettier)
   (typescript-ts-mode . (lambda () (setq tab-width 2)))))

(use-package tsx-ts-mode
  :mode "\\.tsx\\'"
  :hook
  ((typescript-tsx-mode . maybe-use-prettier)
   (typescript-tsx-mode . (lambda () (setq tab-width 2)))))

(use-package vterm
  :ensure t
  :bind ("C-x v" . vterm))

(use-package pilish
  :ensure t)

(setq-default js-indent-level 2)
(setq-default indent-tabs-mode nil)
(setq-default column-number-mode 1)

;; mermaid stuff
(setq mermaid-mmdc-location "/usr/local/bin/docker")
(setq mermaid-flags "run -u 502 --rm -v /tmp:/tmp ghcr.io/mermaid-js/mermaid-cli/mermaid-cli:11.4.0 --theme neutral")

;; set a default font size
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(kandinsky))
 '(custom-safe-themes
   '("5fae372b34cd430facfda55f43b54e6971c2aef458c455537a3f689f2b4f18c8"
     "26ea4f99a470096bfa6ada7ee97e97e713ec6c9174b37a19e1856bc863024cc5"
     "d09c75617fa7ba510c0990b0f9e477a0ae0c0791af3f1dd9f4a53ef2d7b299ac"
     default))
 '(package-selected-packages
   '(consult dockerfile-mode envrc git-link magit markdown-mode
             mermaid-mode pilish prettier-js protobuf-mode rfc-mode
             rust-mode terraform-mode vterm yaml-mode))
 '(pi-coding-agent-grammar-declined-set
   '(c cpp ruby java lua dockerfile c-sharp clojure elixir haskell heex
       kotlin php scala))
 '(warning-suppress-types '((auto-save))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :extend nil :stipple nil :background "#f7f3e9" :foreground "#242322" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight regular :height 85 :width normal :foundry "IBM " :family "IBM Plex Mono")))))
