;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here
;; Change doom theme
(setq doom-theme 'doom-one)
(setq doom-font (font-spec :family "Iosevka" :size 16 :adstyle "Regular"))
(setq doom-unicode-font (font-spec :family "Noto Sans Mono" :size 16))
(setq doom-themes-treemacs-enable-variable-pitch nil)

;; Common settings
(setq-default fill-column 120)
(setq delete-by-moving-to-trash t)

;; Workarounds
(fset 'battery-update #'ignore)

;; Enable auto save
(setq auto-save-default t)

;; Projectile
(setq projectile-project-search-path '("~/lightbend/" "~/devel/" "~/sky/" "~/Dropbox"))
(after! projectile
  (setq projectile-globally-ignored-directories
        (append '(".metals") projectile-globally-ignored-directories))
  )

;; clear cache after checking out a new branch
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

;; org-mode
(after! org
  (setq org-directory "~/Dropbox/Notes")
  (setq org-capture-templates '(("t" "Todo [inbox]" entry
                                 (file+headline "~/Dropbox/Notes/inbox.org" "Tasks")
                                 "* TODO %i%?")
                                ("T" "Tickler" entry
                                 (file+headline "~/Dropbox/Notes/tickler.org" "Tickler")
                                 "* %i%? \n %U")))
  (setq org-refile-targets '(("~/Dropbox/Notes/todo.org" :maxlevel . 3)
                             ("~/Dropbox/Notes/tickler.org" :maxlevel . 2)
                             ("~/Dropbox/Notes/someday.org" :maxlevel . 2)))
  (setq org-todo-keywords '((sequence "TODO(t)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))
  (setq org-agenda-custom-commands
        '(("o" "At the office" tags-todo "@office"
           ((org-agenda-overriding-header "Office")))
          ("h" "At home" tags-todo "@home"
           ((org-agenda-overriding-header "Home"))
           )))
  )
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

;; magit tweaks
(setq magit-prefer-remote-upstream t)
;; when doing b-l on a remote branch, it will set the upstream to origin/master
(setq magit-branch-adjust-remote-upstream-alist '(("origin/master" "master")))
;; when doing b-c default origin/master as the branching point when possible
(setq magit-branch-prefer-remote-upstream '("master"))

;; lsp-mode tweaks
(setq lsp-auto-guess-root nil)

;; scala-mode tweaks
(after! scala-mode (setq scala-indent:align-parameters nil))
