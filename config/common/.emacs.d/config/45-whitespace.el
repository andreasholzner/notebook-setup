;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; WhiteSpace
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'whitespace)
(setq whitespace-line-column 120)
(setq-default indent-tabs-mode nil)
(setq whitespace-style '(tabs tab-mark trailing))

(setq-default tab-width 4)
(setq-default c-basic-offset 4)
(setq nxml-outline-child-indent 4)
(setq nxml-child-indent 4)
(setq require-final-newline 't)

;; if indent-tabs-mode is off, untabify before saving
(add-hook 'write-file-hooks 
          (lambda () (if (not indent-tabs-mode)
                         (untabify (point-min) (point-max)))
			nil ))

