;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LaTex via AUCTeX
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'tex-site)
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)
(setq reftex-plug-into-AUCTeX t)
(setq reftex-enable-partial-scans t)
(setq reftex-save-parse-info t)
(setq reftex-use-multiple-selection-buffers t)
(setq reftex-use-external-file-finders t)
(setq reftex-external-file-finders
      '(("tex" . "kpsewhich -format=.tex %f")
              ("bib" . "kpsewhich -format=.bib %f")))
;; (setq reftex-label-alist
;; 	  '(("figure" ?f "fig:" "\\figref{%s}" caption nil)))
(setq reftex-fref-is-default t)
(setq bib-cite-use-reftex-view-crossref t)
(setq TeX-electric-sub-and-superscript t)
(add-hook 'LaTeX-mode-hook
		  '(lambda ()
			 (turn-on-reftex)
			 (LaTeX-math-mode t)
			 (TeX-fold-mode t)
			 (outline-minor-mode t)
			 )
		  )
;; ps4pdf ins Menü
(eval-after-load "tex"
  '(add-to-list 'TeX-command-list
                '("ps4pdf" "ps4pdf %s" TeX-run-command nil t :help "Run ps4pdf")))
;; WhizzyTeX
(add-hook 'whizzytex-mode-hook
          '(lambda ()
                                        ; use paragraph mode for the LaTeX class "beamer":
             (add-to-list 'whizzy-class-mode-alist '("beamer" . paragraph))
             (whizzy-default-bindings) ;keep default whizzytex-mode-hook
             )
          )
                                        ; slice on every frame while in paragraph mode:
(setq whizzy-paragraph-regexp "\n\\\\frame\\b[^{]*{")
                                        ;or slice also on sectionning:
;; (setq whizzy-paragraph-regexp "\\\\\\(\\(s\\(ubs\\(ub\\|\\)\\|\\)ection\\)\\|chapter\\|part\\|frame\\)\\b[^{]*{")

(setq LaTeX-math-list (quote ((39 "dagger" "nil" nil) (49 "shortuparrow" "Arrows" nil) (50 "shortdownarrow" "Arrows" nil) (57 "phantom" "nil" nil))))

