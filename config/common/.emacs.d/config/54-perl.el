;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Perl
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
             (local-set-key (kbd "C-h f") 'cperl-perldoc)
             (flycheck-mode)
             )
          )

(add-to-list 'auto-mode-alist '("\\.pl\\'" . cperl-mode))
(add-to-list 'auto-mode-alist '("\\.pm\\'" . cperl-mode))
(add-to-list 'auto-mode-alist '("\\.t\\'" . cperl-mode))

