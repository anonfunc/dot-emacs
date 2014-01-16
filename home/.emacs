;; Load up org-mode and org-babel.
;; Should look for the el-get version if already bootstrapped.
;; (org-babel-tangle-file (expand-file-name "~/.emacs.d/init.org") (expand-file-name "~/.emacs.d/init.el") "emacs-lisp")
(require 'package)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(add-to-list 'package-archives '("sunrise" . "http://joseito.republika.pl/sunrise-commander/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)


;; Deal with broken js2 in gnu repo.
(setq package-archive-exclude-alist '(("gnu" . 'js2-mode)))
(let ((pkg 'package-filter))
  (unless (package-installed-p pkg)
    (package-refresh-contents) ; Need to get list to install this first time.
    (package-install pkg)
    (require 'package-filter)
    (package-refresh-contents)))

(when (not package-archive-contents)
  (package-refresh-contents))

(let ((pkg 'org-plus-contrib)) (or (package-installed-p pkg) (package-install pkg)))
(let ((vc-follow-symlinks 't))
  (org-babel-load-file (expand-file-name "~/.emacs.d/init.org")))

(put 'narrow-to-region 'disabled nil)
(put 'set-goal-column 'disabled nil)
