;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here
;; Change doom theme
(setq doom-theme 'doom-one)
(setq doom-font (font-spec :family "PragmataPro Liga" :size 16 :adstyle "Regular"))
(setq +pretty-code-pragmata-pro-font-name "PragmataPro Liga")
;;(setq doom-unicode-font (font-spec :family "Noto Sans Mono" :size 16))
(setq doom-themes-treemacs-enable-variable-pitch nil)

;; Common settings
(setq-default fill-column 120)
(setq delete-by-moving-to-trash t)
(add-hook 'window-setup-hook #'toggle-frame-maximized)

;; Workarounds
;;(fset 'battery-update #'ignore)

;; Enable auto save
(setq auto-save-default t)
(add-hook! '(doom-switch-window-hook
             doom-switch-buffer-hook
             doom-switch-frame-hook
             focus-out-hook) ; frames
  (save-some-buffers t))

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
(setq org-directory "~/Dropbox/Notes")
(after! org
  (setq org-capture-templates '(("t" "Todo [inbox]" entry
                                 (file "~/Dropbox/Notes/inbox.org")
                                 "* TODO %i%?")
                                ("e" "Event [inbox]" entry
                                 (file "~/Dropbox/Notes/inbox.org")
                                 "* %i%? \n %U")))
  (setq org-todo-keywords '((sequence "TODO(t)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))
  (setq org-log-done 'time)
  (setq org-tag-alist '(("@work" . ?w) ("@home" . ?h) ("@omscs" . ?o)))
  (setq org-fast-tag-selection-single-key t)
  (setq org-show-context-detail '((agenda . local)
                                  (bookmark-jump . lineage)
                                  (isearch . lineage)
                                  (default . ancestors)))
  (setq org-refile-targets '(("~/Dropbox/Notes/todo.org" :maxlevel . 1)
                             ("~/Dropbox/Notes/someday.org" :maxlevel . 1)
                             ("~/Dropbox/Notes/tickler.org" :maxlevel . 1)
                             ("~/Dropbox/Notes/notes.org" :maxlevel . 1)))
  ;; agenda
  (setq org-agenda-todo-ignore-with-date 'far)
  (setq org-deadline-warning-days 7)
  ;; default agenda files
  (setq org-agenda-custom-commands
        '(
          ("A" "All agenda"
           (
            (todo "" ((org-agenda-files '("~/Dropbox/Notes/inbox.org"))
                      (org-agenda-overriding-header "Inbox")))
            (agenda "" ((org-agenda-span 7)
                        (org-agenda-start-day "-1d")
                        (org-agenda-files '("~/Dropbox/Notes/tickler.org"))))
            (tags-todo "@home" ((org-agenda-files '("~/Dropbox/Notes/todo.org"))
                                (org-agenda-overriding-header "Home")))
            (tags-todo "@work" ((org-agenda-files '("~/Dropbox/Notes/todo.org"))
                                (org-agenda-overriding-header "Work")))
            (tags-todo "@omscs" ((org-agenda-files '("~/Dropbox/Notes/todo.org"))
                                 (org-agenda-overriding-header "OMSCS")))
            (tags "-{.*}" ((org-agenda-files '("~/Dropbox/Notes/todo.org"
                                               "~/Dropbox/Notes/tickler.org"
                                               "~/Dropbox/Notes/someday.org"))
                           (org-agenda-overriding-header "Untagged")))
            ))

          ("h" "Home agenda"
           (
            (agenda "" ((org-agenda-span 7)
                        (org-agenda-start-day "-1d")
                        (org-agenda-files '("~/Dropbox/Notes/tickler.org"))))
            (tags-todo "@home" ((org-agenda-files '("~/Dropbox/Notes/todo.org"))
                                (org-agenda-overriding-header "Todo")))
            )
           (
            ;; only way to filter agenda by tag
            (org-agenda-tag-filter-preset '("+@home"))
            )
           )

          ("w" "Work agenda"
           (
            (agenda "" ((org-agenda-span 7)
                        (org-agenda-start-day "-1d")
                        (org-agenda-files '("~/Dropbox/Notes/tickler.org"))))
            (tags-todo "@work" ((org-agenda-files '("~/Dropbox/Notes/todo.org"))
                                (org-agenda-overriding-header "Todo")))
            )
           (
            ;; only way to filter agenda by tag
            (org-agenda-tag-filter-preset '("+@work"))
            )
           )

          ("o" "OMSCS agenda"
           (
            (agenda "" ((org-agenda-span 7)
                        (org-agenda-start-day "-1d")
                        (org-agenda-files '("~/Dropbox/Notes/tickler.org"))))
            (tags-todo "@omscs" ((org-agenda-files '("~/Dropbox/Notes/todo.org"))
                                 (org-agenda-overriding-header "Todo")))
            )
           (
            ;; only way to filter agenda by tag
            (org-agenda-tag-filter-preset '("+@omscs"))
            )
           )

          ))
  )

(add-hook! org-mode
  (visual-line-mode 1))

;; org-journal
(after! org-journal
  (setq org-journal-file-type 'yearly)
  (setq org-journal-file-format "%Y.org")
  (setq org-journal-enable-agenda-integration t)
  (setq org-journal-date-format "%e %b %Y (%A)")
  (setq org-journal-file-header "#+TITLE: Journal\n#+CATEGORY: journal\n#+STARTUP: folded")
  (setq org-journal-time-format "")
  (setq org-journal-find-file 'find-file)
  (setq org-journal-dir org-directory
        org-journal-cache-file (concat doom-cache-dir "org-journal")
        org-journal-file-pattern (org-journal-dir-and-format->regex
                                  org-journal-dir org-journal-file-format))

  (add-to-list 'auto-mode-alist (cons org-journal-file-pattern 'org-journal-mode))
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
;; Doesn't work yet.
;;(setq treemacs-set-scope-type 'Perspectives)

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
