;;; .emacs -- my dot emacs file
;;; Commentary:
;;; My .emacs file.
;;; Code:

;; Load up org-mode and org-babel.
;; Should look for the el-get version if already bootstrapped.
;; (org-babel-tangle-file (expand-file-name "~/.emacs.d/init.org") (expand-file-name "~/.emacs.d/init.el") "emacs-lisp")

(require 'package)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(add-to-list 'package-archives '("elpy" . "http://jorgenschaefer.github.io/packages/") t)
(add-to-list 'package-archives '("sunrise" . "http://joseito.republika.pl/sunrise-commander/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(let ((pkg 'org-plus-contrib)) (or (package-installed-p pkg) (package-install pkg)))
(setq vc-follow-symlinks t)
(org-babel-load-file (expand-file-name "~/.emacs.d/init.org"))

(put 'narrow-to-region 'disabled nil)
(put 'set-goal-column 'disabled nil)
