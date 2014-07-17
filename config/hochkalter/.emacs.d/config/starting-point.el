(add-to-list 'load-path "~/.emacs.d")
;; (add-to-list 'load-path "~/.emacs.d/mmm-mode-0.4.8")
;; setup private info-files
(require 'info)
(setq Info-default-directory-list
      (cons (expand-file-name "~/.emacs.d/info")
            Info-default-directory-list
			)
	  )

(setq-default tab-width 4)
(mwheel-install)
(setq inhibit-startup-message t)		; schaltet Startnachricht aus
;; Rechtschreibung
(setq ispell-program-name "hunspell")
;; (add-to-list 'ispell-local-dictionary-alist
;; 			 '("de_DE_frami8" "[a-zA-Z\304\326\334\311\344\366\374\351\337]" "[^a-zA-Z\304\326\334\311\344\366\374\351\337]" "[']" t ("-d" "de_DE_frami") nil iso-8859-1))
(setq ispell-dictionary-base-alist
	  '((nil
		 "[a-zA-Z\304\326\334\311\344\366\374\351\337]" "[^a-zA-Z\304\326\334\311\344\366\374\351\337]" "[']" t ("-d" "de_DE_frami") nil iso-8859-1)
		("de_DE_frami8"
		 "[a-zäöüßA-ZÄÖÜ]" "[^a-zäöüßA-ZÄÖÜ]" "[']" t ("-d" "de_DE_frami") nil utf-8)
		("en_US" ; Yankee English
		 "[A-Za-z]" "[^A-Za-z]" "[']" t ("-d" "en_US") nil iso-8859-1)
		("en_GB" ; British English
		 "[A-Za-z]" "[^A-Za-z]" "[']" t ("-d" "en_GB") nil iso-8859-1)
		)
	  )
(setq ispell-personal-dictionary "~/.hunspell_deutsch")
(setq ispell-dictionary "de_DE_frami8")
(setq ispell-silently-savep t)
;; (setq ispell-dictionary-alist '((nil ; default
;;               "[a-zäöüßA-ZÄÖÜ]" "[^a-zäöüßA-ZÄÖÜ]" "[']" t ("-d"  
;; "de_DE" "-i" "utf-8") nil utf-8)
;;              ("american" ; Yankee English
;;               "[A-Za-z]" "[^A-Za-z]" "[']" t ("-d" "en_US" "-i"  
;; "utf-8") nil utf-8)
;;              ("british" ; British English
;;               "[A-Za-z]" "[^A-Za-z]" "[']" t ("-d" "en_GB" "-i"  
;; "utf-8") nil utf-8)
;;              ("deutsch"
;;               "[a-zäöüßA-ZÄÖÜ]" "[^a-zäöüßA-ZÄÖÜ]" "[']" t ("-d"  
;; "de_DE" "-i" "utf-8") nil utf-8)
;;              ("deutsch8"
;;               "[a-zäöüßA-ZÄÖÜ]" "[^a-zäöüßA-ZÄÖÜ]" "[']" t ("-d"  
;; "de_DE" "-i" "utf-8") nil utf-8)))
;; (eval-after-load "ispell"
;;    (progn
;;      (setq ispell-dictionary "deutsch8"
;;            ispell-extra-args '("-a" "-i" "utf-8")
;;            ispell-silently-savep t
;; 		   )
;; 	 )
;;    )
;; (setq-default ispell-program-name "hunspell")

(global-font-lock-mode t)
(tool-bar-mode -1) ;; disable toolbar
(setq scroll-conservatively 10000) ;; smooth scrolling
(setq scroll-preserve-screen-position nil) ;; cursor stays on point while scrolling
;; line numbers
;; (require 'setnu)
;; (setnu-mode)
;; enable SVN support
(add-to-list 'vc-handled-backends 'SVN)

;; Line wrapping
(setq fill-column 120)
(global-visual-line-mode t)
;; (auto-fill-mode nil)

(global-set-key (kbd "C-c g") 'goto-line)
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p) ;; make scripts executable after saving

;; Printing
(setq printer-name "deskjet-6122")
(setq ps-paper-type 'a4)
(setq ps-landscape-mode "landscape")
(setq ps-number-of-columns 2)

;; Tramp
(setq tramp-default-method "ssh")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; HideShow Minor-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load-library "hideshow")
(defun display-code-line-counts (ov)
  (when (eq 'code (overlay-get ov 'hs))
	(overlay-put ov 'display
				 (propertize
				  (format " ... <%d>" (count-lines (overlay-start ov) (overlay-end ov)))
				  'face 'font-lock-type-face)
				 )
	)
  )
(setq hs-set-up-overlay 'display-code-line-counts)
(setq hs-isearch-open t)
(defadvice goto-line (after expand-after-goto-line activate compile)
  "hideshow-expand affected block when using goto-line in a collapsed buffer"
  (save-excursion
	(hs-show-block))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LaTex via AUCTeX
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'tex-site)
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)
(setq reftex-plug-into-AUCTeX t)
(setq reftex-enable-partial-scans t)
(setq reftex-save-parse-info t)
(setq reftex-use-multiple-selection-buffers t)
(setq reftex-use-external-file-finders t)
(setq reftex-external-file-finders
      '(("tex" . "kpsewhich -format=.tex %f")
              ("bib" . "kpsewhich -format=.bib %f")))
;; (setq reftex-label-alist
;; 	  '(("figure" ?f "fig:" "\\figref{%s}" caption nil)))
(setq reftex-fref-is-default t)
(setq bib-cite-use-reftex-view-crossref t)
(setq font-lock-maximum-decoration t)
(setq TeX-electric-sub-and-superscript t)
(add-hook 'LaTeX-mode-hook
		  '(lambda ()
			 (turn-on-reftex)
			 (LaTeX-math-mode t)
			 (TeX-fold-mode t)
			 (outline-minor-mode t)
			 )
		  )
;; ps4pdf ins Menü
(eval-after-load "tex"
  '(add-to-list 'TeX-command-list
                '("ps4pdf" "ps4pdf %s" TeX-run-command nil t :help "Run ps4pdf")))
;; WhizzyTeX
(add-hook 'whizzytex-mode-hook
          '(lambda ()
                                        ; use paragraph mode for the LaTeX class "beamer":
             (add-to-list 'whizzy-class-mode-alist '("beamer" . paragraph))
             (whizzy-default-bindings) ;keep default whizzytex-mode-hook
             )
          )
                                        ; slice on every frame while in paragraph mode:
(setq whizzy-paragraph-regexp "\n\\\\frame\\b[^{]*{")
                                        ;or slice also on sectionning:
;; (setq whizzy-paragraph-regexp "\\\\\\(\\(s\\(ubs\\(ub\\|\\)\\|\\)ection\\)\\|chapter\\|part\\|frame\\)\\b[^{]*{")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Cedet
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (load-file "~/.emacs.d/cedet-1.0pre7/common/cedet.el")
;; (semantic-load-enable-excessive-code-helpers)
;; (setq senator-minor-mode-name "SN")
;; ;; (setq semantic-imenu-auto-rebuilt-directory-indexes nil)
;; (global-srecode-minor-mode 1)
;; (global-semantic-mru-bookmark-mode 1)
;; (require 'semantic-decorate-include)
;; (require 'semantic-gcc)					; finds gcc libraries
;; (require 'semantic-ia)
;; (setq-mode-local c++-mode semanticdb-find-default-throttle
;; 				 '(proje-addct unloaded system recursive))
;; (require 'eassist)
;; (add-to-list 'eassist-header-switches '("hh" "cc" "cpp" "cxx"))
;; (add-to-list 'eassist-header-switches '("cc" "hh" "h" "hpp" "hxx"))
;; ;; keys for cedet
;; (defun keys-for-cedet-hook ()
;;   (local-set-key [(control return)] 'semantic-ia-complete-symbol-menu)
;;   (local-set-key "\C-c?" 'semantic-ia-complete-symbol)
;;   (local-set-key "\C-c>" 'semantic-complete-analyze-inline)
;;   (local-set-key "\C-c=" 'semantic-decoration-include-visit)
;;   (local-set-key "\C-cj" 'semantic-ia-fast-jump)
;;   (local-set-key "\C-cq" 'semantic-ia-show-doc)
;;   (local-set-key "\C-cs" 'semantic-ia-show-summary)
;;   (local-set-key "\C-cp" 'semantic-analyze-proto-impl-toggle)
;;   (local-set-key "\C-ct" 'eassist-switch-h-cpp)
;;   (local-set-key "\C-xt" 'eassist-switch-h-cpp)
;;   (local-set-key "\C-ce" 'eassist-list-methods)
;;   (local-set-key "\C-c\C-r" 'semantic-symref)
;;   )
;; (defun imenu-for-semantic-hook ()
;;   (imenu-add-to-menubar "TAGS")
;;   )
;; (add-hook 'semantic-init-hooks 'imenu-for-semantic-hook)
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(LaTeX-math-list (quote ((39 "dagger" "nil" nil) (49 "shortuparrow" "Arrows" nil) (50 "shortdownarrow" "Arrows" nil) (57 "phantom" "nil" nil))))
 '(appt-message-warning-time 5)
 '(calendar-latitude 48.14)
 '(calendar-longitude 11.57)
 '(calendar-today-marker (quote font-lock-keyword-face))
 '(case-fold-search t)
 '(current-language-environment "UTF-8")
 ;; '(ecb-options-version "2.40")
 ;; '(global-semantic-tag-folding-mode t nil (semantic-util-modes))
 '(reftex-default-bibliography (quote ("physics.bib")))
 ;; '(semantic-self-insert-show-completion-function (lambda nil (semantic-ia-complete-symbol-menu (point))))
 '(wl-message-buffer-prefetch-folder-type-list nil))
;; (global-semantic-tag-folding-mode 1)
;; gnu global support
;; (require 'semanticdb-global)
;; (semanticdb-enable-gnu-global-databases 'c++-mode)
;; ctags
;; (require 'semanticdb-ectag)
;; (semantic-load-enable-primary-exuberent-ctags-support)

;; (semantic-add-system-include "~/Projecte/C++/include" 'c++-mode)
;; (semantic-add-system-include "~/Projecte/C++/include/boost-numeric-bindings" 'c++-mode)
;; (add-to-list 'semantic-lex-c-preprocessor-symbol-file "/usr/include/boost/config.hpp")
;; (global-semantic-idle-tag-highlight-mode 1)
;; (global-semantic-idle-scheduler-mode 1)
;; (global-semantic-idle-completions-mode 1)
;; (global-semantic-idle-summary-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ECB
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (add-to-list 'load-path "~/.emacs.d/ecb-2.40")
;; (require 'ecb-autoloads)


;; ede cutomization
;; (require 'semantic-lex-spp)
;; (global-ede-mode t)						; for projects

;; Example, Qt customization
;; (setq qt4-base-dir "/usr/include/qt4")
;; (setq qt4-gui-dir (concat qt4-base-dir "/QtGui"))
;; (semantic-add-system-include qt4-base-dir 'c++-mode)
;; (semantic-add-system-include qt4-gui-dir 'c++-mode)
;; (add-to-list 'auto-mode-alist (cons qt4-base-dir 'c++-mode))
;; (add-to-list 'semantic-lex-c-preprocessor-symbol-file (concat qt4-base-dir "/Qt/qconfig.h"))
;; (add-to-list 'semantic-lex-c-preprocessor-symbol-file (concat qt4-base-dir "/Qt/qconfig-large.h"))
;; (add-to-list 'semantic-lex-c-preprocessor-symbol-file (concat qt4-base-dir "/Qt/qglobal.h"))

;;;;;;;;;;;;;;;;;;;;;;
;;; Projekte
;; (setq cpp-qt-project
;; 	  (ede-cpp-root-project "tscheby"
;; 							:file "~/phd/calculations/tscheby-rlm/tools/roots.hh"
;; 							;; :system-include-path '("~/include")
;; 							;; :local-variables (list
;; 							;; 				  (cons 'compile-command 'alexott/gen-cmake-debug-compile-string)
;;                             ;;                   )
;; 							)
;; 	  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; C++/C
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (require 'eldoc)
;; (setq c-eldoc-includes "-I~/include -I~/include/boost-numeric-bindings -I. ")

(add-hook 'c++-mode-hook 
  '(lambda ()
     (c-set-style "stroustrup")
     (c-toggle-auto-hungry-state 0)
     (font-lock-mode t)
     (transient-mark-mode t)
     (show-paren-mode t)
;;   (let ((fbinds (where-is-internal 'forward-word))
;; 	   (bbinds (where-is-internal 'backward-word)))
;;        (while fbinds
;; 	 (define-key c++-mode-map (car fbinds)
;; 	   'c-forward-into-nomenclature)
;; 	 (setq fbins (cdr fbinds)))
;;        (while bbinds
;; 	 (define-key c++-mode-map (car bbinds)
;; 	   'c-backward-into-nomenclature)
;; 	 (setq bbinds (cdr bbinds))))
	 (hs-minor-mode 1)
	 ;; (turn-on-eldoc-mode)
	 ;; (gtags-mode 1)
	 (local-set-key [return] 'newline-and-indent)
     )
  )
;; (add-hook 'c++-mode-hook 'keys-for-cedet-hook)

(add-hook 'c-mode-hook 
  '(lambda ()
     (c-set-style "stroustrup")
;;     (c-toggle-auto-hungry-state)
     (font-lock-mode t)
     (transient-mark-mode t)
     (show-paren-mode t)
	 (hs-minor-mode 1)
    )
  )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Syntax-highlighting via develock
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq develock-max-column-plist '(list
								  'emacs-lisp-mode nil
								  'lisp-interaction-mode 'w
								  'change-log-mode t
								  'texinfo-mode t
								  'c-mode nil
								  'c++-mode nil
								  'java-mode nil
								  'jde-mode nil
								  'html-mode nil
								  'html-helper-mode nil
								  'cperl-mode nil
								  'mail-mode t
								  'message-mode t
								  'cmail-mail-mode t
								  )
	  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Emacs-Lisp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'emacs-lisp-mode-hook
		  '(lambda ()
			 (font-lock-mode t)
			 (transient-mark-mode t)
			 (show-paren-mode t)
			 (hs-minor-mode t)
			 )
		  )
(add-to-list 'auto-mode-alist '("\\.wl$" . emacs-lisp-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Perl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defalias 'perl-mode 'cperl-mode)
(add-hook 'cperl-mode-hook
		  '(lambda ()
			 (font-lock-mode t)
			 (transient-mark-mode t)
			 (show-paren-mode t)
			 (hs-minor-mode t)
			 (cperl-set-style "PerlStyle")
			 (setq cperl-hairy t)
			 (setq cperl-indent-level 4)
			 (setq cperl-extra-newline-before-brace nil)
			 (setq cperl-electric-linefeed t)
			 )
		  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Gnuplot
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(autoload 'gnuplot-mode "gnuplot" "gnuplot major mode" t)
(autoload 'gnuplot-make-buffer "gnuplot" "open a buffer in gnuplot-mode" t)
(setq auto-mode-alist (append '(("\\.gp$" . gnuplot-mode))
                              auto-mode-alist))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Schriftart und Fenstergröße wie es auch für Server/Emacsclient funktioniert
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'default-frame-alist '(menu-bar-lines . 1))
(add-to-list 'default-frame-alist '(tool-bar-lines . 0))
(add-to-list 'default-frame-alist '(height . 65))
(add-to-list 'default-frame-alist '(width . 132))
(add-to-list 'default-frame-alist '(font . "Liberation Mono-8"))
;; (require 'zenburn)
;; (color-theme-zenburn)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CSS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(autoload 'css-mode "css-mode")
(setq auto-mode-alist
	  (cons '("\\.css\\'" . css-mode) auto-mode-alist))
(setq cssm-indent-function #'cssm-c-style-indenter)
(add-hook 'css-mode-hook
		  '(lambda ()
			 (font-lock-mode t)
			 (transient-mark-mode t)
			 (show-paren-mode t)
			 )
		  )

;(autoload 'php-mode "php-mode" "PHP editing mode" t)
;(setq auto-mode-alist
;     (cons '("\\.php\\'" . php-mode) auto-mode-alist))


;;************************************************************
;; configure HTML editing
;;************************************************************
;;
;; (require 'php-mode)
;;

;; (add-hook 'php-mode-user-hook 'turn-on-font-lock)
;;
;; (require 'mmm-mode)
;; (setq mmm-global-mode 'maybe)
;;
;; set up an mmm group for fancy html editing
;; (mmm-add-group
;;  'fancy-html
;;  '(
;;    (html-php-tagged
;; 	:submode php-mode
;; 	:face mmm-code-submode-face
;; 	:front "<[?]php"
;; 	:back "[?]>")
;;    (html-css-attribute
;; 	:submode css-mode
;; 	:face mmm-declaration-submode-face
;; 	:front "style=\""
;; 	:back "\"")
;;    )
;;  )
;;
;; What files to invoke the new html-mode for?
;; (add-to-list 'auto-mode-alist '("\\.inc\\'" . html-mode))
;; (add-to-list 'auto-mode-alist '("\\.phtml\\'" . html-mode))
;; (add-to-list 'auto-mode-alist '("\\.php[34]?\\'" . html-mode))
;; (add-to-list 'auto-mode-alist '("\\.[sj]?html?\\'" . html-mode))
;; (add-to-list 'auto-mode-alist '("\\.jsp\\'" . html-mode))
;; (add-to-list 'auto-mode-alist '("\\.thtml\\'" . html-helper-mode))
;;
;; What features should be turned on in this html-mode?
;; (add-to-list 'mmm-mode-ext-classes-alist '(html-mode nil html-js))
;; (add-to-list 'mmm-mode-ext-classes-alist '(html-mode nil embedded-css))
;; (add-to-list 'mmm-mode-ext-classes-alist '(html-mode nil fancy-html))
;; (add-to-list 'mmm-mode-ext-classes-alist '(html-helper-mode "\.thtml\\'" fancy-html))
;;
;; Not exactly related to editing HTML: enable editing help with mouse-3 in all sgml files
(defun go-bind-markup-menu-to-mouse3 ()
  (define-key sgml-mode-map [(down-mouse-3)] 'sgml-tags-menu))
;;
(add-hook 'sgml-mode-hook 'go-bind-markup-menu-to-mouse3)
(setq sgml-warn-about-undefined-entities nil)

;; html included in perl
;; (add-to-list 'mmm-mode-ext-classes-alist '(cperl-mode nil here-doc))
;(add-to-list 'mmm-here-doc-mode-alist '("HTML" . html-helper-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; X-Resources
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(autoload 'xrdb-mode "xrdb-mode" "Mode for editing X resource files" t)
(setq auto-mode-alist
      (append '(("\\.Xdefaults$"    . xrdb-mode)
                ("\\.Xenvironment$" . xrdb-mode)
                ("\\.Xresources$"   . xrdb-mode)
                ("*.\\.ad$"         . xrdb-mode)
                )
              auto-mode-alist)
	  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)
(setq org-agenda-include-diary nil)
(setq org-deadline-warning-days 7)
(setq org-timeline-show-empty-dates t)
(setq org-insert-mode-line-in-empty-file t)
(setq org-agena-ndays 7)
(setq org-agenda-repeating-timestamp-show-all nil)
(setq org-agenda-restore-windows-after-quit t)
(setq org-agenda-show-all-dates t)
(setq org-agenda-skip-deadline-if-done t)
(setq org-agenda-skip-scheduled-if-done t)
(setq org-agenda-sorting-strategy (quote ((agenda time-up priority-down tag-up) (todo tag-up))))
(setq org-agenda-start-on-weekday nil)
(setq org-agenda-todo-ignore-deadlines t)
(setq org-agenda-todo-ignore-scheduled t)
(setq org-agenda-todo-ignore-with-date t)
(setq org-agenda-window-setup (quote other-window))
(setq org-deadline-warning-days 7)
;; (setq org-export-html-style "<link rel=\"stylesheet\" type=\"text/css\" href=\"mystyles.css\">")
(setq org-fast-tag-selection-single-key nil)
(setq org-log-done (quote (done)))
(setq org-refile-targets (quote (("newgtd.org" :maxlevel . 1) ("someday.org" :level . 2))))
(setq org-reverse-note-order nil)
(setq org-tags-column -78)
(setq org-tags-match-list-sublevels nil)
;; (setq org-time-stamp-rounding-minutes 5)
(setq org-use-fast-todo-selection t)
(setq org-directory "~/Dokumente/Planer/")
(setq org-todo-keywords 
	  '((sequence "TODO(t)" "WAITING(w)" "SOMEDAY(s)" "|" "DONE(d)" "CANCELLED(c)")))
(setq org-tag-alist 
	  '((:startgroup . nil) ("ARBEIT" . ?r) ("TRAUNSTEIN" . ?t) ("AACHEN" . ?a) (:endgroup . nil)
		("BEKE" . ?b) ("COMPUTER" . ?c) ("LESEN" . ?l) ("TELEFON" . ?f) ("BEWERBUNG" . ?j) ("GELD" . ?g)
		))
(setq org-use-tag-inheritance nil)
(setq org-agenda-files '("~/Dokumente/Planer/geburtstag.org" "~/Dokumente/Planer/newgtd.org" "~/Dokumente/Planer/bewerbungen.org"))
;; (setq org-mode-file-dir "~/.emacs.d/org-files")
;; (setq org-agenda-files (append (list org-mode-file-dir) org-agenda-files))
(autoload 'remember "remember" nil t)
(autoload 'remember-region "remember" nil t)

(setq org-default-notes-file "~/Dokumente/Planer/notes.org")
(setq remember-annotation-functions '(org-remember-annotation))
(setq remember-handler-functions '(org-remember-handler))
(add-hook 'remember-mode-hook 'org-remember-apply-template)
;; (define-key global-map "\C-cr" 'org-remember)

(setq org-remember-templates
     '(
      ("Todo" ?t "* TODO %^{Brief Description} %^g\n%?\nAdded: %U" "~/Dokumente/Planer/newgtd.org" "Tasks")
      ;; ("Privat" ?p "\n* %^{topic} %T \n%i%?\n" "~/Dokumente/Planer/privat.org")
      ("Zitat" ?w "\n* %^{topic} \n%i%?\n" "~/Dokumente/Planer/zitate.org")
      ))

(define-key global-map "\C-cr" 'remember)
(define-key global-map "\C-cR" 'remember-region)

(setq org-agenda-exporter-settings
      '((ps-number-of-columns 2)
        (ps-landscape-mode t)
        (htmlize-output-type 'css)))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; email related - Gnus, BBDB
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (require 'bbdb)
;; (setq bbdb-file "~/.emacs.d/.bbdb")
;; (setq bbdb-dwim-net-address-allow-redundancy t)
;; ;;Tell bbdb about your email address:
;; (setq bbdb-user-mail-names
;;       (regexp-opt
;; 	   '("Andreas@dieholzners.de"
;; 		 "Andreas.Holzner@physik.lmu.de"
;; 		 "holzner@theorie.physik.uni-muenchen.de"
;; 		 "Andreas.Holzner@rwth-aachen.de"
;; 		 "holzner@physik.rwth-aachen.de")
;; 	   )
;; 	  )
;; ;;cycling while completing email addresses
;; (setq bbdb-complete-name-allow-cycling t)

;; (require 'bbdb-wl)
;; (bbdb-wl-setup)
;; ;; enable pop-ups
;; (setq bbdb-use-pop-up t)
;; ;; auto collection
;; (setq bbdb/mail-auto-create-p t)
;; ;; exceptional folders against auto collection
;; (setq bbdb-wl-ignore-folder-regexp "^@")
;; (setq signature-use-bbdb t)
;; (setq bbdb-north-american-phone-numbers-p nil)
;; ;; shows the name of bbdb in the summary :-)
;; (setq wl-summary-from-function 'bbdb-wl-from-func)
;; ;; automatically add mailing list fields
;; (add-hook 'bbdb-notice-hook 'bbdb-auto-notes-hook)
;; (setq bbdb-auto-notes-alist '(("X-ML-Name" (".*$" ML 0))))

;; ;;; WanderLust
;; (autoload 'wl "wl" "WanderLust" t)
;; (autoload 'wl-other-frame "wl" "Wanderlust on new frame." t)
;; (autoload 'wl-draft "wl-draft" "Write draft with Wanderlust." t)
;; (autoload 'wl-user-agent-compose "wl-draft" nil t)
;; (if (boundp 'mail-user-agent)
;; 	(setq mail-user-agent 'wl-user-agent))
;; (if (fboundp 'define-mail-user-agent)
;; 	(define-mail-user-agent
;; 	  'wl-user-agent
;; 	  'wl-user-agent-compose
;; 	  'wl-draft-send
;; 	  'wl-draft-kill
;; 	  'mail-send-hook)
;;   )
;; (setq wl-message-id-domain "gamskogel")
;; (setq
;;  wl-stay-folder-window t                       ;; show the folder pane (left)
;;  wl-folder-window-width 25                     ;; toggle on/off with 'i'
;;  wl-insert-message-id nil
;; )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Calender, Diary, Appointment related mostly from http://www.coling.uni-freiburg.de/~schauer/de/emacs-konfig.html
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'diary-lib) ;; grr, diary doesn't provide itself
;(require 'diary-ins)
(require 'calendar)

;;; **************
;;; European/German settings for calendar ...
(setq european-calendar-style t)
(setq calendar-time-display-form
      '(24-hours ":" minutes (and time-zone (concat " (" time-zone ")"))))
(setq calendar-date-display-form
      '((if dayname (concat dayname ", ")) day " " monthname " " year))
;; grr, messing around with the calendar-date-display-form breaks
;; inserting dates that are matched by calendars `view-diary-entries'.
;(defvar insert-diary-entry-with-dayname nil
;  "Whether inserting diary entries from the calendar should insert daynames.")
;(defun insert-diary-entry (arg)
;  "Insert a diary entry for the date indicated by point.
;Prefix arg will make the entry nonmarking."
;  (interactive "P")
;  (make-diary-entry 
;   (calendar-date-string 
;    (calendar-cursor-to-date t) t (not insert-diary-entry-with-dayname))
;   arg))
;(setq insert-diary-entry-with-dayname nil)
; not true, something has gone wrong during config.

  
;; the following german settings are from Ch. Kulla
(setq calendar-week-start-day 1)	; Monday

(setq calendar-day-name-array
      ["Sonntag" "Montag" "Dienstag" "Mittwoch"
       "Donnerstag" "Freitag" "Samstag"])
(setq calendar-month-name-array
      ["Januar" "Februar" "März" "April" "Mai" "Juni"
       "Juli" "August" "September" "Oktober" "November" "Dezember"])
(setq solar-n-hemi-seasons
      '("Frühlingsanfang" "Sommeranfang" "Herbstanfang" "Winteranfang"))

(setq general-holidays
      '((holiday-fixed 1 1 "Neujahr")
		(holiday-fixed 5 1 "1. Mai")
		(holiday-fixed 10 3 "Tag der Deutschen Einheit")
		)
	  )

(setq christian-holidays
      '((holiday-float 12 0 -4 "1. Advent" 24)
		(holiday-float 12 0 -3 "2. Advent" 24)
		(holiday-float 12 0 -2 "3. Advent" 24)
		(holiday-float 12 0 -1 "4. Advent" 24)
		(holiday-fixed 12 25 "1. Weihnachtstag")
		(holiday-fixed 12 26 "2. Weihnachtstag")
		(holiday-fixed 1 6 "Heilige Drei Könige")
		;; Date of Easter calculation taken from holidays.el.
		(let* ((century (1+ (/ displayed-year 100)))
			   (shifted-epact (% (+ 14 (* 11 (% displayed-year 19))
									(- (/ (* 3 century) 4))
									(/ (+ 5 (* 8 century)) 25)
									(* 30 century))
								 30))
			   (adjusted-epact (if (or (= shifted-epact 0)
									   (and (= shifted-epact 1)
											(< 10 (% displayed-year 19))))
								   (1+ shifted-epact)
								 shifted-epact))
			   (paschal-moon (- (calendar-absolute-from-gregorian
								 (list 4 19 displayed-year))
								adjusted-epact))
			   (easter (calendar-dayname-on-or-before 0 (+ paschal-moon 7))))
		  (filter-visible-calendar-holidays
		   (mapcar
			(lambda (l)
			  (list (calendar-gregorian-from-absolute (+ easter (car l)))
					(nth 1 l)))
			'(
			  (-52 "Unsinniger Donnerstag")
			  (-48 "Rosenmontag")
			  (-47 "Faschingsdienstag")
			  (-46 "Aschermittwoch")
			  ( -3 "Gründonnerstag")
			  ( -2 "Karfreitag")
			  (  0 "Ostersonntag")
			  ( +1 "Ostermontag")
			  (+39 "Christi Himmelfahrt")
			  (+49 "Pfingstsonntag")
			  (+50 "Pfingstmontag")
			  (+60 "Fronleichnam")))))
		(holiday-fixed 8 15 "Mariä Himmelfahrt")
		(holiday-fixed 11 1 "Allerheiligen")
		(holiday-float 11 3 1 "Buß- und Bettag" 16)
		(holiday-float 11 0 1 "Totensonntag" 20)))

(setq calendar-holidays
      (append general-holidays local-holidays other-holidays christian-holidays solar-holidays)
	  )
(setq local-holidays christian-holidays)

;;; **************
;;; cal-tex is a package for creating TeX-files from calendar
(cond ((locate-library "cal-tex")
       (require 'cal-tex)
       (setq cal-tex-24 t)
       (setq cal-tex-buffer 
			 (expand-file-name "~/docs/tex/calender.tex"))))

;;; **************
;;; The diary settings - also needed for the appointments
(setq diary-file (expand-file-name "~/Dokumente/Planer/diary"))
(setq diary-date-forms
      '((day "/" month "[^/0-9]")
		(day "/" month "/" year "[^0-9]")
		(backup day " *" monthname "\\W+\\<[^*0-9]")
		(day " *" monthname " *" year "[^0-9]")
		(dayname "\\W")))
(add-hook 'list-diary-entries-hook 'sort-diary-entries)
(setq mark-diary-entries-in-calendar t)

;;; **************
;;; Would you like to be notified of appointments ?
(require 'time)
(require 'appt)
(display-time)                 ;; <--- yes, this is necessary !
(add-hook 'display-time-hook
		  (function (lambda ()
					  ;; but, hey we can still get rid of the time ..
l					  (setq display-time-string "")))) 

(if (not (fboundp 'appt-initialize))
	(defun appt-initialize ()
	  "Dummy for appointments on FSF Emacs."))
(appt-initialize)

(setq appt-display-mode-line nil)
(add-hook 'diary-hook 'appt-make-list)
(defun diary-write-file-update-appt ()
  "Add new diary entries to appt. To be called when the diary buffer is saved.

  Always returns nil, so it can be hooked into write-file-hook."
  (if (eql (expand-file-name buffer-file-name)
		   (expand-file-name diary-file))
      (appt-initialize))
  nil)

(add-hook 'write-file-hooks 'diary-write-file-update-appt)
										; check appointments with a key ...
(add-hook 'calendar-load-hook
		  '(lambda ()
			 (define-key calendar-mode-map "l" 
			   '(function
				 (lambda ()
				   (appt-initialize))))))

(setq view-diary-entries-initially nil)


(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
