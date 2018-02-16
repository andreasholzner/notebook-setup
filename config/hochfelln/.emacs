(add-to-list 'load-path "~/.emacs.d")

(require 'emacs-modular-configuration)
;; after changing emacs config files in "~/.emacs.d/config" run "emc-merge-config-files"

(load "~/.emacs.d/config" t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files
   (quote
    ("~/Projekte/AOS/PAn/sync/aos.org" "~/Projekte/AOS/Telko 2016-11-11.org")))
 '(org-babel-load-languages (quote ((ditaa . t))))
 '(safe-local-variable-values (quote ((org-image-actual-width . 1200)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
