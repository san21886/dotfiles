;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Load path
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(let ((default-directory "~/.emacs.d/"))
      (normal-top-level-add-to-load-path '("."))
      (normal-top-level-add-subdirs-to-load-path))
(add-to-list 'load-path "/usr/share/emacs/site-lisp")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; USE THE POWERFUL VIM KEYBINDS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'evil)
(evil-mode 1)
(setq evil-auto-indent t)
(setq evil-shift-width 4)
(setq evil-regexp-search t)
(setq evil-want-C-i-jump t)
(setq evil-want-C-u-scroll t)

(require 'surround)
(global-surround-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Flymake
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'flymake)
(setq ispell-program-name "hunspell")
(setq ispell-dictionary "brasileiro")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Auto complete
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "/home/ivan/.emacs.d/ac-dict")
(ac-config-default)
(setq ac-auto-start t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Misc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Scroll 1 line per step
(setq scroll-step 1)

; Line and column numbering
(line-number-mode 1)
(column-number-mode 1)
(global-linum-mode 1)
(setq linum-format "%3d ")

; Set size used when formatting paragraphs
(setq-default fill-column 72)

; Turn syntax-highlight on
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)

; Interface
(tool-bar-mode -1)
(toggle-scroll-bar -1)
(menu-bar-mode -1)
(setq inhibit-startup-screen 1)
(setq initial-scratch-message nil)
; don't add newlines when cursor goes past the end of file
(setq next-line-add-newlines nil)

; Font
(set-face-attribute 'default nil :family "Terminus" :height 100)

; Colors
(require 'color-theme)
(color-theme-initialize)
(setq color-theme-is-global t)
(color-theme-solarized-dark)

; Whitespace
(setq-default show-trailing-whitespace t)
(setq-default indicate-empty-lines t)

; Line wrapping (truncate)
(setq default-truncate-lines t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Slime
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path "/usr/share/common-lisp/source/slime/")
(add-to-list 'load-path "/usr/share/emacs/site-lisp/slime")
(setq inferior-lisp-program "/usr/bin/sbcl")
(require 'slime-autoloads)
(slime-setup '(slime-fancy))

(add-hook 'slime-mode-hook
          (lambda ()
            (unless (slime-connected-p)
              (save-excursion (slime)))))

(global-set-key "\C-z" 'slime-selector)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Backup file configuration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq make-backup-files t)
(setq version-control nil)
(setq backup-directory-alist (quote ((".*" . "~/.emacs.d/backup"))))
(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; File type settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(which-function-mode)
(global-set-key (kbd "RET") 'newline-and-indent)
(setq standard-indent 4)
(setq-default indent-tabs-mode nil)

; Lisp
(add-hook 'lisp-mode-hook
          '(lambda ()
            (set (make-local-variable 'lisp-indent-function)
                 'common-lisp-indent-function)))

(font-lock-add-keywords 'emacs-lisp-mode
                        '(("\\<\\(add-hook\\)" 1 font-lock-builtin-face t)
                          ("\\<\\(set-hook\\)" 1 font-lock-builtin-face t)
                          ("\\<\\(add-to-list\\)" 1 font-lock-builtin-face t)))

; C
(add-hook 'c-mode-common-hook
          '(lambda () (c-toggle-auto-state 1)))

(setq c-default-style "linux"
      c-basic-offset 4)
(setq c-hanging-braces-alist '((class-open after)
                               (substatement-open after)
                               (topmost-intro after)))
(setq c-cleanup-list 'defun-close-semi)

; Haskell
(load "~/.emacs.d/haskellmode-emacs/haskell-site-file.el")
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(setq haskell-font-lock-symbols t)
(add-hook 'haskell-mode-hook 'turn-on-font-lock)

; Lua
(setq auto-mode-alist (cons '("\.lua$" . lua-mode) auto-mode-alist))
(autoload 'lua-mode "lua-mode" "Lua editing mode." t)

; Python
(autoload 'python-mode "python-mode.el" "Python mode." t)
(setq auto-mode-alist (append '(("/*.\.py$" . python-mode)) auto-mode-alist))

; Latex
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq TeX-save-query nil)
(setq TeX-PDF-mode t)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-buffer)
