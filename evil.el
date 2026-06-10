;; =============================================================================
;; evil mode
;; =============================================================================
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :custom
  (evil-undo-system 'undo-tree)
  (evil-search-module 'isearch)
  :config
  (evil-mode 1)
  (setq evil-search-module 'isearch)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init)
  (setq evil-want-keybinding t)
  (evil-set-initial-state 'eaf-mode 'emacs)
  (evil-set-initial-state 'exwm-mode 'emacs))

(use-package evil-surround
  :config
  (global-evil-surround-mode 1))

(use-package undo-tree
  :config
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
  (global-undo-tree-mode))

;; =============================================================================
;; symex and rigpa
;; =============================================================================

;;; indra/rigpa
;; (use-package rigpa

;;   :straight
;;   (rigpa
;;    :type git
;;    :host github
;;    :repo "countvajhula/rigpa")

;;   :config
;;   (rigpa-mode 1)

;;   ;; navigating meta modes
;;   (global-unset-key (kbd "H-m"))
;;   (global-set-key (kbd "H-m H-m") 'rigpa-flashback-to-last-tower)
;;   (global-set-key (kbd "H-g")
;;                   (lambda ()
;;                     (interactive)
;;                     (when (eq rigpa--complex rigpa-meta-complex)
;;                       (rigpa-exit-mode-mode))
;;                     (rigpa-enter-tower-mode)))
;;   (global-set-key (kbd "H-<escape>") 'rigpa-enter-mode-mode)
;;   (global-set-key (kbd "H-C-g") 'rigpa-enter-mode-mode) ;; hyper bell goes up
;;   (global-set-key (kbd "H-j") ;; hyper line feed return goes down
;;                   (lambda ()
;;                     (interactive)
;;                     (when (eq rigpa--complex rigpa-meta-complex)
;;                       (rigpa-enter-selected-level)
;;                       (let ((ground (rigpa--get-ground-buffer)))
;;                         (rigpa-exit-mode-mode)
;;                         (switch-to-buffer ground)))))
;;   (global-set-key (kbd "s-<return>")
;;                   (lambda ()
;;                     (interactive)
;;                     (when (eq rigpa--complex rigpa-meta-complex)
;;                       (rigpa-enter-selected-level)
;;                       (let ((ground (rigpa--get-ground-buffer)))
;;                         (rigpa-exit-mode-mode)
;;                         (switch-to-buffer ground)))))
;;   (global-set-key (kbd "H-<return>") ;; hyper control m
;;                   (lambda ()
;;                     (interactive)
;;                     (when (eq rigpa--complex rigpa-meta-tower-complex)
;;                       (rigpa-exit-tower-mode)
;;                       (rigpa-enter-mode-mode))))

;;   ;; indexed entry to various modes
;;   (global-set-key (kbd "H-n") 'evil-normal-state)
;;   (global-set-key (kbd "H-y")        ; symex mode
;;                   (lambda ()
;;                     (interactive)
;;                     (rigpa-enter-mode "symex")))
;;   (global-set-key (kbd "H-w")        ; window mode
;;                   (lambda ()
;;                     (interactive)
;;                     (rigpa-enter-mode "window")))
;;   (global-set-key (kbd "H-v")        ; view mode
;;                   (lambda ()
;;                     (interactive)
;;                     (rigpa-enter-mode "view")))
;;   (global-set-key (kbd "H-x")        ; char mode
;;                   (lambda ()
;;                     (interactive)
;;                     (rigpa-enter-mode "char")))
;;   (global-set-key (kbd "H-a")        ; activity mode
;;                   (lambda ()
;;                     (interactive)
;;                     (rigpa-enter-mode "activity")))
;;   (global-set-key (kbd "H-z")        ; text mode
;;                   (lambda ()
;;                     (interactive)
;;                     (rigpa-enter-mode "text")))
;;   (global-set-key (kbd "H-l")        ; history mode
;;                   (lambda ()
;;                     (interactive)
;;                     (rigpa-enter-mode "history")))
;;   (global-set-key (kbd "H-i")        ; system mode
;;                   (lambda ()
;;                     (interactive)
;;                     (rigpa-enter-mode "system")))
;;   (global-set-key (kbd "H-b")        ; buffer mode
;;                   (lambda ()
;;                     (interactive)
;;                     (rigpa-enter-mode "buffer")))
;;   (global-set-key (kbd "H-f")        ; file mode
;;                   (lambda ()
;;                     (interactive)
;;                     (rigpa-enter-mode "file")))
;;   (global-set-key (kbd "H-t")        ; tab mode
;;                   (lambda ()
;;                     (interactive)
;;                     (rigpa-enter-mode "tab")))
;;   (global-set-key (kbd "H-l")        ; line mode
;;                   (lambda ()
;;                     (interactive)
;;                     (rigpa-enter-mode "line")))
;;   (global-set-key (kbd "H-e")        ; application mode
;;                   (lambda ()
;;                     (interactive)
;;                     (rigpa-enter-mode "application")))
;;   (global-set-key (kbd "H-r")        ; word mode
;;                   (lambda ()
;;                     (interactive)
;;                     (rigpa-enter-mode "word"))))
;;; symex
;; (use-package symex-core
;;   :straight
;;   (symex-core
;;    :host github
;;    :repo "drym-org/symex.el"
;;    :files ("symex-core/symex*.el")))
;; (use-package symex
;;   :after (symex-core)
;;   :straight
;;   (symex
;;    :host github
;;    :repo "drym-org/symex.el"
;;    :files ("symex/symex*.el" "symex/doc/*.texi" "symex/doc/figures"))
;;   :config
;;   (symex-mode 1)
;;   (global-set-key (kbd "C-M-;") #'symex-mode-interface)
;;   (global-set-key (kbd "H-n") #'symex-escape-higher))  ; or whatever keybinding you like
;; (use-package symex-ide
;;   :after (symex)
;;   :straight
;;   (symex-ide
;;    :host github
;;    :repo "drym-org/symex.el"
;;    :files ("symex-ide/symex*.el"))
;;   :config
;;   (symex-ide-mode 1))
;; (use-package symex-evil
;;   :after (symex evil)
;;   :straight
;;   (symex-evil
;;    :host github
;;    :repo "drym-org/symex.el"
;;    :files ("symex-evil/symex*.el"))
;;   :config
;;   (symex-evil-mode 1))
;; (use-package symex-rigpa
;;   :after (symex rigpa symex-evil)
;;   :straight
;;   (symex-rigpa
;;    :host github
;;    :repo "drym-org/symex.el"
;;    :files ("symex-rigpa/symex*.el"))
;;   :config
;;   (symex-rigpa-mode 1))
