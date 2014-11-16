;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; UI Behaviour
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(mwheel-install)
(setq inhibit-startup-message t)
(tool-bar-mode -1)
(add-to-list 'default-frame-alist '(menu-bar-lines . 1))
(add-to-list 'default-frame-alist '(tool-bar-lines . 0))
(setq scroll-conservatively 10000)
(setq scroll-preserve-screen-position nil)
(setq history-length 500)
(defalias 'yes-or-no-p 'y-or-n-p)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Global settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key (kbd "C-c g") 'goto-line)
(global-set-key [f6] 'shell)

(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)
(global-auto-revert-mode 1)
(global-whitespace-mode t)

;; Line wrapping
(setq fill-column 120)
(global-visual-line-mode t)

;; make scripts executable after saving
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)
