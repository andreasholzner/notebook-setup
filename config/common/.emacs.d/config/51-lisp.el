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

