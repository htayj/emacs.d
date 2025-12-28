;;; init.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2025 Taylor Hardy
;;
;; Author: Taylor Hardy
;; Maintainer: Taylor Hardy 
;; Created: April 15, 2025
;; Modified: April 15, 2025
;; Version: 0.0.1
;; Homepage: https://github.com/tay/emacs.d
;; Package-Requires: ((emacs "30.1"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:


;; =============================================================================
;; bootstrapping package stuff
;; =============================================================================

;; default emacs package management
;; DONE maybe do this in early-init.el?
;; (require 'package)
;; (setq package-enable-at-startup nil)
;; TODO maybe move the rest out of early-init?
;; (setq package-archives '(("ELPA"  . "http://tromey.com/elpa/")
;;                          ("gnu"   . "http://elpa.gnu.org/packages/")
;;                          ("melpa" . "https://melpa.org/packages/")
;;                          ("org"   . "https://orgmode.org/elpa/")))
;; (package-initialize)

;; bootstrap use-package
(require 'use-package)

;;; Bootstrapping straight
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(use-package straight
  :custom (straight-use-package-by-default t))

;; have to install org early for some reason
(straight-use-package 'org)
;; =============================================================================
;; Custom use-package bindings
;; =============================================================================

;; =============================================================================
;; basic UX things
;; =============================================================================
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(global-subword-mode t)
(setq indent-tabs-mode nil)


(global-set-key (kbd "C-x k") 'kill-current-buffer)

(set-fontset-font t nil (font-spec :size 20 :name "vt220" ))
(set-fontset-font t nil (font-spec :size 16 :name "unifont"))


;; auto close parens
(setq electric-pair-pairs '(
                            (?\{ . ?\})
                            (?\( . ?\))
                            (?\[ . ?\])
                            (?\" . ?\")))
(electric-pair-mode t)

;; which key for discoverability
(which-key-mode 1)
;; =============================================================================
;; irc
;; =============================================================================
(use-package erc-hl-nicks
  :straight t
  :config
  (erc-update-modules))
(setq erc-nick "htayj")
(setq erc-prompt (lambda () (concat "[" (buffer-name) "]")))
(setq erc-hide-list '("JOIN" "PART" "QUIT"))
(setq erc-interpret-mirc-color t)
(setq erc-modules
			'(completion log notifications hl-nicks netsplit fill button match readonly networks ring autojoin noncommands irccontrols move-to-prompt stamp menu list))
'(erc-prompt-for-password nil)
(add-to-list 'erc-mode-hook (lambda ()
                              (set (make-local-variable 'scroll-conservatively) 100)))
(require 'erc-goodies)


(setq erc-track-exclude-types '("JOIN" "KICK" "NICK" "PART" "333" "353"))
(setq erc-server-history-list '("irc.libera.chat"
                                "irc.deft.com"
                                "localhost"))
(setq erc-autojoin-channels-alist '( ("libera.chat" "#pine64" "#fsf" "#searx" "#guix" "#emacs" "#hurd" "#guix" "#lisp" "##trans" "##transgeeks") ))

(setq erc-autojoin-timing 'ident)

(setq erc-track-exclude
			'("##latinitas" "##latin" "#EsperantoAmeriko#1" "#kulupupitokipona#1"))
(setq erc-interpret-mirc-color t)

;; =============================================================================
;; emacs 29 included treesit and eglot
;; =============================================================================

;; treesit config
(require 'treesit)
(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

;;eglot config
(require 'eglot)
(add-to-list 'eglot-server-programs
             '((tsx-mode) "npx typescript-language-server" "--stdio"))
(add-to-list 'eglot-server-programs
             '((tsx-ts-mode) "npx typescript-language-server" "--stdio"))
(add-to-list 'eglot-server-programs
             '((js-json-mode) "vscode-json-languageserver" "--stdio"))
(add-to-list 'eglot-server-programs
             '((typst-ts-mode) "tinymist"))

(add-to-list 'eglot-server-programs '(nix-mode . ("nil")))
(add-hook 'typescript-ts-mode-hook 'eglot-ensure)
(add-hook 'tsx-ts-mode-hook 'eglot-ensure)
(add-hook 'nix-mode-hook 'eglot-ensure)

(use-package markdown-mode) ;; required for eglot eldoc

;; show eldoc in a popup to prevent resizing minibuffer
;; (use-package eldoc-box
;;   :straight t
;;   :config
;;   (add-hook 'eglot-managed-mode-hook #'eldoc-box-hover-at-point-mode t)
;;   (add-hook 'lsp-managed-mode-hook #'eldoc-box-hover-at-point-mode t)
;;   (add-hook 'emacs-lisp-mode-hook #'eldoc-box-hover-at-point-mode t))
;; =============================================================================
;; handle delimiters
;; =============================================================================
(show-paren-mode 1)
(setq show-paren-style 'expression)


(use-package rainbow-delimiters
  :straight t
  :init
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))
(use-package colorful-mode
	:custom
  (colorful-use-prefix t)
  (colorful-only-strings 'only-prog)
  (css-fontify-colors nil)
	:config
  (global-colorful-mode t)
  (add-to-list 'global-colorful-modes 'yaml-mode) )

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

;;(add-to-list 'exwm-manage-configurations '((equal exwm-class-name "Slack") managed t))
;; =============================================================================
;; ibuffer
;; =============================================================================
(use-package ibuffer
  :bind
  ("C-x b" . ibuffer))

;; =============================================================================
;; completion framework
;; =============================================================================

;; minibuffer completion engine
(use-package vertico
  :bind
  ("C-x C-b" . switch-to-buffer)
  :init
  (vertico-mode))

;; fuzzy find
(use-package orderless
  :custom
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch))
  ;; (orderless-component-separator #'orderless-escapable-split-on-space)
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

;; show more info in minibuffer 
(use-package marginalia
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
							("M-A" . marginalia-cycle))

  :init
  (marginalia-mode))

;; TODO consult
(use-package consult
  ;; Replace bindings. Lazily loaded by `use-package'.
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x C-b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x t b" . consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)                  ;; Alternative: consult-fd
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Tweak the register preview for `consult-register-load',
  ;; `consult-register-store' and the built-in commands.  This improves the
  ;; register formatting, adds thin separator lines, register sorting and hides
  ;; the window mode line.
  (advice-add #'register-preview :override #'consult-register-window)
  (setq register-preview-delay 0.5)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep consult-man
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; "C-+"

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (keymap-set consult-narrow-map (concat consult-narrow-key " ?") #'consult-narrow-help)
  )
;; TODO embark

(use-package web-mode)
;; autocomplete in buffer
(use-package corfu
  ;; Optional customizations
  :custom

  (corfu-auto t)               ;; Enable auto completion
  (corfu-preselect 'directory) ;; Select the first candidate, except for directories
  ;; (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  ;; (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
  ;; (corfu-quit-no-match nil)      ;; Never quit, even if there is no match
  ;; (corfu-preview-current nil)    ;; Disable current candidate preview
  ;; (corfu-preselect 'prompt)      ;; Preselect the prompt
  ;; (corfu-on-exact-match nil)     ;; Configure handling of exact matches

  ;; Enable Corfu only for certain modes. See also `global-corfu-modes'.
  ;; :hook ((prog-mode . corfu-mode)
  ;;        (shell-mode . corfu-mode)
  ;;        (eshell-mode . corfu-mode))

  :init

  ;; Recommended: Enable Corfu globally.  Recommended since many modes provide
  ;; Capfs and Dabbrev can be used globally (M-/).  See also the customization
  ;; variable `global-corfu-modes' to exclude certain modes.
  (global-corfu-mode)

  ;; Enable optional extension modes:
  ;; (corfu-history-mode)
  (corfu-popupinfo-mode))


(use-package sudo-edit
  :straight t
  :bind
  ("s-e" . sudo-edit))
;; =============================================================================
;; magit
;; =============================================================================
(use-package magit
  :straight t
  :config
  (setq magit-push-always-verify nil)
  (setq git-commit-summary-max-length 180))

;; =============================================================================
;; programming languages
;; =============================================================================
;; purescript
(use-package purescript-mode)
;; (use-package psc-ide
;;   :hook
;;   ((psc-ide-mode corfu-mode flycheck-mode turn-on-purescript-indentation ) . purescript-mode))


(use-package nix-mode
  :mode "\\.nix\\'")

(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (add-hook 'purescript-mode-hook #'lsp))
;; (use-package psc-ide
;; :config
;; (add-hook 'purescript-mode-hook
;;     (lambda ()
;;       (psc-ide-mode)
;;       (company-mode)
;;       (flycheck-mode)
;;       (turn-on-purescript-indentation))
;; 		)
;; )
(use-package typst-ts-mode
  :straight '(:type git :host codeberg :repo "meow_king/typst-ts-mode")
	:custom
  (typst-ts-watch-options nil)
	(typst-ts-mode-enable-raw-blocks-highlight t)
	:config
	(keymap-set typst-ts-mode-map "C-c C-c" #'typst-ts-tmenu))

(use-package nushell-ts-mode
  :straight '(:type git :host github :repo "herbertjones/nushell-ts-mode"))

(with-eval-after-load 'eglot
	(with-eval-after-load 'typst-ts-mode
		(add-to-list 'eglot-server-programs
								 `((typst-ts-mode) .
									 ,(eglot-alternatives `(,typst-ts-lsp-download-path
																					"tinymist"
																					"typst-lsp"))))))

;; disable bell sound 
(setq visible-bell 1)
;; =============================================================================
;; prot's themes
;; =============================================================================
;; (use-package standard-themes)
;; (use-package ef-themes)
;; (use-package base16-theme
;;   :ensure t
;;   :config
;;   (load-theme 'base16- t))

;;(load "default" 'noerror 'nomessage)
;; use modus as fallback
(use-package modus-themes
  :config
  (load-theme 'modus-vivendi t))
(set-face-attribute 'default nil :height 160)
;; =============================================================================
;; other themes
;; =============================================================================

;; (use-package xresources-theme
;;   :straight '(:type git :host github :repo "martenlienen/xresources-theme")
;; 	:config
;;   (load-theme 'xresources t)	)
;; (use-package cyberpunk-theme
;;   :config
;;   (load-theme 'cyberpunk t))
;; use moe as the main theme
;; (setq moe-dark-bg "#000")
;; (use-package moe-theme
;;   :config
;;   (load-theme 'moe-dark t)

;; add color to compilation
(defun my/ansi-colorize-buffer ()
  (let ((buffer-read-only nil))
    (ansi-color-apply-on-region (point-min) (point-max))))
(add-hook 'compilation-filter-hook 'my/ansi-colorize-buffer)

(use-package apheleia
  :config
  (setf (alist-get 'tsx-ts-mode apheleia-mode-alist)
				'(dprint))
  (setf (alist-get 'typescript-ts-mode apheleia-mode-alist)
				'(dprint))
  (setf (alist-get 'json-ts-mode apheleia-mode-alist)
				'(dprint))
  (setf (alist-get 'js-ts-mode apheleia-mode-alist)
				'(dprint))
  (apheleia-global-mode 1))
;;

(setq display-time-24hr-format nil)
(setq display-time-format "%H:%M %m/%d")
(display-time-mode 1)

;; =============================================================================
;; window manager features
;; =============================================================================
;;(load-file "~/.emacs.d/wm.el")
;; =============================================================================
;; terminal emulator
;; =============================================================================
;;(straight-use-package
;; '(eat :type git
;;       :host codeberg
;;       :repo "akib/emacs-eat"
;;       :files ("*.el" ("term" "term/*.el") "*.texi"
;;               "*.ti" ("terminfo/e" "terminfo/e/*")
;;               ("terminfo/65" "terminfo/65/*")
;;               ("integration" "integration/*")
;;               (:exclude ".dir-locals.el" "*-tests.el"))))
;;
(setq password-cache-expiry nil)
;; (use-package ement
;;   :straight (ement :type git :host github :repo "alphapapa/ement.el")
;;   :config (ement-connect :user-id "@tay:vexillomancy.org"
;; 			 :uri-prefix "http://localhost:8008"
;; 			 :password
;; 			 (auth-source-pick-first-password
;; 			  :host "matrix.vexillomancy.org"
;; 			  :user "tay")))
;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(corfu-quit-no-match t)
 '(custom-safe-themes
	 '("e5494adf200eeff1505839672150dde6053e086869189c381b1ce9b792dda3a8"
		 "3b2ae1d19f5843cdc5833266b76e6367744932d96c5ddd713ede9797a2bd93fe"
		 "8899e88d19a37d39c7187f4bcb5bb596fba990728ef963420b93e2aea5d1666a"
		 "a1c18db2838b593fba371cb2623abd8f7644a7811ac53c6530eebdf8b9a25a8d"
		 "ae20535e46a88faea5d65775ca5510c7385cbf334dfa7dde93c0cd22ed663ba0"
		 "cee5c56dc8b95b345bfe1c88d82d48f89e0f23008b0c2154ef452b2ce348da37"
		 "1ad12cda71588cc82e74f1cabeed99705c6a60d23ee1bb355c293ba9c000d4ac"
		 "0b41a4a9f81967daacd737f83d3eac7e3112d642e3f786cf7613de4da97a830a"
		 "aa545934ce1b6fd16b4db2cf6c2ccf126249a66712786dd70f880806a187ac0b"
		 default))
 '(ede-project-directories
	 '("/home/tay/purescript/purescript-book/exercises/chapter5"))
 '(eldoc-echo-area-display-truncation-message nil)
 '(eldoc-echo-area-use-multiline-p t)
 '(erc-accidental-paste-threshold-seconds 5)
 '(erc-ask-about-multiline-input t)
 '(erc-fill-column 110)
 '(erc-insert-timestamp-function 'erc-insert-timestamp-left)
 '(erc-modules
	 '(autojoin button completion fill irccontrols list log match menu
							move-to-prompt netsplit networks nicks noncommands
							notifications readonly ring scrolltobottom stamp
							hl-nicks))
 '(erc-pals '("Ammonium8755" "FlowPlay"))
 '(erc-timestamp-intangible t)
 '(erc-timestamp-only-if-changed-flag nil)
 '(erc-timestamp-use-align-to nil)
 '(safe-local-variable-values
	 '((flycheck-gcc-language-standard . "c++11")
		 (flycheck-clang-language-standard . "c++11")
		 (flymake-eslint-project-root . "/home/tay/terminus/gui")
		 (projectile-project-compilation-cmd
			. "npx lerna run compile --stream")
		 (projectile-project-test-cmd . "npx lerna run test --stream")
		 (projectile-project-package-cmd . "../script/build")
		 (projectile-project-configure-cmd
			. "npx lerna run clean && npm run bootstrap && npx lerna run compile --stream")
		 (projectile-project-run-cmd . "npm run dev")
		 (combobulate-highlight-queries-alist
			(:language tsx :query
								 "(program\12 (import_statement\12  (import_clause\12   (named_imports\12    (import_specifier (identifier) @hl.default)))))"))))
 '(straight-recipes-gnu-elpa-url "https://github.com/emacsmirror/gnu_elpa")
 '(tab-width 2))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


