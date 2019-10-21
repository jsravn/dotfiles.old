;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here
;; Change doom theme
(setq doom-theme 'doom-one)
(setq doom-font (font-spec :family "Iosevka" :size 15))
(setq doom-unicode-font (font-spec :family "Noto Sans Mono" :size 15))

;; Common settings
(setq-default fill-column 120)
(setq delete-by-moving-to-trash t)

;; Projectile
(setq projectile-project-search-path '("~/lightbend/" "~/devel/"))
(after! projectile
  (setq projectile-globally-ignored-directories
        (append '(".metals") projectile-globally-ignored-directories))
)

; clear cache after checking out a new branch
(defun +private/projectile-invalidate-cache (&rest _args)
  (projectile-invalidate-cache nil))
(advice-add 'magit-checkout
            :after #'+private/projectile-invalidate-cache)
(advice-add 'magit-branch-and-checkout
            :after #'+private/projectile-invalidate-cache)

;; New code actions
(map! :leader
      (:prefix "c"
        :desc "Action at point (LSP)" "a" #'lsp-execute-code-action))

;; centered-window-mode
(setq cwm-centered-window-width 140)

;; org-mode
(setq org-directory "~/Dropbox/Notes")

;; Clipboard stuff
(setq select-enable-primary t)
(setq select-enable-clipboard t)

;; jsonnet
(setq jsonnet-library-search-directories (list "vendor"))
(after! flycheck (flycheck-define-checker jsonnetvendor
  "A Jsonnet syntax checker using the jsonnet binary.
See URL `https://jsonnet.org'."
  :command ("jsonnet" "-J" "vendor" source-inplace)
  :error-patterns
  ((error line-start "STATIC ERROR: " (file-name) ":" line ":" column (zero-or-one (group "-" (one-or-more digit))) ": " (message) line-end)
   (error line-start "RUNTIME ERROR: " (message) "\n" (one-or-more space) (file-name) ":" (zero-or-one "(") line ":" column (zero-or-more not-newline) line-end))
  :modes jsonnet-mode)
  (add-to-list 'flycheck-checkers 'jsonnetvendor)
)

;; olivetti
(setq olivetti-body-width 160)

;; Auto save
(use-package! super-save
  :init
  (setq super-save-auto-save-when-idle t)
  (setq auto-save-default nil))
  :config
  (super-save-mode 1)

;; Markdown
(add-hook! markdown-mode
  (visual-line-mode 1)
  (flycheck-mode 0)
  (setq fill-column 100))

;; Treemacs
(after! treemacs
  (treemacs-follow-mode 1)
  (setq treemacs-width 50))

(defun +private/treemacs-back-and-forth ()
  (interactive)
  (if (treemacs-is-treemacs-window-selected?)
      (aw-flip-window)
    (treemacs-select-window)))

(map! :after treemacs
      :leader
      :n "-" #'+private/treemacs-back-and-forth)

;; Popup mode
(set-popup-rule! "^\\*Treemacs" :ignore t)

;; magit tweaks
(setq magit-prefer-remote-upstream t)
; when doing b-l on a remote branch, it will set the upstream to origin/master
(setq magit-branch-adjust-remote-upstream-alist '(("origin/master" "master")))
