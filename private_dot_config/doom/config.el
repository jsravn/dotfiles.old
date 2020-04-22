;; [[file:~/.config/doom/config.org::*File variables][File variables:1]]
;;; ~/.config/doom/config.el -*- lexical-binding: t; -*-
;; File variables:1 ends here

;; [[file:~/.config/doom/config.org::*Personal information][Personal information:1]]
(setq user-full-name "James Ravn"
      user-mail-address "james@r-vn.org"
      calendar-latitude 51.508166
      calendar-longitude -0.075971
      calendar-location-name "London, UK")
;; Personal information:1 ends here

;; [[file:~/.config/doom/config.org::*Theme][Theme:1]]
(setq doom-theme 'doom-one              ;
      doom-font (font-spec :family "PragmataPro Liga" :size 16 :adstyle "Regular")
      +pretty-code-pragmata-pro-font-name "PragmataPro Liga")
;; Theme:1 ends here

;; [[file:~/.config/doom/config.org::*Theme][Theme:2]]
(setq doom-themes-treemacs-enable-variable-pitch nil)
;; Theme:2 ends here

;; [[file:~/.config/doom/config.org::*Maximize][Maximize:1]]
(add-to-list 'default-frame-alist '(fullscreen . maximized))
;; Maximize:1 ends here

;; [[file:~/.config/doom/config.org::*Deletion][Deletion:1]]
(setq delete-by-moving-to-trash t)
;; Deletion:1 ends here

;; [[file:~/.config/doom/config.org::*Auto-save][Auto-save:1]]
(setq auto-save-default t)
;; Auto-save:1 ends here

;; [[file:~/.config/doom/config.org::*Auto-save][Auto-save:2]]
(add-hook! '(doom-switch-buffer-hook
             doom-switch-window-hook
             focus-out-hook)
  (if (buffer-file-name) (save-some-buffers t))) ; avoid saving when switching to a non-file buffer
;; Auto-save:2 ends here

;; [[file:~/.config/doom/config.org::*Line wrapping][Line wrapping:1]]
(setq-default fill-column 120)
;; Line wrapping:1 ends here

;; [[file:~/.config/doom/config.org::*Line wrapping][Line wrapping:2]]
(remove-hook 'text-mode-hook #'auto-fill-mode)
(add-hook 'text-mode-hook #'+word-wrap-mode)
;; Line wrapping:2 ends here

;; [[file:~/.config/doom/config.org::*Window splitting][Window splitting:1]]
(setq evil-vsplit-window-right t
      evil-split-window-below t)
;; Window splitting:1 ends here

;; [[file:~/.config/doom/config.org::*Window splitting][Window splitting:2]]
(defadvice! prompt-for-buffer (&rest _)
  :after '(evil-window-split evil-window-vsplit)
  (persp-switch-to-buffer))
;; Window splitting:2 ends here

;; [[file:~/.config/doom/config.org::*Window splitting][Window splitting:3]]
(setq split-width-threshold 240)
;; Window splitting:3 ends here

;; [[file:~/.config/doom/config.org::*Clipboard][Clipboard:1]]
(setq select-enable-clipboard t)
;; Clipboard:1 ends here

;; [[file:~/.config/doom/config.org::*atomic-chrome][atomic-chrome:1]]
(use-package! atomic-chrome
  :after-call focus-out-hook
  :config
  (setq atomic-chrome-default-major-mode 'markdown-mode
        atomic-chrome-buffer-open-style 'frame)
  (atomic-chrome-start-server))
;; atomic-chrome:1 ends here

;; [[file:~/.config/doom/config.org::*Projects][Projects:1]]
(setq projectile-project-search-path '("~/devel/" "~/sky/" "~/Dropbox" "~/gatech"))
;; Projects:1 ends here

;; [[file:~/.config/doom/config.org::*Projects][Projects:2]]
(defun +private/projectile-invalidate-cache (&rest _args)
  (projectile-invalidate-cache nil))
(advice-add 'magit-checkout
            :after #'+private/projectile-invalidate-cache)
(advice-add 'magit-branch-and-checkout
            :after #'+private/projectile-invalidate-cache)
;; Projects:2 ends here

;; [[file:~/.config/doom/config.org::*Workspaces][Workspaces:1]]
(setq +workspaces-on-switch-project-behavior t)
;; Workspaces:1 ends here

;; [[file:~/.config/doom/config.org::*Zen][Zen:1]]
(after! writeroom-mode
  (setq +zen-text-scale 0
        +zen-mixed-pitch-modes nil
        writeroom-mode-line t
        writeroom-width 160))
;; Zen:1 ends here

;; [[file:~/.config/doom/config.org::*Treemacs][Treemacs:1]]
(after! treemacs
  (treemacs-follow-mode 1)
  (setq treemacs-width 40))
;; Treemacs:1 ends here

;; [[file:~/.config/doom/config.org::*Golang][Golang:1]]
(setq lsp-gopls-hover-kind "FullDocumentation")
;; Golang:1 ends here

;; [[file:~/.config/doom/config.org::*Org Mode][Org Mode:1]]
(setq org-directory "~/Dropbox/Notes/")
;; Org Mode:1 ends here

;; [[file:~/.config/doom/config.org::*Visual configuration][Visual configuration:1]]
(setq
 org-ellipsis " ▼ "
 org-superstar-headline-bullets-list '("☰" "☱" "☲" "☳" "☴" "☵" "☶" "☷" "☷" "☷" "☷"))
;; Visual configuration:1 ends here

;; [[file:~/.config/doom/config.org::*Archiving][Archiving:1]]
(setq org-archive-location (concat org-directory ".archive/%s::"))
(after! org (setq org-archive-subtree-add-inherited-tags t))
;; Archiving:1 ends here

;; [[file:~/.config/doom/config.org::*Download][Download:1]]
(after! org-download
  (setq org-download-screenshot-method
        (cond (IS-MAC "screencapture -i %s")
              (IS-LINUX "~/.config/sway/capture.sh %s"))))
;; Download:1 ends here

;; [[file:~/.config/doom/config.org::*Task settings][Task settings:1]]
(after! org
  (setq
   org-todo-keywords '((sequence "TODO(t)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)"))
   org-log-done 'time))
;; Task settings:1 ends here

;; [[file:~/.config/doom/config.org::*Contexts][Contexts:1]]
(after! org
  (setq
   org-tag-alist '(("@work" . ?w) ("@home" . ?h) ("@omscs" . ?o))
   org-fast-tag-selection-single-key t))
;; Contexts:1 ends here

;; [[file:~/.config/doom/config.org::*Refile targets][Refile targets:1]]
(after! org
  (setq
   org-refile-targets '(("~/Dropbox/Notes/todo.org" :maxlevel . 2)
                        ("~/Dropbox/Notes/someday.org" :maxlevel . 1)
                        ("~/Dropbox/Notes/tickler.org" :maxlevel . 2)
                        ("~/Dropbox/Notes/notes.org" :maxlevel . 2))))
;; Refile targets:1 ends here

;; [[file:~/.config/doom/config.org::*Habits][Habits:1]]
(after! org
  (add-to-list 'org-modules 'org-habit t))
;; Habits:1 ends here

;; [[file:~/.config/doom/config.org::*Custom Agendas][Custom Agendas:1]]
(after! org
  (setq org-agenda-custom-commands
        (list (jsravn--all-agenda)
              (jsravn--agenda "home")
              (jsravn--agenda "work")
              (jsravn--agenda "omscs"))))
;; Custom Agendas:1 ends here

;; [[file:~/.config/doom/config.org::*Custom Agendas][Custom Agendas:2]]
(after! org (setq org-deadline-warning-days 14))
;; Custom Agendas:2 ends here

;; [[file:~/.config/doom/config.org::*All Agenda Function][All Agenda Function:1]]
(defun jsravn--all-agenda ()
  "Custom all agenda."
  `("A" "All agenda"
    ((todo "" ((org-agenda-files '("~/Dropbox/Notes/inbox.org"))
               (org-agenda-overriding-header "Inbox")))
     (tags "-{.*}" ((org-agenda-files '("~/Dropbox/Notes/todo.org"
                                        "~/Dropbox/Notes/tickler.org"
                                        "~/Dropbox/Notes/someday.org"))
                    (org-agenda-overriding-header "Untagged")))
     (agenda "" ((org-agenda-span 7)
                 (org-agenda-start-day "-1d")
                 (org-agenda-files '("~/Dropbox/Notes/tickler.org"
                                     "~/Dropbox/Notes/todo.org"))
                 (org-agenda-skip-function #'jsravn--skip-scheduled-if-in-todo)))
     ,(jsravn--tags-todo "@home" "Home")
     ,(jsravn--tags-todo "@work" "Work")
     ,(jsravn--tags-todo "@omscs" "OMSCS"))))
;; All Agenda Function:1 ends here

;; [[file:~/.config/doom/config.org::*Context Agenda Function][Context Agenda Function:1]]
(defun jsravn--agenda (scope)
  "Custom scoped agenda."
  (let ((key (substring scope 0 1))
        (title (concat (upcase-initials scope) "agenda"))
        (tag (concat "@" scope)))
    `(,key ,title
           ((agenda "" ((org-agenda-span 7)
                        (org-agenda-start-day "-1d")
                        (org-agenda-files '("~/Dropbox/Notes/tickler.org"
                                            "~/Dropbox/Notes/todo.org"))
                        (org-agenda-skip-function #'jsravn--skip-scheduled-if-in-todo)))
            ,(jsravn--tags-todo (concat tag "/!TODO") "Todo")
            ,(jsravn--tags-todo (concat tag "/!WAITING") "Waiting"))
           ((org-agenda-tag-filter-preset '(,(concat "+" tag)))))))
;; Context Agenda Function:1 ends here

;; [[file:~/.config/doom/config.org::*Agenda Support Functions][Agenda Support Functions:1]]
(defun jsravn--tags-todo (tags header)
  "Customized tags-todo view which only shows the first TODO in a subheading."
  `(tags-todo ,tags ((org-agenda-files '("~/Dropbox/Notes/todo.org"))
                     (org-agenda-overriding-header ,header)
                     (org-agenda-skip-function #'jsravn--skip-all-siblings-but-first))))

(defun jsravn--skip-all-siblings-but-first ()
  "Skip all but the first non-done entry that is inside a subheading."
  (when (> (car (org-heading-components)) 2)
    (let (should-skip-entry)
      (save-excursion
        (while (and (not should-skip-entry) (org-goto-sibling t))
          (when (string= "TODO" (org-get-todo-state))
            (setq should-skip-entry t))))
      (when should-skip-entry
        (or (outline-next-heading) (goto-char (point-max)))))))
;; Agenda Support Functions:1 ends here

;; [[file:~/.config/doom/config.org::*Agenda Support Functions][Agenda Support Functions:2]]
(defun jsravn--skip-scheduled-if-in-todo ()
  "Skip scheduled items that have been moved to todo.org."
  (when (and (string= "todo.org" (file-name-nondirectory (buffer-file-name)))
             (org-entry-get nil "SCHEDULED"))
    (or (outline-next-heading) (goto-char (point-max)))))
;; Agenda Support Functions:2 ends here

;; [[file:~/.config/doom/config.org::*Agenda Searches][Agenda Searches:1]]
(after! org (setq org-agenda-text-search-extra-files '(agenda-archives)))
;; Agenda Searches:1 ends here

;; [[file:~/.config/doom/config.org::*Agenda Searches][Agenda Searches:2]]
(after! org (setq org-agenda-search-view-always-boolean t))
;; Agenda Searches:2 ends here

;; [[file:~/.config/doom/config.org::*org-roam][org-roam:1]]
(setq org-roam-directory (concat org-directory "roam/"))
;; org-roam:1 ends here

;; [[file:~/.config/doom/config.org::*org-roam][org-roam:2]]
(setq deft-directory org-roam-directory)
;; org-roam:2 ends here

;; [[file:~/.config/doom/config.org::*org-roam][org-roam:3]]
(setq org-roam-buffer-no-delete-other-windows t)
;; org-roam:3 ends here

;; [[file:~/.config/doom/config.org::*org-roam][org-roam:4]]
(defun jsravn--open-org-roam ()
  "Called by `find-file-hook' when `org-roam-mode' is on."
  (when (org-roam--org-roam-file-p)
    (unless (eq 'visible (org-roam--current-visibility)) (org-roam))))

(after! org-roam
  (add-hook 'doom-switch-buffer-hook #'jsravn--open-org-roam))
;; org-roam:4 ends here

;; [[file:~/.config/doom/config.org::*org-journal][org-journal:1]]
(after! org-journal
  (setq org-journal-date-prefix "#+TITLE: "
        org-journal-file-format "%Y-%m-%d.org"
        org-journal-dir org-roam-directory
        org-journal-date-format "%A, %d %B %Y"))
;; org-journal:1 ends here

;; [[file:~/.config/doom/config.org::*Language Server Protocol (LSP)][Language Server Protocol (LSP):1]]
(setq lsp-auto-guess-root nil)
;; Language Server Protocol (LSP):1 ends here

;; [[file:~/.config/doom/config.org::*Language Server Protocol (LSP)][Language Server Protocol (LSP):2]]
(setq lsp-enable-symbol-highlighting nil)
;; Language Server Protocol (LSP):2 ends here

;; [[file:~/.config/doom/config.org::*Language Server Protocol (LSP)][Language Server Protocol (LSP):3]]
(setq lsp-enable-links nil)
;; Language Server Protocol (LSP):3 ends here

;; [[file:~/.config/doom/config.org::*Language Server Protocol (LSP)][Language Server Protocol (LSP):4]]
(map! :leader
      (:prefix "c"
        (:after lsp-mode
          :desc "LSP" "l" lsp-command-map)))
;; Language Server Protocol (LSP):4 ends here

;; [[file:~/.config/doom/config.org::*Magit][Magit:1]]
(setq magit-prefer-remote-upstream t)
;; Magit:1 ends here

;; [[file:~/.config/doom/config.org::*Magit][Magit:2]]
(setq forge-topic-list-limit '(15 . 5))
;; Magit:2 ends here
