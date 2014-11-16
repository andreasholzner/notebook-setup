;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; JavaScript
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(setq-default js2-show-parse-errors nil)

(add-hook 'js2-mode-hook (lambda ()
                           (flycheck-select-checker 'javascript-jshint-reporter)
                           (flycheck-mode)
                           (ac-js2-mode)
                           (auto-highlight-symbol-mode)
                           ))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Flycheck checker
(require 'flycheck)

(flycheck-define-checker javascript-jshint-reporter
			 "A JavaScript syntax and style chekcer based on JSLint Reporter.

See URL 'https://github.com/FND/jslint-reporter'."
			 :command ("~/.emacs.d/jslint-reporter/jslint-reporter" source)
			 :error-patterns ((error line-start (1+ nonl) ":" line ":" column ":" (message) line-end))
			 :modes (js-mode js2-mode js2-mode javascript-mode))
