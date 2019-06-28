;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here
;; Change doom theme
(setq doom-theme 'doom-one)
(setq doom-font (font-spec :family "DejaVu Sans Mono"))

;; Projectile
(setq projectile-project-search-path '("~/lightbend/" "~/devel/"))
(after! projectile
  (setq projectile-globally-ignored-directories
        (append '(".metals") projectile-globally-ignored-directories))
)

;; Clipboard stuff
(setq select-enable-primary t)
(setq select-enable-clipboard t)

;; Auto save
(def-package! super-save
  :init
  (setq super-save-auto-save-when-idle t)
  (setq auto-save-default nil))
  :config
  (super-save-mode 1)

;; Start maximized
(toggle-frame-maximized)

;; Markdown
(add-hook! markdown-mode
  (visual-line-mode 1))

;; Treemacs
(after! treemacs
  (treemacs-follow-mode 1))

;; Disable smartparens comment continuation behaviour
(after! smartparens
  (advice-remove #'newline-and-indent #'+default*newline-indent-and-continue-comments))

;; Scala
(add-hook! scala-mode
  (map!
   :leader
   :prefix "c"
   :desc "Run scalafmt" "f" #'lsp-format-buffer))
