;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; Pin org-mode to stable version to fix org-roam compatibility
;; See: https://github.com/org-roam/org-roam/issues/2361
(unpin! org-roam company-org-roam)
(package! org
  :pin "ca873f7")  ;; org 9.5.5 stable

;; Theme
(package! catppuccin-theme)

;; Python LSP
(package! lsp-pyright)

;; Org-roam UI - interactive graph in browser
(package! org-roam-ui)
