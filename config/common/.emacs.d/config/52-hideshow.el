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

