;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here
;; Change doom theme
(setq doom-theme 'doom-one)
(setq doom-font (font-spec :family "DejaVu Sans Mono"))

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

;; Auto save
(def-package! super-save
  :init
  (setq super-save-auto-save-when-idle t)
  (setq auto-save-default nil))
  :config
  (super-save-mode 1)

;; Markdown
(add-hook! markdown-mode
  (visual-line-mode 1))

;; Magit
(after! magit-todos
  (magit-todos-mode nil))

;; Treemacs
(after! treemacs
  (treemacs-follow-mode 1))

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

;; Scala
(defun +scala-comment-indent-new-line (&rest _)
  "Fix scaladoc comments"
  (let* ((state (syntax-ppss))
         (comment-start-pos (nth 8 state))
         prev-line)
    (save-match-data
      (cond ((and (integerp (nth 4 state))
                  ;; Ensure that we're inside a scaladoc comment
                  (string-match-p "^/\\*\\*?[^\\*]?"
                                  (buffer-substring-no-properties
                                   comment-start-pos
                                   (min (+ comment-start-pos 4)
                                        (point-max))))
                  (progn
                    (setq prev-line (buffer-substring-no-properties
                                     (line-beginning-position 0)
                                     (line-end-position 0)))
                    (or (string-match "^\\s-*\\*" prev-line)
                        (string-match "\\s-*/*" prev-line))))
             (newline)
             (indent-according-to-mode)
             (insert (make-string (max 0 (- (1- (match-end 0))
                                            (match-beginning 0)))
                                  ? )
                     "*")
             (scala-indent:indent-on-scaladoc-asterisk))
            ((sp-point-in-comment)
             (call-interactively #'comment-indent-new-line))))))

(setq scala-indent:use-javadoc-style nil)
(setq scala-indent:align-parameters nil)
(setq-hook! 'scala-mode-hook comment-line-break-function #'+scala-comment-indent-new-line)
