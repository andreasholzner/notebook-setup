;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Auto Highlight Mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

