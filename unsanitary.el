;; SLIME configuration for SBCL
(use-package slime
  :ensure t
  :config
  ;; Set SBCL as the default Lisp implementation
  (setq inferior-lisp-program "sbcl")

  ;; Configure SLIME with useful contribs
  (setq slime-contribs '(slime-fancy
                         slime-asdf
                         slime-quicklisp
                         slime-scratch
                         slime-tramp)
        slime-lisp-implementations '((sbcl ("sbcl" "--dynamic-space-size" "2048")))
        slime-complete-symbol-function 'slime-fuzzy-complete-symbol
        slime-startup-animation t
        slime-enable-evaluate-in-emacs t
        slime-net-coding-system 'utf-8-unix
        slime-auto-connect 'ask
        slime-repl-history-file "~/.slime-history.eld"
        slime-repl-history-size 1000)

  ;; Set up SLIME
	;;  (slime-setup '(slime-fancy slime-company))

  ;; Keyboard shortcuts
  (global-set-key (kbd "C-c s") 'slime)

  ;; Auto-start SLIME when opening .lisp files
  (add-hook 'lisp-mode-hook 'slime-mode)
  (add-hook 'slime-mode-hook 'slime-autodoc-mode)

  ;; Custom keybindings for SLIME navigation
  (with-eval-after-load 'slime
    (define-key slime-mode-map (kbd "M-.") 'slime-edit-definition)
    (define-key slime-mode-map (kbd "M-,") 'slime-pop-find-definition)))



;; Optional: If SBCL is in a non-standard location, set the explicit path
;; Uncomment and adjust as needed:
;; (setq inferior-lisp-program "/path/to/sbcl")
;; For example on macOS with Homebrew:
;; (setq inferior-lisp-program "/opt/homebrew/bin/sbcl")
