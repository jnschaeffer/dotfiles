;; global setup things
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives
	     '("org" . "http://orgmode.org/elpa/") t)
(package-initialize)

(setq geiser-active-implementations '(guile chicken))
(setq geiser-default-implementation 'guile)
(setq geiser-chicken-binary "/usr/bin/chicken-csi")

(setq inferior-lisp-program "/usr/bin/clisp")
(setq slime-contribs '(slime-fancy))

(column-number-mode)
(setq-default fill-column 80)

;; no tabz
(setq-default indent-tabs-mode nil)

;; paredit stuff
(add-hook 'clojure-mode-hook 'paredit-mode)
(add-hook 'emacs-lisp-hook 'paredit-mode)

;; go stuff
(add-to-list 'exec-path "/usr/local/go/bin")
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/go/bin"))
(add-hook 'before-save-hook #'gofmt-before-save)

;; python stuff
(setq-default blacken-executable "/home/john/.local/bin/black")
(add-hook 'python-mode-hook 'blacken-mode)

;; rust stuff
(with-eval-after-load 'rust-mode
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

;; ocaml/merlin stuff

; Make company aware of merlin
(with-eval-after-load 'company
 (add-to-list 'company-backends 'merlin-company-backend))
; Enable company on merlin managed buffers
(add-hook 'merlin-mode-hook 'company-mode)

;; racket stuff
(defun setup-racket-mode ()
  (interactive)
  (paredit-mode)
  (bind-keys :map paredit-mode-map
	     ("{"   . paredit-open-curly)
	     ("}"   . paredit-close-curly))
  (unless terminal-frame
    (bind-keys :map paredit-mode-map
	       ("M-[" . paredit-wrap-square)
	       ("M-{" . paredit-wrap-curly))))

(add-hook 'racket-mode-hook #'setup-racket-mode)

;; hate tool bar. i hate it
(tool-bar-mode -1)

;; magit
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x M-g") 'magit-dispatch-popup)

;; terminal
(defun on-frame-open (frame)
  (if (not (display-graphic-p frame))
    (set-face-background 'default "unspecified-bg" frame)))
(on-frame-open (selected-frame))
(add-hook 'after-make-frame-functions 'on-frame-open)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auth-source-save-behavior nil)
 '(custom-enabled-themes '(kandinsky))
 '(custom-safe-themes
   '("26ea4f99a470096bfa6ada7ee97e97e713ec6c9174b37a19e1856bc863024cc5" "9e1d71b9a1a3514fbdac2baea5c35a8c41e19f8c0ba69bc72627ea23265a4d18" "e0fa7a95dd48f0e02ac1fc2d7f9761efe0e5127020a5a30b2a21156764e6b5e3" "c985727ca83a528db20afd9af04a056d16f50820dca81dbe1c58f8d648446a77" default))
 '(flycheck-go-build-executable "/usr/local/go/bin/go")
 '(gofmt-command "/home/john/src/go/bin/goimports")
 '(package-selected-packages
   '(rfc-mode blacken go-mode cider clojure-mode sibilant-mode markdown-mode use-package racket-mode paredit yaml-mode dockerfile-mode flycheck-rust gnugo magit gmpl-mode meadowlands-theme rust-mode protobuf-mode org geiser)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#f6eed4" :foreground "#231b0a" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 80 :width normal :family "xos4 Terminus")))))
;; ## added by OPAM user-setup for emacs / base ## 56ab50dc8996d2bb95e7856a6eddb17b ## you can edit, but keep this line
(require 'opam-user-setup "~/.emacs.d/opam-user-setup.el")
;; ## end of OPAM user-setup addition for emacs / base ## keep this line
