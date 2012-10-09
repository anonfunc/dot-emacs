;;{{{ el-get
;;{{{   Setup and bootstrap

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(setq el-get-user-package-directory "~/.emacs.d/packages.d/")

(unless (require 'el-get nil t)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

;;}}}
;;{{{   List of packages

;; local sources
(setq el-get-sources '((:name region-bindings-mode
			      :type github
			      :username "fgallina"
			      :pkgname "region-bindings-mode"
			      :features region-bindings-mode
			      :after (progn (region-bindings-mode-enable)))
		       (:name flymake-shell
			      :type github
			      :username "purcell"
			      :pkgname "flymake-shell")
		       (:name eshell-manual
			      :description "eshell is great but lacks a good manual, someone wrote one."
			      :type github
			      :pkgname "nicferrier/eshell-manual"
			      :build (("make" "eshell.info"))
			      :compile nil
			      :info "eshell.info")
		       (:name folding 
			      :post-init (folding-mode-add-find-file-hook))
		       (:name fold-dwim
			      :type http
			      :url "http://www.dur.ac.uk/p.j.heslin/Software/Emacs/Download/fold-dwim.el"
			      :features fold-dwim)
		       (:name fold-dwim-org
			      :type emacswiki
			      :features fold-dwim-org
			      :depends fold-dwim
			      :after (add-hook 'folding-mode-hook 'fold-dwim-org/minor-mode))
		       (:name elisp-slime-nav
			      :type github
			      :username "purcell"
			      :pkgname "elisp-slime-nav")
		       ))

(setq my-packages '(
		    ;; PKG management
		    el-get
		    ;; Color
		    color-theme-solarized
		    ;; Interface
		    ido-ubiquitous
		    evil
		    autopair
		    ace-jump-mode
		    auto-complete
                    expand-region
                    multiple-cursors
		    ;; Sunrise commander
		    sunrise-commander
		    sunrise-x-mirror
		    sunrise-x-loop
		    sunrise-x-modeline
		    ;; Programming
		    lua-mode
		    flymake-cursor
		    yasnippet
		    paredit
		    zencoding-mode
		    ;; VCS
		    magit
		    magithub
		    ;; Other
		    org-mode
		    ))


(el-get 'sync (append
	       my-packages
	       (mapcar 'el-get-source-name el-get-sources)))

;;}}}
;;}}}
;;{{{ Behavior tweaks
;;{{{   Disable backups
(setq backup-inhibited t)
(setq auto-save-default nil)
;;}}}
;;{{{   Speed tweaks
(setq font-lock-verbose nil)
(setq vc-handled-backends '(Git))
;;}}}
;;{{{   Modern sentences
(setq sentence-end-double-space nil)
;;}}}
;;}}}
;;{{{ Interface
;;{{{   Font
;;      Same fonts have different names on each platform.
(case window-system
  ('ns (set-frame-font "Source Code Pro 18")))
;;}}}
;;{{{   Minimization
(setq inhibit-splash-screen t)
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
;;}}}
;;{{{   Color
(defun my-theme () 
  (if (equalp (getenv "SCHEME") "light")
      (color-theme-solarized-light)
    (color-theme-solarized-dark)))

(if window-system (my-theme))
;;}}}
;;{{{   Ido
(ido-mode t)
(ido-ubiquitous-mode)
;;}}}
;;{{{   Ibuffer

(global-set-key (kbd "C-x C-b") 'ibuffer)
(autoload 'ibuffer "ibuffer" "List buffers." t)
(eval-after-load 'ibuffer
  '(progn
     (add-hook 'ibuffer-mode-hook
	       (lambda () (ibuffer-auto-mode 1)))
     (setq ibuffer-show-empty-filter-groups nil
	   ibuffer-expert t)
     (setq ibuffer-saved-filter-groups
	   `(("default"
	      ("wanderlust" (or (mode . wl-draft-mode)
				(mode . wl-folder-mode)
				(mode . wl-summary-mode)))
	      ("magit" (name . "^\\*magit"))
	      ("@workplace@" (filename . "^~/@workplace@"))
	      ("dired" (mode . dired-mode))
	      ("elisp" (mode . emacs-lisp-mode))
	      ("org" (or (mode . org-mode)
			 (name . "^\\*Agenda")
			 (name . "Agenda\\*$")))
	      ("special" (name . "^\\*")))))
     (defun my-ibuffer-groups ()
       (ibuffer-switch-to-saved-filter-groups "default"))
     (add-hook 'ibuffer-mode-hook 'my-ibuffer-groups)))

;;}}}
;;{{{   Window Management

(when (fboundp 'winner-mode)
  (winner-mode 1)
  (global-set-key (kbd "<mouse-8>") 'winner-undo)
  (global-set-key (kbd "<mouse-9>") 'winner-redo))

;;}}}
;;{{{   CUA Mode (no stomping on C-x C-c)
(cua-selection-mode t)
;;}}}
;;{{{   Expand Region
(global-set-key (kbd "C-=") 'er/expand-region)

;;}}}
;;{{{   Multiple-Cursors
(global-set-key (kbd "C-c C-SPC") 'mc/edit-lines)
(global-set-key (kbd "C-c C-e") 'mc/edit-ends-of-lines)
(global-set-key (kbd "C-c C-a") 'mc/edit-beginnings-of-lines)

;; Rectangular region mode
(global-set-key (kbd "C-c RET") 'set-rectangular-region-anchor)

;; Mark more like this
(define-key region-bindings-mode-map "a" 'mc/mark-all-like-this)
(define-key region-bindings-mode-map "p" 'mc/mark-previous-like-this)
(define-key region-bindings-mode-map "n" 'mc/mark-next-like-this)
(define-key region-bindings-mode-map "m" 'mc/mark-more-like-this-extended)
;;}}}
;;{{{   Misc Bindings

;; Ace-jump-mode
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

;; F11 for sunrise commander
(global-unset-key (kbd "<f11>"))
(global-set-key (kbd "<f11>") 'sunrise)
;; Safe alternative
(global-set-key (kbd "C-c s") 'sunrise)

;; F12 for magit
(global-unset-key (kbd "<f12>"))
(global-set-key (kbd "<f12>") 'magit-status)
;; Safe alternative
(global-set-key (kbd "C-c g") 'magit-status)


;; Don't bother me as much
(defalias 'yes-or-no-p 'y-or-n-p)

;; Jump to .emacs
(defun my-edit-dot-emacs ()
  (interactive)
  (find-file "~/.emacs"))
(global-set-key (kbd "C-c e") 'my-edit-dot-emacs)

;;}}}

;;}}}
;;{{{ Programming
;;{{{   Lisps
;; Paredit
(mapc (lambda (mode)
	(let ((hook (intern (concat (symbol-name mode)
				    "-mode-hook"))))
	  (add-hook hook (lambda () (paredit-mode +1)))))
      '(emacs-lisp lisp inferior-lisp))

;; Add M-* and M-, to elisp buffers
(add-hook 'emacs-lisp-mode-hook (lambda () (elisp-slime-nav-mode t)))

;;}}}
;;{{{   Projectile

;(setq projectile-enable-caching t)
;(projectile-global-mode)

;;}}}
;;{{{   Flymake
(require 'flymake-cursor)
;;}}}
;;{{{   Tags
(setq tags-revert-without-query t)
;;}}}
;;{{{   CEDET and Java
;; (load-file "/usr/share/emacs/site-lisp/cedet/common/cedet.el")
;; (require 'ede)
;; (require 'semantic)
;; (global-ede-mode 1)
;; (global-semanticdb-minor-mode 1)
;; (semantic-load-enable-minimum-features)
;; (semantic-add-system-include (getenv "JAVA_HOME") 'java-mode)
;; (semantic-add-system-include (expand-file-name "~/@workplace@/shared") 'java-mode)
;; (semantic-add-system-include (expand-file-name "~/@workplace@/oms") 'java-mode)
;; (setq cedet-java-jdk-root (getenv "JAVA_HOME"))
;; (add-to-list 'semanticdb-javap-classpath (substitute-in-file-name "$JAVA_HOME/jre/lib/rt.jar"))
;; (add-to-list 'semanticdb-javap-classpath (expand-file-name "~/@workplace@/shared/lib"))
;; (add-to-list 'semanticdb-javap-classpath (expand-file-name "~/@workplace@/oms/lib"))
;; (require 'auto-complete-config)
;; (ac-config-default)

;; (ede-project "@workplace@"
;; 	     :name "@workplace@"
;; 	     :file "~/@workplace@/build.xml"	    
;; 	     )
;;}}}
;;{{{   YASnippet
(yas-global-mode 1)
(yas-load-directory "~/.emacs.d/snippets" t)
(defalias 'yas/snippets-at-point 'yas--snippets-at-point) ;; fold-dwim-org compatibility
;;}}}
;;}}}
;;{{{ Org Mode
;;{{{   Requires
(require 'org)
(require 'org-protocol)
;;(require 'org-velocity)
;;}}}
;;{{{   Org variables

(setq org-hide-leading-stars t
      org-completion-use-ido t
      org-outline-path-complete-in-steps nil
      org-enforce-todo-checkbox-dependencies t
      org-enforce-todo-dependencies t
      org-special-ctrl-a/e t
      org-special-ctrl-k t
      org-yank-adjusted-subtrees t
      org-startup-indented t
      org-use-fast-todo-selection t
      org-directory "~/org"
      org-default-notes-file (concat org-directory "/notes.org")
      org-mobile-directory "~/Dropbox/mobileorg"
      org-mobile-creating-agendas t

      org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "STARTED(s)" "|" "DONE(d!/!)")
	(sequence "WAITING(w@/!)" "SOMEDAY(S!)" "|" "CANCELLED(c@/!)"))


      org-capture-templates
      '(("e" "Capture email" entry (file "inbox.org")
	 "* %^{Title}\nSource: %a\n%i")
	("t" "todo" entry (file "inbox.org")
	 "* TODO %?\n%U\n%a\n  %i" :clock-in t :clock-resume t)
	("T" "todo, sourceless" entry (file "inbox.org")
	 "* TODO %?\n%U\n  %i" :clock-in t :clock-resume t)
	("h" "Habit" entry (file "inbox.org")
	 "* NEXT %?\n%U\n%a\nSCHEDULED: %t .+1d/3d\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n  %i")
	("w" "org-protocol" entry (file "inbox.org")
	 "* TODO Review %c\n%U\n  %i" :immediate-finish t))

      org-refile-targets '((nil :maxlevel . 9)
			   (org-agenda-files :maxlevel . 9))
      org-refile-use-outline-path t
      org-refile-allow-creating-parent-nodes (quote confirm)

      ;; For better sunset calc
      calendar-latitude 37.662 
      calendar-longitude -121.874
      calendar-location-name "Pleasanton, CA"
      org-mobile-files-exclude-regexp "calendar")

;;}}}
;;{{{   Capture keys

(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

;;}}}
;;{{{   Fast nav
;; From http://orgmode.org/worg/org-hacks.html
(defun ded/org-show-next-heading-tidily ()
  "Show next entry, keeping other entries closed."
  (if (save-excursion (end-of-line) (outline-invisible-p))
      (progn (org-show-entry) (show-children))
    (outline-next-heading)
    (unless (and (bolp) (org-on-heading-p))
      (org-up-heading-safe)
      (hide-subtree)
      (error "Boundary reached"))
    (org-overview)
    (org-reveal t)
    (org-show-entry)
    (show-children)))

(defun ded/org-show-previous-heading-tidily ()
  "Show previous entry, keeping other entries closed."
  (let ((pos (point)))
    (outline-previous-heading)
    (unless (and (< (point) pos) (bolp) (org-on-heading-p))
      (goto-char pos)
      (hide-subtree)
      (error "Boundary reached"))
    (org-overview)
    (org-reveal t)
    (org-show-entry)
    (show-children)))

(setq org-use-speed-commands t)
(setq org-speed-commands-user
      '(("n" . ded/org-show-next-heading-tidily)
	("p" . ded/org-show-previous-heading-tidily)
	("J" . org-clock-goto)))
;;}}}
;;{{{   Org link abbrevs

;; (setq org-link-abbrev-alist
;;        '(("jira" . "https://jira.@workplace@.com/browse/")
;; 	;;("devdrop" . "https://env.@xyzzy@.com:9030/oms/fx/search.flex?q=%s")
;;  	;;("work" . "http://localhost:4444/work/fx/search.flex?q=%s")
;;  	;;("work" . "https://dev.@xyzzy@.com/work/fx/search.flex?q=%s")
;;  	;;("work" . "https://dev.@xyzzy@.com/oms/fx/search.flex?q=%s")
;;  	))

;;  (defun my-org-make-ids-links ()
;;    (interactive)
;;    (save-excursion
;;      (query-replace-regexp " \\([0-9]+[$.][0-9]+\\)" " [[devdrop:\\1][\\1]]")))

;; ;; Dark backgrounds for code blocks:
;; (setq org-export-html-style
;;       "<style type=\"text/css\">
;; <!--/*--><![CDATA[/*><!--*/
;; pre.src { color: #f6f3e8 !important; background-color: #242424 !important; }
;; /*]]>*/-->
;; </style>")

;;}}}
;;{{{   Org-mobile pull/push cron
(defun my-org-mobile-pull/push ()
  (interactive)
  (org-mobile-pull)
  (org-mobile-push))

;; Every 15 minutes.
(run-at-time t 900 'my-org-mobile-pull/push)
;;}}}
;;{{{   Custom agenda commands
(setq org-agenda-custom-commands
      '(("o" "Overview"
	 ((tags-todo "+home")
	  (tags-todo "+work")
	  (tags-todo "-home-work")
	  (agenda ""))
	 ((org-agenda-ndays 1)))
	("h" tags-todo "+home")
	("w" tags-todo "+work")))
;;}}}
;;{{{   DISABLED Org-velocity stuff
;;(global-set-key (kbd "C-c v") 'org-velocity-read)
;;(setq org-velocity-bucket "~/org/velocity.org")
;;}}}
;;{{{   Org and YASnippet

(defun yas/org-very-safe-expand ()
  (let ((yas/fallback-behavior 'return-nil)) (yas/expand)))

(add-hook 'org-mode-hook
	  (lambda ()
	    (make-variable-buffer-local 'yas/trigger-key)
	    (setq yas/trigger-key [tab])
	    (add-to-list 'org-tab-first-hook 'yas/org-very-safe-expand)
	    (define-key yas/keymap [tab] 'yas/next-field)))

;;}}}
;;{{{   Org, Notifications and Appt
(require 'appt)
(setq appt-message-warning-time 15
      appt-display-mode-line t
      appt-display-format 'window)
(appt-activate 1)
(display-time)

(org-agenda-to-appt t)
(add-hook 'org-finalize-agenda-hook 'org-agenda-to-appt)

;;}}}
;;{{{   Org Link types
(setq org-link-abbrev-alist
       '(("jira" . "https://jira.@workplace@.com/browse/")
	 ("review" . "https://crucible.@workplace@.com/cru/")
 	))
;;}}} 
;;}}}
;;{{{ Mail setup

;;{{{   SMTP
(setq starttls-use-gnutls t
      send-mail-function 'smtpmail-send-it
      message-send-mail-function 'smtpmail-send-it
      smtpmail-starttls-credentials '(("owa.mailseat.com" 587 nil nil))
      smtpmail-auth-credentials (expand-file-name "~/.authinfo")
      smtpmail-default-smtp-server "owa.mailseat.com"
      smtpmail-smtp-server "owa.mailseat.com"
      smtpmail-smtp-service 2525
      smtpmail-debug-info t)
(require 'smtpmail)
;;}}}
;;{{{   org-contacts
(setq org-contacts-files '("~/org/contacts.org"))
;;}}}
;;{{{   mu4e
(when  (require 'mu4e nil t)
  (setq mu4e-org-contacts-file "~/org/contacts.org"
	mu4e-maildir       "~/Mail/@workplace@"   ;; top-level Maildir
	mu4e-sent-folder   "/sent"       ;; where do i keep sent mail?
	mu4e-drafts-folder "/Drafts"     ;; where do i keep half-written mail?
	mu4e-trash-folder  "/Trash"     ;; where do i move deleted mail?
	user-mail-address "@first@.@last@@@workplace@.com"
	user-full-name "@First@ @Last@"
	mail-user-agent 'mu4e-user-agent
	mu4e-get-mail-command "pkill -SIGUSR1 offlineimap"
	;;     mu4e-html2text-command "html2text -nobs -utf8 -width 72"
	mu4e-html2text-command "my-html2text"
	)
  (add-to-list 'mu4e-headers-actions
	       '("org-contact-add" ?o mu4e-action-add-org-contact) t)
  (add-to-list 'mu4e-view-actions
	       '("org-contact-add" ?o mu4e-action-add-org-contact) t)
  (global-set-key (kbd "C-c m") 'mu4e)

  ;; Patch in a maildirproc button.
  (defun my-mu4e-maildirproc ()
    (interactive)
    (let ((mu4e-get-mail-command "maildirproc --once"))
      (mu4e-update-mail-show-window)))
  (defun my-add-maildirproc-mu4e-command ()
    (let ((buf (get-buffer-create mu4e~main-buffer-name))
	  (inhibit-read-only t))
      (with-current-buffer buf
	(insert
	 (mu4e~main-action-str "\t* [m]aildirproc\n" 'my-mu4e-maildirproc)))))
  (define-key mu4e-main-mode-map "m" 'my-mu4e-maildirproc)
  (defadvice mu4e~main-view (after my-ad-maildirproc activate)
    (my-add-maildirproc-mu4e-command)))
;;}}

;;}}}

;;}}}
;;{{{ Modules
;;{{{    Display Battery Time
(setq battery-mode-line-format "[%b%p%% %t]")
(display-battery-mode)
;;}}}
;;{{{    TODO Sunrise Mode?
;;}}}
;;}}}

(setq fold-dwim-org/trigger-keys-block (list [tab] [lefttab] [(control tab)]))

;; Custom
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files (quote ("~/org/habits.org" "~/org/calendars/gcal.org" "~/org/calendars/exchange.org" "~/org/personal.org" "~/org/work.org" "~/org/shopping.org" "~/org/inbox.org" "~/org/from-mobile.org")))
 '(org-modules (quote (org-bbdb org-bibtex org-docview org-gnus org-info org-jsinfo org-habit org-irc org-mew org-mhe org-protocol org-rmail org-vm org-wl org-w3m)))
 '(safe-local-variable-values (quote ((eval folding-mode t) (folded-file . t)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;; Local Variables:
;; mode: lisp
;; end:
