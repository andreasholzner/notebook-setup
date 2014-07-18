;;; readline-complete-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (company-readline ac-rlc-prefix-shell-dispatcher)
;;;;;;  "readline-complete" "readline-complete.el" (21300 51456 551064
;;;;;;  894000))
;;; Generated autoloads from readline-complete.el

(autoload 'ac-rlc-prefix-shell-dispatcher "readline-complete" "\


\(fn)" nil nil)

(eval-after-load 'auto-complete `(ac-define-source shell '((candidates . rlc-candidates) (prefix . ac-rlc-prefix-shell-dispatcher) (requires . 0))))

(autoload 'company-readline "readline-complete" "\
`company-mode' back-end using `readline-complete'.

\(fn COMMAND &optional ARG &rest IGNORE)" t nil)

;;;***

;;;### (autoloads nil nil ("readline-complete-pkg.el") (21300 51456
;;;;;;  580398 234000))

;;;***

(provide 'readline-complete-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; readline-complete-autoloads.el ends here
