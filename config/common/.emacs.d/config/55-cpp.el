;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; C++/C
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

