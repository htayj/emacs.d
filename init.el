;;; This fixed garbage collection, makes emacs start up faster ;;;;;;;
(setq gc-cons-threshold 402653184
      gc-cons-percentage 0.6)

(defvar startup/file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

(defun startup/revert-file-name-handler-alist ()
  (setq file-name-handler-alist startup/file-name-handler-alist))

(defun startup/reset-gc ()
  (setq gc-cons-threshold 16777216
	gc-cons-percentage 0.1))

(add-hook 'emacs-startup-hook 'startup/revert-file-name-handler-alist)
(add-hook 'emacs-startup-hook 'startup/reset-gc)
(message "first section")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; This is all kinds of necessary
(require 'package)
(message "required package")
(setq package-enable-at-startup nil)
(message "set no startup")

;;; remove SC if you are not using sunrise commander and org if you like outdated packages
(setq package-archives '(("ELPA"  . "http://tromey.com/elpa/")
			 ("gnu"   . "http://elpa.gnu.org/packages/")
			 ("melpa" . "https://melpa.org/packages/")
			 ("org"   . "https://orgmode.org/elpa/")))

(message "set archives")
(package-initialize)
(message "2nd section")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Bootstrapping use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))





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

(straight-use-package 'org)

;;; adding use package evil binding from https://www.mattduck.com/2023-08-28-extending-use-package-bind
(add-to-list 'use-package-keywords :vbind t)

(defun use-package-normalize/:vbind (name keyword args)
  "Custom use-keyword :vbind. I use this to provide something similar to ':bind',
but with two additional features that I miss from the default implementation:

1. Integration with 'evil-define-key', so I can extend the keymap declaration
   to specify one or more evil states that the binding should apply to.

2. The ability to detect keymaps that aren't defined as prefix commands. This
   allows me to define a binding to a keymap variable, eg. maybe I want '<leader>h'
   to trigger 'help-map'. This fails using the default ':bind', meaning that I
   have to fall back to calling 'bind-key' manually if I want to assign a
   prefix.

The expected form is slightly different to 'bind':

((:map (KEYMAP . STATE) (KEY . FUNC) (KEY . FUNC) ...)
 (:map (KEYMAP . STATE) (KEY . FUNC) (KEY . FUNC) ...) ...)

STATE is the evil state. It can be nil or omitted entirely. If given, it should be an
argument suitable for passing to 'evil-define-key' -- meaning a symbol like 'normal', or
a list like '(normal insert)'."
  (setq args (car args))
  (unless (listp args)
    (use-package-error ":vbind expects ((:map (MAP . STATE) (KEY . FUNC) ..) ..)"))
  (dolist (def args args)
    (unless (and (eq (car def) :map)
                 (consp (cdr def))
                 (listp (cddr def)))
      (use-package-error ":vbind expects ((:map (MAP . STATE) (KEY . FUNC) ..) ..)"))))

(defun use-package-handler/:vbind (name _keyword args rest state)
  "Handler for ':vbind' use-package extension. See 'use-package-normalize/:vbind' for docs."
  (let ((body (use-package-process-keywords name rest
                (use-package-plist-delete state :vbind))))
    (use-package-concat
     `((with-eval-after-load ',name
         ,@(mapcan
            (lambda (entry)
              (let ((keymap (car (cadr entry)))
                    (state (cdr (cadr entry)))
                    (bindings (cddr entry)))
                (mapcar
                 (lambda (binding)
                   (let ((key (car binding))
                         (val (if (and (boundp (cdr binding)) (keymapp (symbol-value (cdr binding))))
                                  ;; Keymaps need to be vars without quotes
                                  (cdr binding)
                                ;; But functions need to be quoted symbols
                                `(quote ,(cdr binding)))))
                     ;; When state is provided, use evil-define-key. Otherwise fall back to bind-key.
                     (if state
                         `(evil-define-key ',state ,keymap (kbd ,key) ,val)
                       `(bind-key ,key ,val ,keymap))))
                 bindings)))
            args)))
     body)))



;;; This is the actual config file. It is omitted if it doesn't exist so emacs won't refuse to launch.
(when (file-readable-p "~/.emacs.d/config.org")
  (org-babel-load-file (expand-file-name "~/.emacs.d/config.org")))

;;; Experimental email stuff.
(when (file-readable-p "~/.email/email.org")
  (org-babel-load-file (expand-file-name "~/.email/email.org")))

;;; Anything below is personal preference.
;;; I recommend changing these values with the "customize" menu
;;; You can change the font to suit your liking, it won't break anything.
(setq custom-file "~/.emacs.d/.taymacs-custom.el")
(load custom-file)
;;; The one currently set up is called Terminus.
;; (custom-set-variables
;; custom-set-variables was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.

;; If there is more than one, they won't work right.
;;  '(ansi-color-names-vector
;;    ["#303030" "#f2241f" "#67b11d" "#b1951d" "#4f97d7" "#a31db1" "#28def0" "#b2b2b2"])
;;  '(custom-safe-themes
;;    (quote
;;     ("0230fd6c26a0805f34a634fc34de284e414982db2e31c696638f521201919f83" "26d49386a2036df7ccbe802a06a759031e4455f07bda559dcf221f53e8850e69" "922b4d7f68af5017f980398284229c81bb94ac17b9f3f23082dd0a4b2d0c7666" default)))
;;  '(eww-search-prefix "https://duckduckgo.com/lite/?q=")
;;  '(org-journal-date-format "%A, %d %B %Y")
;;  '(org-journal-dir "~/notes/journal/")
;;  '(package-selected-packages
;;    (quote
;;     (moe-theme color-theme-modern cider haskell-mode forge prettier-js org-journal web-mode key-chord evil doom-modeline diff-hl aggressive-indent ace-window helm-ag vue-mode salaire-mode doom-themes editorconfig telephone-line eyeliner spaceline-all-the-icons tabbar neotree js2-refactor company-tern tern ergoemacs-mode dracula-theme golden-ratio-scroll-screen slime-company slime company-jedi zzz-to-char rainbow-delimiters avy ivy projectile sunrise-x-modeline sunrise-x-buttons sunrise-commander twittering-mode zerodark-theme pretty-mode flycheck-clang-analyzer flycheck-irony flycheck yasnippet-snippets yasnippet company-c-headers company-shell company-irony irony irony-mode company-lua mark-multiple expand-region swiper popup-kill-ring dmenu ido-vertical-mode ido-vertical ox-html5slide centered-window-mode htmlize ox-twbs diminish erc-hl-nicks symon rainbow-mode switch-window dashboard smex company sudo-edit emms magit org-bullets hungry-delete beacon linum-relative spaceline fancy-battery exwm which-key use-package)))
;;  '(pos-tip-background-color "#36473A")
;;  '(pos-tip-foreground-color "#FFFFC8")
;;  '(safe-local-variable-values
;;    (quote
;;     ((eval progn
;;            (add-to-list
;;             (quote exec-path)
;;             (concat
;;              (locate-dominating-file default-directory ".dir-locals.el")
;;              "node_modules/.bin/"))))))
;;  '(tabbar-separator (quote (0.5))))
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 116 :width normal :foundry "1ASC" :family "xos4 Terminus"))))
;;  '(fringe ((t (:background "#292b2e")))))
(put 'narrow-to-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#303030" "#f2241f" "#67b11d" "#b1951d" "#4f97d7" "#a31db1" "#28def0" "#b2b2b2"])
 '(custom-safe-themes
   '("0230fd6c26a0805f34a634fc34de284e414982db2e31c696638f521201919f83" "26d49386a2036df7ccbe802a06a759031e4455f07bda559dcf221f53e8850e69" "922b4d7f68af5017f980398284229c81bb94ac17b9f3f23082dd0a4b2d0c7666" default))
 '(eaf-find-alternate-file-in-dired t t)
 '(eww-search-prefix "https://duckduckgo.com/lite/?q=")
 '(org-journal-date-format "%A, %d %B %Y")
 '(org-journal-dir "~/notes/journal/")
 '(package-selected-packages
   '(eloud nnhackernews elfeed-org elfeed emms-player-mpv elpher auctex tide company-lsp lsp-ui lsp-metals lsp-mode sbt-mode scala-mode prettier paredit ace-link ivy-prescient counsel-projectile all-the-icons-dired language-detection modus-vivendi-theme evil-surround evil-collection moe-theme color-theme-modern cider haskell-mode forge prettier-js org-journal web-mode key-chord evil doom-modeline diff-hl aggressive-indent ace-window helm-ag vue-mode salaire-mode doom-themes editorconfig telephone-line eyeliner spaceline-all-the-icons tabbar neotree js2-refactor company-tern tern ergoemacs-mode dracula-theme golden-ratio-scroll-screen slime-company slime company-jedi zzz-to-char rainbow-delimiters avy ivy projectile sunrise-x-modeline sunrise-x-buttons sunrise-commander twittering-mode zerodark-theme pretty-mode flycheck-clang-analyzer flycheck-irony flycheck yasnippet-snippets yasnippet company-c-headers company-shell company-irony irony irony-mode company-lua mark-multiple expand-region swiper popup-kill-ring dmenu ido-vertical-mode ido-vertical ox-html5slide centered-window-mode htmlize ox-twbs diminish erc-hl-nicks symon rainbow-mode switch-window dashboard smex company sudo-edit emms magit org-bullets hungry-delete beacon linum-relative spaceline fancy-battery exwm which-key use-package))
 '(pos-tip-background-color "#36473A")
 '(pos-tip-foreground-color "#FFFFC8")
 '(projectile-completion-system nil)
 '(safe-local-variable-values
   '((eval progn
           (add-to-list 'exec-path
                        (concat
                         (locate-dominating-file default-directory ".dir-locals.el")
                         "node_modules/.bin/")))))
 '(tabbar-separator '(0.5)))
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight bold :height 120 :width normal :foundry "SRC" :family "Hack")))))
