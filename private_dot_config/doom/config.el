;;; ~/.config/doom/config.el -*- lexical-binding: t; -*-

;; UI
(setq doom-theme 'doom-one)
(setq doom-font (font-spec :family "PragmataPro Liga" :size 16 :adstyle "Regular"))
(setq +pretty-code-pragmata-pro-font-name "PragmataPro Liga")
(setq doom-themes-treemacs-enable-variable-pitch nil)
(setq-default fill-column 120)
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(setq split-width-threshold (* fill-column 2))

;; core behavior
(setq delete-by-moving-to-trash t)
(setq select-enable-primary t)
(setq select-enable-clipboard t)

;; always create a new workspace when switching projects
(setq +workspaces-on-switch-project-behavior t)

;; Modules

;; calendar
(setq calendar-latitude 51.508166)
(setq calendar-longitude -0.075971)
(setq calendar-location-name "London, UK")

;; Nicer wrapping in text modes - don't do hard breaks, use soft wraps.
(remove-hook 'text-mode-hook #'auto-fill-mode)
(add-hook 'text-mode-hook #'+word-wrap-mode)

;; zen
(after! writeroom-mode
  (setq +zen-text-scale 0
        +zen-mixed-pitch-modes nil
        writeroom-mode-line t
        writeroom-width 160))

;; Enable auto save when emacs frame loses focus.
(defun jsravn--save-buffers ()
  ;; Avoid saving when switching to a special buffer, like an ivy popup.
  (if (buffer-file-name) (save-some-buffers t)))
(add-hook! '(doom-switch-buffer-hook
             doom-switch-window-hook
             focus-out-hook)
           #'jsravn--save-buffers)

;; Create auto-save files in case the system crashes.
(setq auto-save-default t)

;; projectile
(setq projectile-project-search-path '("~/devel/" "~/sky/" "~/Dropbox" "~/gatech"))

;; Atomic chrome for editing browser text boxes.
(use-package! atomic-chrome
  :after-call focus-out-hook
  :config
  (setq atomic-chrome-default-major-mode 'markdown-mode
        atomic-chrome-buffer-open-style 'frame)
  (atomic-chrome-start-server))

;; Clear cache after checking out a new branch.
(defun +private/projectile-invalidate-cache (&rest _args)
  (projectile-invalidate-cache nil))
(advice-add 'magit-checkout
            :after #'+private/projectile-invalidate-cache)
(advice-add 'magit-branch-and-checkout
            :after #'+private/projectile-invalidate-cache)

;; org-mode
(load! "+org")
(setq org-directory "~/Dropbox/Notes/"
      org-archive-location (concat org-directory ".archive/%s::")
      org-roam-directory (concat org-directory "roam/")
      deft-directory org-roam-directory)

(after! org-journal
  (setq org-journal-date-prefix "#+TITLE: "
        org-journal-file-format "%Y-%m-%d.org"
        org-journal-dir org-roam-directory
        org-journal-date-format "%A, %d %B %Y"))

(after! org
  (setq org-capture-templates `(("t" "Todo [inbox]" entry
                                 (file ,(concat org-directory "inbox.org"))
                                 "* TODO %i%?")
                                ("e" "Event [inbox]" entry
                                 (file ,(concat org-directory "inbox.org"))
                                 "* %i%? \n %U")
                                ("n" "Note [inbox]" entry
                                 (file ,(concat org-directory "inbox.org"))
                                 "* %?")
                                ("s" "Shopping [todo]" checkitem
                                 (file+olp ,(concat org-directory "todo.org") "Home" "Shopping")
                                 "- [ ] %?"))
        org-todo-keywords '((sequence "TODO(t)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)"))
        org-log-done 'time
        org-tag-alist '(("@work" . ?w) ("@home" . ?h) ("@omscs" . ?o))
        org-fast-tag-selection-single-key t
        org-show-context-detail '((agenda . local)
                                  (bookmark-jump . lineage)
                                  (isearch . lineage)
                                  (default . ancestors))
        org-refile-targets '(("~/Dropbox/Notes/todo.org" :maxlevel . 2)
                             ("~/Dropbox/Notes/someday.org" :maxlevel . 1)
                             ("~/Dropbox/Notes/tickler.org" :maxlevel . 2)
                             ("~/Dropbox/Notes/notes.org" :maxlevel . 2))
        org-archive-subtree-add-inherited-tags t

        ;; agenda
        org-agenda-text-search-extra-files '(agenda-archives)
        org-agenda-search-view-always-boolean t
        org-agenda-todo-ignore-with-date 'far
        org-deadline-warning-days 14
        org-agenda-custom-commands (list (jsravn--all-agenda)
                                         (jsravn--agenda "home")
                                         (jsravn--agenda "work")
                                         (jsravn--agenda "omscs"))))

(after! org-download
  (setq org-download-screenshot-method
        (cond (IS-MAC "screencapture -i %s")
              (IS-LINUX "~/.config/sway/capture.sh %s"))))

(setq org-roam-buffer-no-delete-other-windows t)
(after! org-roam
  (add-hook 'doom-switch-buffer-hook #'jsravn--open-org-roam))

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
  (add-to-list 'flycheck-checkers 'jsonnetvendor))

;; markdown
(add-hook! markdown-mode
  (visual-line-mode 1)
  (flycheck-mode 0)
  (setq fill-column 100))

(after! treemacs
  (treemacs-follow-mode 1)
  (setq treemacs-width 40))

;; magit tweaks
(setq magit-prefer-remote-upstream t)
;; when doing b-l on a remote branch, it will set the upstream to origin/master
(setq magit-branch-adjust-remote-upstream-alist '(("origin/master" "master")))
;; when doing b-c default origin/master as the branching point when possible
(setq magit-branch-prefer-remote-upstream '("master"))
;; limit status buffer to 15 open topics and 5 closed topics
(setq forge-topic-list-limit '(15 . 5))

;; lsp-mode tweaks
;; causes an interactive prompt always - useful for subprojects
(setq lsp-auto-guess-root nil)

;; scala-mode tweaks
(after! scala-mode (setq scala-indent:align-parameters nil))
