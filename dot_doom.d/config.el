;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-
;; Place your private configuration here
;; Change doom theme
(setq doom-theme 'doom-one)
(setq doom-font (font-spec :family "PragmataPro Liga" :size 16 :adstyle "Regular"))
(setq +pretty-code-pragmata-pro-font-name "PragmataPro Liga")
(setq doom-themes-treemacs-enable-variable-pitch nil)

;; Common settings
(setq-default fill-column 120)
(setq delete-by-moving-to-trash t)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; evil-snipe
(evil-snipe-override-mode 1)

;; Calendar
(setq calendar-latitude 51.468)
(setq calendar-longitude -0.276)
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

;; Enable auto save
(add-hook! '(doom-switch-window-hook
             doom-switch-buffer-hook
             doom-switch-frame-hook
             focus-out-hook) ; frames
  (save-some-buffers t))

;; Projectile
(setq projectile-project-search-path '("~/devel/" "~/sky/" "~/Dropbox" "~/gatech"))

;; Atomic chrome for editing browser text boxes
(use-package! atomic-chrome
  :after-call focus-out-hook
  :config
  (setq atomic-chrome-default-major-mode 'markdown-mode
        atomic-chrome-buffer-open-style 'frame)
  (atomic-chrome-start-server))

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
;; (map!
;;  :after org
;;  :map org-mode-map
;;  :ni [M-return] #'org-insert-heading-respect-content)
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
  (setq org-refile-targets '(("~/Dropbox/Notes/todo.org" :maxlevel . 2)
                             ("~/Dropbox/Notes/someday.org" :maxlevel . 1)
                             ("~/Dropbox/Notes/tickler.org" :maxlevel . 2)
                             ("~/Dropbox/Notes/notes.org" :maxlevel . 2)))
  (setq org-archive-subtree-add-inherited-tags t)

  (defadvice! +org--fix-inconsistent-uuidgen-case (orig-fn &rest args)
    "Ensure uuidgen always produces lowercase output regardless of system."
    :around #'org-id-new
    (if (equal org-id-method 'uuid)
        (downcase (apply orig-fn args))
      (apply orig-fn args)))
  ;; agenda
  ;; include archive files when searching
  (setq org-agenda-text-search-extra-files '(agenda-archives))
  ;; use lazy boolean search rather than strict by default
  (setq org-agenda-search-view-always-boolean t)
  (setq org-agenda-todo-ignore-with-date 'far)
  (setq org-deadline-warning-days 14)
  ;; default agenda files
  (setq org-agenda-custom-commands
        '(
          ("A" "All agenda"
           (
            (todo "" ((org-agenda-files '("~/Dropbox/Notes/inbox.org"))
                      (org-agenda-overriding-header "Inbox")))
            (tags "-{.*}" ((org-agenda-files '("~/Dropbox/Notes/todo.org"
                                               "~/Dropbox/Notes/tickler.org"
                                               "~/Dropbox/Notes/someday.org"))
                           (org-agenda-overriding-header "Untagged")))
            (agenda "" ((org-agenda-span 7)
                        (org-agenda-start-day "-1d")
                        (org-agenda-files '("~/Dropbox/Notes/tickler.org"
                                            "~/Dropbox/Notes/todo.org"))
                        (org-agenda-skip-function #'my-org-agenda-skip-scheduled-if-in-todo)))
            (tags-todo "@home" ((org-agenda-files '("~/Dropbox/Notes/todo.org"))
                                (org-agenda-overriding-header "Home")
                                (org-agenda-skip-function #'my-org-agenda-skip-all-siblings-but-first)))
            (tags-todo "@work" ((org-agenda-files '("~/Dropbox/Notes/todo.org"))
                                (org-agenda-overriding-header "Work")
                                (org-agenda-skip-function #'my-org-agenda-skip-all-siblings-but-first)))
            (tags-todo "@omscs" ((org-agenda-files '("~/Dropbox/Notes/todo.org"))
                                 (org-agenda-overriding-header "OMSCS")
                                 (org-agenda-skip-function #'my-org-agenda-skip-all-siblings-but-first)))
            ))

          ("h" "Home agenda"
           (
            (agenda "" ((org-agenda-span 7)
                        (org-agenda-start-day "-1d")
                        (org-agenda-files '("~/Dropbox/Notes/tickler.org"
                                            "~/Dropbox/Notes/todo.org"))
                        (org-agenda-skip-function #'my-org-agenda-skip-scheduled-if-in-todo)))
            (tags-todo "@home/!TODO" ((org-agenda-files '("~/Dropbox/Notes/todo.org"))
                                      (org-agenda-overriding-header "Todo")
                                      (org-agenda-skip-function #'my-org-agenda-skip-all-siblings-but-first)))
            (tags-todo "@home/!WAITING" ((org-agenda-files '("~/Dropbox/Notes/todo.org"))
                                         (org-agenda-overriding-header "Waiting")
                                         (org-agenda-skip-function #'my-org-agenda-skip-all-siblings-but-first)))
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
                        (org-agenda-files '("~/Dropbox/Notes/tickler.org"
                                            "~/Dropbox/Notes/todo.org"))
                        (org-agenda-skip-function #'my-org-agenda-skip-scheduled-if-in-todo)))
            (tags-todo "@work/!TODO" ((org-agenda-files '("~/Dropbox/Notes/todo.org"))
                                      (org-agenda-overriding-header "Todo")
                                      (org-agenda-skip-function #'my-org-agenda-skip-all-siblings-but-first)))
            (tags-todo "@work/!WAITING" ((org-agenda-files '("~/Dropbox/Notes/todo.org"))
                                         (org-agenda-overriding-header "Waiting")
                                         (org-agenda-skip-function #'my-org-agenda-skip-all-siblings-but-first)))
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
                        (org-agenda-files '("~/Dropbox/Notes/tickler.org"
                                            "~/Dropbox/Notes/todo.org"))
                        (org-agenda-skip-function #'my-org-agenda-skip-scheduled-if-in-todo)))
            (tags-todo "@omscs/!TODO" ((org-agenda-files '("~/Dropbox/Notes/todo.org"))
                                       (org-agenda-overriding-header "Todo")
                                       (org-agenda-skip-function #'my-org-agenda-skip-all-siblings-but-first)))
            (tags-todo "@omscs/!WAITING" ((org-agenda-files '("~/Dropbox/Notes/todo.org"))
                                          (org-agenda-overriding-header "Todo")
                                          (org-agenda-skip-function #'my-org-agenda-skip-all-siblings-but-first)))
            )
           (
            ;; only way to filter agenda by tag
            (org-agenda-tag-filter-preset '("+@omscs"))
            )
           )

          ))
  )

(defun my-org-agenda-skip-all-siblings-but-first ()
  "Skip all but the first non-done entry that is inside a project (a subheading)."
  (when (> (car (org-heading-components)) 2)
    (let (should-skip-entry)
      (save-excursion
        (while (and (not should-skip-entry) (org-goto-sibling t))
          (when (string= "TODO" (org-get-todo-state))
            (setq should-skip-entry t))))
      (when should-skip-entry
        (or (outline-next-heading) (goto-char (point-max)))))))

(defun my-org-agenda-skip-scheduled-if-in-todo ()
  "Skip scheduled items that have been moved to todo.org."
  (when (and (string= "todo.org" (file-name-nondirectory (buffer-file-name)))
             (org-entry-get nil "SCHEDULED"))
    (or (outline-next-heading) (goto-char (point-max)))))

;; org-dragndrop
(after! org-download
  (setq org-download-screenshot-method
        (cond (IS-MAC "screencapture -i %s")
              (IS-LINUX "~/.config/sway/capture.sh %s"))))

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
  (add-to-list 'flycheck-checkers 'jsonnetvendor))

;; Markdown
(add-hook! markdown-mode
  (visual-line-mode 1)
  (flycheck-mode 0)
  (setq fill-column 100))

(after! treemacs
  (treemacs-follow-mode 1)
  (setq treemacs-width 40))

;; Always create a new workspace.
(setq +workspaces-on-switch-project-behavior t)

;; magit tweaks
(setq magit-prefer-remote-upstream t)
;; when doing b-l on a remote branch, it will set the upstream to origin/master
(setq magit-branch-adjust-remote-upstream-alist '(("origin/master" "master")))
;; when doing b-c default origin/master as the branching point when possible
(setq magit-branch-prefer-remote-upstream '("master"))
;; limit status buffer to 15 open topics and 5 closed topics
(setq forge-topic-list-limit '(15 . 5))

;; lsp-mode tweaks
(setq lsp-auto-guess-root nil)

;; scala-mode tweaks
(after! scala-mode (setq scala-indent:align-parameters nil))
