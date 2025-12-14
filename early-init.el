;;; early-init.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2025 Taylor Hardy
;;
;; Author: Taylor Hardy <tay@work>
;; Maintainer: Taylor Hardy <tay@work>
;; Created: April 15, 2025
;; Modified: April 15, 2025
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex text tools unix vc wp
;; Homepage: https://github.com/tay/early-init
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:


(require 'package)
(setq package-enable-at-startup nil)

(setq package-archives '(("ELPA"  . "http://tromey.com/elpa/")
                         ("gnu"   . "http://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("org"   . "https://orgmode.org/elpa/")))
(package-initialize)
;;; early-init.el ends here
