;; [[file:config.org::*Basic Configuration][Basic Configuration:1]]
(setq confirm-kill-emacs nil)

(setq user-full-name "Antonio Peris Sanchez"
      user-mail-address "perissanchezantonio@gmail.com")

;; Don't show dashboard when starting client from daemon
(setq initial-buffer-choice nil)
;; Basic Configuration:1 ends here

;; [[file:config.org::*Font][Font:1]]
;; Main font
(setq doom-font (font-spec :family "Terminess Nerd Font Mono" :size 12.0))

;; Chinese font for CJK characters
(add-hook 'doom-init-ui-hook
          (lambda ()
            (dolist (charset '(kana han cjk-misc bopomofo))
              (set-fontset-font t charset (font-spec :family "Noto Sans SC" :size 12.0)))))
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

(map! :leader
      :prefix "t"
      :desc "Toggle whitespace" "w" #'my/toggle-whitespace)
;; Toggles:1 ends here

;; [[file:config.org::*Environment Setup][Environment Setup:1]]
;; Sync exec-path from PATH environment variable
;; This ensures Emacs can find all executables without hardcoding paths
(setq exec-path (append (parse-colon-path (getenv "PATH")) exec-path))
;; Environment Setup:1 ends here

;; [[file:config.org::*Debugger Setup][Debugger Setup:1]]
;; Load dape and enable global breakpoint mode
(use-package! dape
  :config
  ;; Enable global breakpoint mode so we can set breakpoints anytime
  (dape-breakpoint-global-mode +1))
;; Debugger Setup:1 ends here

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

        ;; Semantic highlighting - disable mutable variable underlining
        lsp-rust-analyzer-highlighting-mutable-underline nil
        lsp-rust-analyzer-highlighting-mutable-emphasis "none"))
;; LSP Configuration:1 ends here

;; [[file:config.org::*Debugger Configuration][Debugger Configuration:1]]
(after! dape
  (add-to-list 'dape-configs
               `(rust-lldb
                 modes (rust-mode rust-ts-mode)
                 command ,(or (executable-find "lldb-dap") "lldb-dap")
                 command-args ()
                 fn (lambda (config)
                      (plist-put config :program
                                (let ((root (dape--guess-root config)))
                                  (read-file-name "Rust binary to debug: "
                                                (file-name-concat root "target/debug/"))))
                      config)
                 :type "lldb"
                 :request "launch"
                 :cwd dape-cwd-fn
                 :program ""
                 :args []
                 :stopOnEntry nil)))
;; Debugger Configuration:1 ends here

;; [[file:config.org::*LSP Configuration][LSP Configuration:1]]
(after! lsp-mode
  ;; Using BACKGROUND INDEXING for UE5 (necessary for complete symbol resolution)
  (setq lsp-clients-clangd-args '("-j=4"
                                  "--background-index"
                                  "--completion-style=detailed"
                                  "--header-insertion=never"
                                  "--pch-storage=disk"
                                  "--enable-config"
                                  "--all-scopes-completion"
                                  "--limit-results=100")))

;; Enable inlay hints for C++ (if using lsp-mode with inlay hint support)
(after! lsp-mode
  (setq lsp-inlay-hint-enable t))
;; LSP Configuration:1 ends here

;; [[file:config.org::*Debugger Configuration][Debugger Configuration:1]]
(after! dape
  (add-to-list 'dape-configs
               `(cpp-lldb
                 modes (c++-mode c++-ts-mode)
                 command ,(or (executable-find "lldb-dap") "lldb-dap")
                 command-args ()
                 fn (lambda (config)
                      (plist-put config :program
                                (read-file-name "C++ binary to debug: "
                                              (dape--guess-root config)))
                      config)
                 :type "lldb"
                 :request "launch"
                 :cwd dape-cwd-fn
                 :program ""
                 :args []
                 :stopOnEntry nil)))
;; Debugger Configuration:1 ends here

;; [[file:config.org::*Debugger Configuration][Debugger Configuration:1]]
(after! dape
  (add-to-list 'dape-configs
               `(c-lldb
                 modes (c-mode c-ts-mode)
                 command ,(or (executable-find "lldb-dap") "lldb-dap")
                 command-args ()
                 fn (lambda (config)
                      (plist-put config :program
                                (read-file-name "C binary to debug: "
                                              (dape--guess-root config)))
                      config)
                 :type "lldb"
                 :request "launch"
                 :cwd dape-cwd-fn
                 :program ""
                 :args []
                 :stopOnEntry nil)))
;; Debugger Configuration:1 ends here

;; [[file:config.org::*LSP Configuration][LSP Configuration:1]]
(after! lsp-zig
  ;; ZLS will be found automatically via PATH
  (setq lsp-zig-enable-inlay-hints t
        lsp-zig-enable-autofix t))

;; Enable inlay hints for Zig (LSP is already enabled by +lsp module)
(after! zig-mode
  (add-hook 'zig-mode-hook #'lsp-inlay-hints-mode))
;; LSP Configuration:1 ends here

;; [[file:config.org::*Debugger Configuration][Debugger Configuration:1]]
(after! dape
  (add-to-list 'dape-configs
               `(zig-lldb
                 modes (zig-mode zig-ts-mode)
                 command ,(or (executable-find "lldb-dap") "lldb-dap")
                 command-args ()
                 fn (lambda (config)
                      (plist-put config :program
                                (let ((root (dape--guess-root config)))
                                  (read-file-name "Zig binary to debug: "
                                                (file-name-concat root "zig-out/bin/"))))
                      config)
                 :type "lldb"
                 :request "launch"
                 :cwd dape-cwd-fn
                 :program ""
                 :args []
                 :stopOnEntry nil)))
;; Debugger Configuration:1 ends here

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

;; [[file:config.org::*Debugger Configuration][Debugger Configuration:1]]
(after! dape
  ;; 1. Debug mode: Compile and debug source code
  (add-to-list 'dape-configs
               `(dlv-debug
                 modes (go-mode go-ts-mode)
                 ensure dape-ensure-command
                 command "dlv"
                 command-args ("dap" "--listen" "127.0.0.1::autoport")
                 command-insert-stderr t
                 port :autoport
                 fn (lambda (config)
                      (let* ((root (dape--guess-root config))
                             (default-dir (if (file-exists-p (concat root "cmd/"))
                                            (concat root "cmd/")
                                            root))
                             (selected-path (read-directory-name "Go package to debug: " default-dir)))
                        (plist-put config :program
                                  (expand-file-name selected-path)))
                      config)
                 :type "go"
                 :request "launch"
                 :mode "debug"
                 :cwd dape-cwd-fn
                 :program ""
                 :args []))

  ;; 2. Exec mode: Debug pre-compiled binary
  (add-to-list 'dape-configs
               `(dlv-exec
                 modes (go-mode go-ts-mode)
                 ensure dape-ensure-command
                 command "dlv"
                 command-args ("dap" "--listen" "127.0.0.1::autoport")
                 command-insert-stderr t
                 port :autoport
                 fn (lambda (config)
                      (let* ((root (dape--guess-root config))
                             (default-dir (if (file-exists-p (concat root "build/"))
                                            (concat root "build/")
                                            root))
                             (selected-binary (read-file-name "Go binary to debug: " default-dir)))
                        (plist-put config :program
                                  (expand-file-name selected-binary)))
                      config)
                 :type "go"
                 :request "launch"
                 :mode "exec"
                 :cwd dape-cwd-fn
                 :program ""
                 :args []))

  ;; 3. Test mode: Debug Go tests
  (add-to-list 'dape-configs
               `(dlv-test
                 modes (go-mode go-ts-mode)
                 ensure dape-ensure-command
                 command "dlv"
                 command-args ("dap" "--listen" "127.0.0.1::autoport")
                 command-insert-stderr t
                 port :autoport
                 fn (lambda (config)
                      (plist-put config :program
                                (file-name-directory (buffer-file-name)))
                      config)
                 :type "go"
                 :request "launch"
                 :mode "test"
                 :cwd dape-cwd-fn
                 :program ""
                 :args [])))
;; Debugger Configuration:1 ends here

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

;; [[file:config.org::*Debugger Configuration][Debugger Configuration:1]]
(after! dape
  (add-to-list 'dape-configs
               `(debugpy
                 modes (python-mode python-ts-mode)
                 ensure dape-ensure-command
                 command "python3"
                 command-args ("-m" "debugpy.adapter")
                 fn (lambda (config)
                      (let* ((current-dir (file-name-directory (buffer-file-name)))
                             (selected-file (read-file-name "Python file to run: " current-dir)))
                        (plist-put config :program (expand-file-name selected-file)))
                      config)
                 :request "launch"
                 :type "executable"
                 :cwd dape-cwd-fn
                 :program ""
                 :args [])))
;; Debugger Configuration:1 ends here

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
