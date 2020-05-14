;; [[file:~/.config/doom/config.org::*File variables][File variables:2]]
;;; ~/.config/doom/init.el -*- lexical-binding: t; -*-
;; File variables:2 ends here

;; [[file:~/.config/doom/config.org::*Enable modules (init.el)][Enable modules (init.el):1]]
(doom!
       :completion
       (company          ; the ultimate code completion backend
        +childframe)
       (ivy              ; a search engine for love and life
        +childframe
        +prescient
        +fuzzy
        +icons)

       :ui
       deft              ; notational velocity for Emacs
       doom              ; what makes DOOM look the way it does
       doom-dashboard    ; a nifty splash screen for Emacs
       hl-todo           ; highlight TODO/FIXME/NOTE tags
       indent-guides     ; highlighted indent columns
       (modeline)        ; snazzy, Atom-inspired modeline, plus API
       nav-flash         ; blink the current line after jumping
       ophints           ; highlight the region an operation acts on
       (popup            ; tame sudden yet inevitable temporary windows
        +all             ; catch all popups that start with an asterix
        +defaults)       ; default popup rules
       (pretty-code      ; replace bits of code with pretty symbols
        +pragmata-pro)
       treemacs          ; a project drawer, like neotree but cooler
       vc-gutter         ; vcs diff in the fringe
       vi-tilde-fringe   ; fringe tildes to mark beyond EOB
       window-select     ; visually switch windows
       workspaces        ; tab emulation, persistence & separate workspaces
       zen               ; distraction-free coding or writing

       :editor
       (evil +everywhere); come to the dark side, we have cookies
       fold              ; (nigh) universal code folding
       format            ; automated prettiness, can add +onsave
       multiple-cursors  ; editing in many places at once
       rotate-text       ; cycle region at point between text candidates
       snippets          ; my elves. They type so I don't have to
       word-wrap         ; soft wrapping with language-aware indent

       :emacs
       dired             ; making dired pretty [functional]
       electric          ; smarter, keyword-based electric-indent
       vc                ; version-control and Emacs, sitting in a tree

       :term
       vterm             ; another terminals in Emacs

       :checkers
       syntax            ; tasing you for every semicolon you forget
       spell             ; tasing you for misspelling mispelling

       :tools
       ansible
       docker
       (debugger +lsp)
       direnv
       editorconfig      ; let someone else argue about tabs vs spaces
       (eval             ; run code, run (also, repls)
        +overlay)
       (lookup           ; helps you navigate your code and documentation
        +docsets         ; ...or in Dash docsets locally
        +dictionary)
       (lsp +peek)
       (magit +forge)    ; a git porcelain for Emacs
       make              ; run make tasks from Emacs
       terraform         ; infrastructure as code

       :lang
       (clojure          ; java with a lisp
        +cider
        +lsp)
       common-lisp       ; if you've seen one lisp, you've seen them all
       data              ; config/data formats
       emacs-lisp        ; drown in parentheses
       (go +lsp)         ; the hipster dialect
       (java +lsp)
       javascript        ; all(hope(abandon(ye(who(enter(here))))))
       markdown          ; writing docs for people to ignore
       (org              ; organize your plain life in plain text
        +dragndrop       ; file drag & drop support
        +journal
        +roam)
       (python           ; beautiful is better than ugly
        +lsp +pyenv)
       (scala +lsp)      ; java, but good
       sh                ; she sells {ba,z,fi}sh shells on the C xor
       (yaml +lsp)

       :email
       mu4e

       :config
       literate
       (default +bindings +smartparens))
;; Enable modules (init.el):1 ends here
