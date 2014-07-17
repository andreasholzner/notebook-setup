(add-to-list 'load-path "~/.emacs.d")

(require 'emacs-modular-configuration)
;; after changing emacs config files in "~/.emacs.d/config" run "emc-merge-config-files"

(load "~/.emacs.d/config" t)
