;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; Pin org-mode to stable version to fix org-roam compatibility
;; See: https://github.com/org-roam/org-roam/issues/2361
(unpin! org-roam company-org-roam)
(package! org
  :pin "ca873f7")  ;; org 9.5.5 stable

;; Theme
(package! catppuccin-theme)

;; Disable solaire-mode - it remaps faces and causes font issues
(package! solaire-mode :disable t)

;; Python LSP
(package! lsp-pyright)

;; Org-roam UI - interactive graph in browser
(package! org-roam-ui)

;; Additional packages
(package! org-ql)                    ;; Advanced queries for filtering notes
(package! org-super-agenda)          ;; Group todos by tag
(package! org-transclusion)          ;; Embed note content in other notes

;; Prettier UI elements for org-mode
(package! org-superstar)             ;; Better heading bullets and TODO items
