;; Tom Donahue
;; Emacs Init

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (badger)))
 '(custom-safe-themes (quote ("3a727bdc09a7a141e58925258b6e873c65ccf393b2240c51553098ca93957723" "e068203104e27ac7eeff924521112bfcd953a655269a8da660ebc150c97d0db8" "4c1e0084a3559cf6f685340e86587c794d6a9a7f6a16069de2d95056b8425c1e" "6a37be365d1d95fad2f4d185e51928c789ef7a4ccf17e7ca13ad63a8bf5b922f" "756597b162f1be60a12dbd52bab71d40d6a2845a3e3c2584c6573ee9c332a66e" "dc46381844ec8fcf9607a319aa6b442244d8c7a734a2625dac6a1f63e34bc4a6" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Package manager
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
			 ("elpy" . "http://jorgenschaefer.github.io/packages/")))

(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

;; Add themes
(add-to-list 'custom-theme-load-path "~/dev/tools/badger-theme")
(add-to-list 'custom-theme-load-path "~/dev/tools/emacs-color-themes/themes")

;;QiChat Mode
;; (add-to-list 'load-path "~/dev/tools/qichat-mode")
;; (require 'qichat-mode)

;; Web-mode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[gj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))

;; Global Highlight Line Mode
(remove-hook 'coding-hook 'turn-on-hl-line-mode)
(remove-hook 'prog-mode-hook 'esk-turn-on-hl-line-mode)

;; Autofill
;; (auto-fill-mode -1)
;; (remove-hook 'text-mode-hook #'turn-on-auto-fill) 

;; Fonts
(set-face-attribute 'default nil :font "Source Code Pro-10")

;; Python Development
(setq python-check-command "flake8")
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

;; set the PYTHONPATH to be what the shell has
(let ((path-from-shell (shell-command-to-string "echo $PYTHONPATH")))
  (setenv "PYTHONPATH" (mapconcat 'identity (split-string path-from-shell) ":")))

;; Smart-mode-line related
(sml/setup)
(setq sml/mule-info nil)
(setq sml/numbers-separator "")
(setq sml/show-remote nil)
(setq sml/modified-char " x ")

;; Theme Changer
(setq curr-theme nil)

(defun enab-theme (theme)
  "Disable theme then load it, clearing out state of previous theme"
  (if curr-theme (disable-theme curr-theme))
  (setq curr-theme theme) 
  (load-theme theme t))

(defun cycle-my-theme ()
  "Cycle through a list of themes, my-themes"
  (interactive)
  (when curr-theme
    (disable-theme curr-theme)
    (setq my-themes (append my-themes (list curr-theme))))
  (setq curr-theme (pop my-themes))
  (load-theme curr-theme t))


(global-set-key [(f9)] 'cycle-my-theme)
(global-set-key [(f10)] (lambda () (interactive) (sml/apply-theme 'dark)))

;; Cycle theme list
(setq my-themes '(mccarthy badger))
(cycle-my-theme)
