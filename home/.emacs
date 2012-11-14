;; Load up org-mode and org-babel.  
;; TODO: Should look for the el-get version if already bootstrapped.
(require 'org)
(require 'ob-tangle)


;; (org-babel-tangle-file (expand-file-name "~/.emacs.d/init.org") (expand-file-name "~/.emacs.d/init.el") "emacs-lisp")
(org-babel-load-file (expand-file-name "~/.emacs.d/init.org"))
