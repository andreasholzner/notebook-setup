;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; my .emacs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; packages, library paths
(add-to-list 'load-path "~/.emacs.d")

(require 'package)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(package-initialize)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; UI Behaviour
(mwheel-install)
(setq inhibit-startup-message t)
(tool-bar-mode -1)
(setq scroll-conservatively 10000)
(setq scroll-preserve-screen-position nil)
(setq history-length 500)
(add-to-list 'default-frame-alist '(height . 70))
(add-to-list 'default-frame-alist '(width . 165))
(add-to-list 'default-frame-alist '(font . "Ubuntu Mono 12"))
(defalias 'yes-or-no-p 'y-or-n-p)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Global settings
(global-set-key (kbd "C-c g") 'goto-line)
(global-set-key [f6] 'shell)
;; C-x C-c should no longer kill emacs as we run emacs daemon before fvwm session
;; (global-set-key (kbd "C-x C-c") 'save-buffers-kill-emacs) ;; make C-x C-c kill emacs
(global-font-lock-mode t)
(global-auto-revert-mode 1)
(global-whitespace-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Version Control
;(add-hook 'magit-mode-hook 'magit-load-config-extension)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; JavaScript
(setq-default js2-show-parse-errors nil)

(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

(add-hook 'js2-mode-hook (lambda ()
                           (flycheck-select-checker 'javascript-jshint-reporter)
                           (flycheck-mode)
                           (ac-js2-mode)
                           (auto-highlight-symbol-mode)
                           ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Perl
(defalias 'perl-mode 'cperl-mode)
(add-hook 'cperl-mode-hook
          '(lambda ()
             (font-lock-mode t)
             (transient-mark-mode t)
             (show-paren-mode t)
             (hs-minor-mode t)
             ;; (cperl-set-style "PerlStyle")
             (setq cperl-hairy t)
             (setq cperl-indent-level 4)
             (setq cperl-close-paren-offset -4)
             (setq cperl-continued-statement-offset 4)
             (setq cperl-extra-newline-before-brace nil)
             (setq cperl-indent-parens-as-block t)
             (setq cperl-electric-linefeed t)
             ;; (local-set-key (kbd "C-h f") 'cperl-perldoc)
             (flycheck-mode)
             )
          )
(add-to-list 'auto-mode-alist '("\\.pl\\'" . cperl-mode))
(add-to-list 'auto-mode-alist '("\\.pm\\'" . cperl-mode))
(add-to-list 'auto-mode-alist '("\\.t\\'" . cperl-mode))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Emacs-Lisp
(add-hook 'emacs-list-mode-hook
          (lambda ()
            (transient-mark-mode t)
            (show-paren-mode t)
            (hs-minor-mode t)
            )
          )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Shell Mode
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(setq explicit-shell-file-name "bash")
(setq explicit-bash-args '("-c" "export EMACS=; stty echo; bash"))
(setq comint-process-echoes t)
(require 'readline-complete)
;; (add-to-list 'ac-modes 'shell-mode)
;; (add-hook 'shell-mode-hook 'ac-rlc-setup-sources)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Auto Highlight Mode
(require 'auto-highlight-symbol)
(setq ahs-default-range 'ahs-range-whole-buffer)
(setq ahs-idle-interval 0.2)
(setq ahs-case-fold-search nil)
(global-auto-highlight-symbol-mode t)
(setq auto-highlight-symbol-mode-map
      (let ((map (make-sparse-keymap)))
        ;; (define-key map (kbd "M-<left>"    ) 'ahs-backward            )
        ;; (define-key map (kbd "M-<right>"   ) 'ahs-forward             )
        (define-key map (kbd "M-P"   ) 'ahs-backward            )
        (define-key map (kbd "M-N"   ) 'ahs-forward             )
        (define-key map (kbd "M-S-<left>"  ) 'ahs-backward-definition )
        (define-key map (kbd "M-S-<right>" ) 'ahs-forward-definition  )
        (define-key map (kbd "M--"       ) 'ahs-back-to-start       )
        (define-key map (kbd "C-x C-'"   ) 'ahs-change-range        )
        (define-key map (kbd "C-x C-a"   ) 'ahs-edit-mode           )
        map))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; WhiteSpace
(require 'whitespace)
(setq-default tab-width 4)
(setq-default c-basic-offset 4)
(setq nxml-outline-child-indent 4)
(setq nxml-child-indent 4)
(setq require-final-newline 't)

(setq whitespace-line-column 120)
(setq-default indent-tabs-mode nil)
(setq whitespace-style '(tabs tab-mark trailing))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Flycheck checker
(require 'flycheck)

(flycheck-define-checker javascript-jshint-reporter
			 "A JavaScript syntax and style chekcer based on JSLint Reporter.

See URL 'https://github.com/FND/jslint-reporter'."
			 :command ("~/.emacs.d/jslint-reporter/jslint-reporter" source)
			 :error-patterns ((error line-start (1+ nonl) ":" line ":" column ":" (message) line-end))
			 :modes (js-mode js2-mode js2-mode javascript-mode))
