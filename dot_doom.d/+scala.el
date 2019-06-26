;;; ~/.doom.d/+scala.el -*- lexical-binding: t; -*-

(def-package! scala-mode
  :defer t
  :mode "\\.s\\(cala\\|bt\\)$")

(def-package! sbt-mode
  :defer t
  :commands sbt-start sbt-command
  :config
  ;; WORKAROUND: https://github.com/ensime/emacs-sbt-mode/issues/31
  ;; allows using SPACE when in the minibuffer
  (substitute-key-definition
   'minibuffer-complete-word
   'self-insert-command
   minibuffer-local-completion-map))

(add-hook 'scala-mode #'lsp!)
