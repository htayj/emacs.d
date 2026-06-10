;; layers:
;; - frac: 𝔞𝔰𝔡𝔣 (Mode_switch)
;; - buh: H- (layer3 switch)
;; vanilla specific packages/bindings

(use-package use-package-chords
  :demand t)
(defun kb-verb (key)
  (format "M-%s" key))

(defun kb-noun-mark (key)
  (format "A-%s" key))

;; ================
;; general / uncat
;; ================

;; replacement for vim surround
(use-package surround
  :bind-keymap ("M-'" . surround-keymap))

(use-package emacs
  :bind (("C-k" . kill-whole-line)
         ("C-K" . kill-line)))
;; ================
;; verbs
;; ================



;; ================
;; nouns
;; ================

;; ----------------
;; region
;; ----------------

(use-package expand-region
	:bind (("C-;" . er/expand-region)
         ("A-W" . er/mark-word)
         ("A-w" . er/mark-subword)))
