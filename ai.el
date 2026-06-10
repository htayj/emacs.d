(use-package vterm
  :preface
  ;; Prefer the Guix-packaged vterm over an older straight checkout that tries
  ;; to compile in-place under ~/.emacs.d.
  (setq load-path
        (delete (expand-file-name "straight/build/vterm" user-emacs-directory)
                (delete (expand-file-name "straight/repos/emacs-libvterm" user-emacs-directory)
                        load-path)))
  ;; Guix installs the native module alongside the package root, but the
  ;; loaded `vterm.elc' does not always find it automatically.
  (let* ((vterm-lib (locate-library "vterm"))
         (vterm-root (and vterm-lib (file-name-directory vterm-lib))))
    (dotimes (_ 4)
      (setq vterm-root
            (and vterm-root
                 (file-name-directory (directory-file-name vterm-root)))))
    (let ((vterm-module
           (and vterm-root
                (expand-file-name
                 (concat "lib/vterm-module" module-file-suffix)
                 vterm-root))))
      (when (and vterm-module
                 (file-exists-p vterm-module)
                 (not (featurep 'vterm-module)))
        (module-load vterm-module))))
  :straight nil
  :ensure nil)

(use-package ai-code
  :straight (:host github :repo "tninja/ai-code-interface.el")
  :bind (("C-c a" . ai-code-menu))
  :config
  (ai-code-set-backend 'codex)
  (setq ai-code-backends-infra-terminal-backend 'vterm)
  (with-eval-after-load 'evil
    (when (fboundp 'ai-code-backends-infra-evil-setup)
      (ai-code-backends-infra-evil-setup)))
  (with-eval-after-load 'magit
    (when (fboundp 'ai-code-magit-setup-transients)
      (ai-code-magit-setup-transients))))

(use-package aidermacs
  :bind (("C-c A" . aidermacs-transient-menu))
  :config
  (when-let ((key (getenv "DEEPSEEK_API_KEY")))
  (setenv "DEEPSEEK_API_KEY" key))
  :custom
  (aidermacs-default-chat-mode 'architect)
  (aidermacs-default-model "deepseek/deepseek-reasoner"))
