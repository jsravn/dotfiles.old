;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here
;; Change doom theme
(setq doom-theme 'doom-one)
(setq doom-font (font-spec :family "DejaVu Sans Mono" :size 15))

;; Common settings
(setq-default fill-column 120)

;; Projectile
(setq projectile-project-search-path '("~/lightbend/" "~/devel/"))
(after! projectile
  (setq projectile-globally-ignored-directories
        (append '(".metals") projectile-globally-ignored-directories))
)

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
