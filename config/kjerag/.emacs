
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/lisp")

(require 'emacs-modular-configuration)
;; after changing emacs config files in "~/.emacs.d/config" run "emc-merge-config-files"

(load "~/.emacs.d/config" t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-babel-load-languages (quote ((ditaa . t))))
 '(org-structure-template-alist
   (quote
    (("n" "#+BEGIN_NOTES
?
#+END_NOTES" "")
     ("s" "#+BEGIN_SRC ?

#+END_SRC" "<src lang=\"?\">

</src>")
     ("e" "#+BEGIN_EXAMPLE
?
#+END_EXAMPLE" "<example>
?
</example>")
     ("q" "#+BEGIN_QUOTE
?
#+END_QUOTE" "<quote>
?
</quote>")
     ("v" "#+BEGIN_VERSE
?
#+END_VERSE" "<verse>
?
</verse>")
     ("V" "#+BEGIN_VERBATIM
?
#+END_VERBATIM" "<verbatim>
?
</verbatim>")
     ("c" "#+BEGIN_CENTER
?
#+END_CENTER" "<center>
?
</center>")
     ("l" "#+BEGIN_LaTeX
?
#+END_LaTeX" "<literal style=\"latex\">
?
</literal>")
     ("L" "#+LaTeX: " "<literal style=\"latex\">?</literal>")
     ("h" "#+BEGIN_HTML
?
#+END_HTML" "<literal style=\"html\">
?
</literal>")
     ("H" "#+HTML: " "<literal style=\"html\">?</literal>")
     ("a" "#+BEGIN_ASCII
?
#+END_ASCII" "")
     ("A" "#+ASCII: " "")
     ("i" "#+INDEX: ?" "#+INDEX: ?")
     ("I" "#+INCLUDE: %file ?" "<include file=%file markup=\"?\">"))))
 '(safe-local-variable-values (quote ((org-image-actual-width . 1200)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
