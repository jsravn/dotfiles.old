;;; ~/.config/doom/+org.el -*- lexical-binding: t; -*-

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

(defun jsravn--tags-todo (tags header)
  "Customized tags-todo view."
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

(defun jsravn--skip-scheduled-if-in-todo ()
  "Skip scheduled items that have been moved to todo.org."
  (when (and (string= "todo.org" (file-name-nondirectory (buffer-file-name)))
             (org-entry-get nil "SCHEDULED"))
    (or (outline-next-heading) (goto-char (point-max)))))

(defun jsravn--open-org-roam ()
  "Called by `find-file-hook' when `org-roam-mode' is on."
  (when (org-roam--org-roam-file-p)
    (unless (eq 'visible (org-roam--current-visibility)) (org-roam))))
