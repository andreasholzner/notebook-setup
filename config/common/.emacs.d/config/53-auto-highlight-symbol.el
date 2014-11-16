;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Auto Highlight Mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'auto-highlight-symbol)
(setq ahs-default-range 'ahs-range-whole-buffer)
(setq ahs-idle-interval 0.2)
(setq ahs-case-fold-search nil)

(global-auto-highlight-symbol-mode t)
(global-set-key (kbd "M-P") 'ahs-backward)
(global-set-key (kbd "M-N") 'ahs-forward)

