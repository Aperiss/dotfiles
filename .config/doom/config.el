;; [[file:config.org::*Personal Information][Personal Information:1]]
(setq confirm-kill-emacs nil)
(setq user-full-name "Antonio Peris Sanchez"
      user-mail-address "perissanchezantonio@gmail.com")
;; Personal Information:1 ends here

;; [[file:config.org::*Font][Font:1]]
(setq doom-font (font-spec :family "Terminess Nerd Font Mono" :size 14)
      doom-variable-pitch-font (font-spec :family "Terminess Nerd Font Mono" :size 14)
      doom-italic-font (font-spec :family "Terminess Nerd Font Mono" :size 14 :slant 'italic))
;; Font:1 ends here

;; [[file:config.org::*Theme][Theme:1]]
(setq doom-theme 'catppuccin)
(setq catppuccin-flavor 'mocha)
(load-theme 'catppuccin t)
;; Theme:1 ends here

;; [[file:config.org::*Line Numbers][Line Numbers:1]]
(setq display-line-numbers-type t)
;; Line Numbers:1 ends here

;; [[file:config.org::*Scroll Offset][Scroll Offset:1]]
(setq scroll-margin 10                  ; 10 lines above/below cursor
      scroll-conservatively 101          ; Scroll smoothly
      scroll-preserve-screen-position t  ; Keep cursor position when scrolling
      hscroll-margin 10                  ; 10 columns left/right of cursor
      hscroll-step 1)                    ; Smooth horizontal scrolling
;; Scroll Offset:1 ends here

;; [[file:config.org::*Window Splits][Window Splits:1]]
(map! :leader
      :prefix "w"
      :desc "Split window right" "%" #'evil-window-vsplit
      :desc "Split window below" "\"" #'evil-window-split
      :desc "Kill window" "k" #'evil-window-delete
      :desc "Kill window" "x" #'evil-window-delete)
;; Window Splits:1 ends here

;; [[file:config.org::*Motion and Scrolling][Motion and Scrolling:1]]
;; Center cursor after scrolling
(map! :n "C-d" (cmd! (evil-scroll-down 0) (evil-scroll-line-to-center (line-number-at-pos)))
      :n "C-u" (cmd! (evil-scroll-up 0) (evil-scroll-line-to-center (line-number-at-pos))))

;; Center cursor after search
(map! :n "n" (cmd! (evil-search-next) (evil-scroll-line-to-center (line-number-at-pos)))
      :n "N" (cmd! (evil-search-previous) (evil-scroll-line-to-center (line-number-at-pos))))

;; Center cursor after jumping to changes
(map! :n "g," (cmd! (evil-goto-last-change) (evil-scroll-line-to-center (line-number-at-pos)))
      :n "g;" (cmd! (evil-goto-last-change-reverse) (evil-scroll-line-to-center (line-number-at-pos))))
;; Motion and Scrolling:1 ends here

;; [[file:config.org::*Editing][Editing:1]]
;; Insert blank lines without entering insert mode
(map! :n "]<SPC>" (cmd! (evil-open-below 1) (forward-line -1))
      :n "[<SPC>" (cmd! (evil-open-above 1) (forward-line 1)))

;; Resize windows with Shift + arrow keys
(map! :n "S-<up>"    (cmd! (evil-window-increase-height 2))
      :n "S-<down>"  (cmd! (evil-window-decrease-height 2))
      :n "S-<right>" (cmd! (evil-window-increase-width 2))
      :n "S-<left>"  (cmd! (evil-window-decrease-width 2)))
;; Editing:1 ends here

;; [[file:config.org::*Toggles][Toggles:1]]
;; Toggle whitespace visualization
(defun my/toggle-whitespace ()
  "Toggle whitespace visualization."
  (interactive)
  (if whitespace-mode
      (progn
        (whitespace-mode -1)
        (message "Whitespace visualization: OFF"))
    (progn
      (setq-local whitespace-style '(face tabs spaces trailing space-before-tab
                                     newline indentation empty space-after-tab
                                     space-mark tab-mark newline-mark))
      (whitespace-mode 1)
      (message "Whitespace visualization: ON"))))

;; Keybinding for whitespace toggle
(map! :leader
      :prefix "t"
      :desc "Toggle whitespace" "w" #'my/toggle-whitespace)
;; Toggles:1 ends here

;; [[file:config.org::*Org Directory][Org Directory:1]]
(setq org-directory "~/Org/org/")
(add-hook 'org-mode-hook #'hl-todo-mode)
;; Org Directory:1 ends here

;; [[file:config.org::*Org Roam][Org Roam:1]]
(use-package! org-roam
  :after org
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/Org/org-roam")
  :config
  (org-roam-db-autosync-enable))
;; Org Roam:1 ends here

;; [[file:config.org::*Org Headings][Org Headings:1]]
(custom-theme-set-faces!
  'doom-one
  '(org-level-8 :inherit outline-3 :height 1.0)
  '(org-level-7 :inherit outline-3 :height 1.0)
  '(org-level-6 :inherit outline-3 :height 1.1)
  '(org-level-5 :inherit outline-3 :height 1.2)
  '(org-level-4 :inherit outline-3 :height 1.3)
  '(org-level-3 :inherit outline-3 :height 1.4)
  '(org-level-2 :inherit outline-3 :height 1.5)
  '(org-level-1 :inherit outline-3 :height 1.6)
  '(org-document-title :height 2.0 :bold t :underline nil))
;; Org Headings:1 ends here

;; [[file:config.org::*Environment Setup][Environment Setup:1]]
;; Add custom paths to exec-path and PATH
(let ((my-paths (mapcar #'expand-file-name
                       '("~/go/bin"
                         "~/Library/Python/3.9/bin"
                         "/opt/homebrew/bin"
                         "/opt/homebrew/Cellar/llvm/21.1.3/bin"))))
  (dolist (path my-paths)
    (add-to-list 'exec-path path))
  (setenv "PATH" (concat (string-join my-paths ":") ":" (getenv "PATH"))))
;; Environment Setup:1 ends here

;; [[file:config.org::*LSP Configuration][LSP Configuration:1]]
(after! lsp-mode
  (setq lsp-rust-analyzer-cargo-watch-command "clippy"
        lsp-rust-analyzer-check-on-save-command "clippy"

        ;; Inlay hints
        lsp-rust-analyzer-server-display-inlay-hints t
        lsp-rust-analyzer-display-lifetime-elision-hints-enable "skip_trivial"
        lsp-rust-analyzer-display-chaining-hints t
        lsp-rust-analyzer-display-lifetime-elision-hints-use-parameter-names nil
        lsp-rust-analyzer-display-closure-return-type-hints t
        lsp-rust-analyzer-display-parameter-hints nil
        lsp-rust-analyzer-display-reborrow-hints nil

        ;; Cargo features
        lsp-rust-analyzer-cargo-load-out-dirs-from-check t
        lsp-rust-analyzer-cargo-all-targets t
        lsp-rust-analyzer-proc-macro-enable t

        ;; Import settings
        lsp-rust-analyzer-import-granularity "module"
        lsp-rust-analyzer-import-prefix "by-self"

        ;; Disable mutable variable underlining
        lsp-rust-analyzer-highlighting-mutable-underline nil))
;; LSP Configuration:1 ends here

;; [[file:config.org::*LSP Configuration][LSP Configuration:1]]
(after! lsp-mode
  (setq lsp-clients-clangd-args '("-j=4"
                                  "--background-index"
                                  "--clang-tidy"
                                  "--completion-style=detailed"
                                  "--header-insertion=never"
                                  "--header-insertion-decorators=0"
                                  "--pch-storage=memory"
                                  "--enable-config"
                                  "--function-arg-placeholders"
                                  "--all-scopes-completion"
                                  "--cross-file-rename")))

;; Enable inlay hints for C++ (if using lsp-mode with inlay hint support)
(after! lsp-mode
  (setq lsp-inlay-hint-enable t))
;; LSP Configuration:1 ends here

;; [[file:config.org::*LSP Configuration][LSP Configuration:1]]
(after! lsp-mode
  (add-to-list 'lsp-language-id-configuration '(zig-mode . "zig"))
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection "zls")
    :major-modes '(zig-mode)
    :server-id 'zls))

  ;; ZLS-specific settings
  (setq lsp-zig-zls-executable "zls"
        lsp-semantic-tokens-enable t))

;; Enable inlay hints for Zig if available
(after! zig-mode
  (add-hook 'zig-mode-hook #'lsp-inlay-hints-mode))
;; LSP Configuration:1 ends here

;; [[file:config.org::*LSP Configuration][LSP Configuration:1]]
(after! lsp-mode
  (setq lsp-go-analyses '((nilness . t)
                          (unusedparams . t)
                          (unusedwrite . t)
                          (useany . t))
        lsp-go-codelenses '((generate . t)
                            (test . t)
                            (tidy . t)
                            (upgrade_dependency . t)
                            (vendor . t))
        lsp-go-use-gofumpt t
        lsp-go-hints '((assignVariableTypes . t)
                       (compositeLiteralFields . t)
                       (compositeLiteralTypes . t)
                       (constantValues . t)
                       (functionTypeParameters . t)
                       (parameterNames . t)
                       (rangeVariableTypes . t))))
;; LSP Configuration:1 ends here

;; [[file:config.org::*LSP Configuration][LSP Configuration:1]]
(after! lsp-mode
  ;; Load Pyright LSP client
  (require 'lsp-pyright)

  ;; Pyright configuration - type checking and completions
  (setq lsp-pyright-typechecking-mode "basic"
        lsp-pyright-disable-organize-imports nil

        ;; Auto-import and completions
        lsp-pyright-auto-import-completions t
        lsp-pyright-use-library-code-for-types t

        ;; Diagnostics
        lsp-pyright-diagnostic-mode "workspace"

        ;; Virtual environment support
        lsp-pyright-venv-path (expand-file-name "~/.virtualenvs")))

;; Python-specific: enable inlay hints
(after! python-mode
  (add-hook 'python-mode-hook #'lsp-inlay-hints-mode))
;; LSP Configuration:1 ends here

;; [[file:config.org::*LSP Configuration][LSP Configuration:1]]
(after! lsp-mode
  (setq lsp-lua-hint-enable t
        lsp-lua-hint-set-type t
        lsp-lua-hint-param-type t

        ;; Runtime configuration
        lsp-lua-runtime-version "LuaJIT"

        ;; Completion
        lsp-lua-completion-call-snippet "Both"
        lsp-lua-completion-keyword-snippet "Both"

        ;; Diagnostics
        lsp-lua-diagnostics-enable t
        lsp-lua-diagnostics-globals '("vim")  ; If using Neovim Lua API

        ;; Semantic highlighting
        lsp-semantic-tokens-enable t))
;; LSP Configuration:1 ends here
