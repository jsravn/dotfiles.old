;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here
;; Change doom theme
(setq doom-theme 'doom-one)
(setq doom-font (font-spec :family "DejaVu Sans Mono"))

;; Add projectile projects
(setq projectile-project-search-path '("~/lightbend/" "~/devel/"))

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

;; Scala mode
;; (def-package! scala-mode
;;   :mode "\\.s\\(cala\\|bt\\)$")
;; (def-package! sbt-mode
;;   :commands sbt-start sbt-command
;;   :config
;;   ;; WORKAROUND: https://github.com/ensime/emacs-sbt-mode/issues/31
;;   ;; allows using SPACE when in the minibuffer
;;   (substitute-key-definition
;;    'minibuffer-complete-word
;;    'self-insert-command
;;    minibuffer-local-completion-map))
;; (def-package! lsp-mode
;;   ;; Optional - enable lsp-mode automatically in scala files
;;   :hook (scala-mode . lsp)
;;   :config (setq lsp-prefer-flymake nil))
;; (def-package! lsp-ui)
;; (def-package! company-lsp)
;; (use-package flycheck
;;   :init (global-flycheck-mode))
