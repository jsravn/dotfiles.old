;;; personal.el --- James Ravn's personal settings for prelude emacs
;;; Commentary:

;;; Code:
(setq guru-warn-only t)
(projectile-mode)
(setq x-select-enable-primary t)
(setq x-select-enable-clipboard t)
(setq ido-use-virtual-buffers t)
(prelude-require-packages '(evil markdown-mode robe enh-ruby-mode rust-mode ghc company-ghc hindent auctex intero))
(evil-mode 1)
(add-hook 'after-init-hook 'global-company-mode)
(setq visible-bell 1)
(global-linum-mode 1)
(setq browse-url-browser-function 'browse-url-chromium)
(setq magit-last-seen-setup-instructions "1.4.0")
(setq linum-format "%4d \u2502 ")
(let ((my-local-path (expand-file-name "~/.local/bin")))
  (setenv "PATH" (concat my-local-path path-separator (getenv "PATH")))
  (add-to-list 'exec-path my-local-path))

;; evil mode tweaks per major mode
(evil-set-initial-state 'haskell-interactive-mode 'emacs)
(evil-set-initial-state 'haskell-error-mode 'emacs)
(evil-set-initial-state 'git-commit-mode 'insert)
(evil-set-initial-state 'neotree-mode 'emacs)
(evil-set-initial-state 'shell-mode 'emacs)
(evil-set-initial-state 'intero-repl-mode 'emacs)
(define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)

;; prelude tweaks
(prelude-mode 1)
(setq prelude-whitespace nil)
(setq prelude-flyspell nil)

;; ruby
(add-hook 'enh-ruby-mode-hook 'robe-mode)

;; haskell
(add-hook 'haskell-mode-hook (lambda ()
                               (intero-mode)
                               (hindent-mode)))
(custom-set-variables
 '(haskell-stylish-on-save t))

;; org
(setq org-export-backends '(docbook html beamer ascii latex md))

;; go-lang
(add-hook 'go-mode-hook
  (lambda ()
    (setq tab-width 8)
    (setq indent-tabs-mode 1)))

;; auctex
(setq TeX-auto-save t)
(setq TeX-parse-self t)

;; c-mode
;; switch between source/header files easily
(add-hook 'c-mode-common-hook
  (lambda()
    (local-set-key  (kbd "<C-tab>") 'ff-find-other-file)))

;; server for opening files with emacsclient -n $file
(server-start)
;;; settings.el ends here
