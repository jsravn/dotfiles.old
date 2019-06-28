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
(setq-hook! 'scala-mode-hook comment-line-break-function #'+scala-comment-indent-new-line)
