;; Tom Donahue
;; Emacs Init

;; Package manager
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("elpy" . "http://jorgenschaefer.github.io/packages/")))
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

;;NXHTML Mode
(load "~/.emacs.d/nxhtml/autostart")
(setq mumamo-background-colors nil)
;; Workaround the annoying mumamo warnings:
(when (and (>= emacs-major-version 24) 
           (>= emacs-minor-version 2))
  (eval-after-load "mumamo"
    '(setq mumamo-per-buffer-local-vars
           (delq 'buffer-file-name mumamo-per-buffer-local-vars)))
  (eval-after-load "bytecomp"
    '(add-to-list 'byte-compile-not-obsolete-vars
                  'font-lock-beginning-of-syntax-function)))
(setq warning-minimum-level :error)

;; Fonts
(set-face-attribute 'default nil :font "Source Code Pro-10")

;; Python Development
(package-initialize)
(elpy-enable)
(add-hook 'python-mode-hook (lambda ()
                               (elpy-enable)
                               (delq 'flymake-mode elpy-default-minor-modes)
                               (elpy-mode)
                               (auto-complete-mode 1)
                               (rainbow-delimiters-mode 1)
                               (elpy-clean-modeline)
                               (elpy-use-ipython)
                               (setq flymake-start-syntax-check-on-newline nil)
                               (setq flymake-no-changes-timeout 60)))


;; Smart-mode-line related
(sml/setup)
(setq sml/mule-info nil)
(setq sml/numbers-separator "")
(setq sml/show-remote nil)
(setq sml/modified-char " x ")
