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
(add-to-list 'load-path "~/dev/tools/qichat-mode")
(require 'qichat-mode)

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

;; ido-mode
(ido-vertical-mode 1)

(defun badger-ido ()
  (interactive)
  (custom-set-faces
   '(ido-subdir ((t (:foreground "#8AC6F2")))) ;; Face used by ido for highlighting subdirs in the alternatives.
   '(ido-first-match ((t (:foreground "#84C452")))) ;; Face used by ido for highlighting first match.
   '(ido-only-match ((t (:foreground "#E2434C")))) ;; Face used by ido for highlighting only match.
   '(ido-indicator ((t (:foreground "#656868")))) ;; Face used by ido for highlighting its indicators (don't actually use this)
   '(ido-incomplete-regexp ((t (:foreground "#656868"))))))

(defun mccarthy-ido ()
  (interactive)
  (custom-set-faces
   '(ido-subdir ((t (:foreground "#5b93fc")))) ;; Face used by ido for highlighting subdirs in the alternatives.
   '(ido-first-match ((t (:foreground "#2c5115")))) ;; Face used by ido for highlighting first match.
   '(ido-only-match ((t (:foreground "#D14")))) ;; Face used by ido for highlighting only match.
   '(ido-indicator ((t (:foreground "#555")))) ;; Face used by ido for highlighting its indicators (don't actually use this)
   '(ido-incomplete-regexp ((t (:foreground "#555"))))))

;; Autofill
;; (auto-fill-mode -1)
;; (remove-hook 'text-mode-hook #'turn-on-auto-fill) 

;; Fonts
(set-face-attribute 'default nil :font "Source Code Pro-10")

(require 'indent-guide)
(setq indent-guide-char "|")
(indent-guide-global-mode)

;; Python Development
(add-hook 'python-mode-hook (lambda ()
                              (elpy-enable)
                              (elpy-mode 1)))

(add-hook 'elpy-mode-hook (lambda ()
                            (subword-mode 1) ;; camelCase words
                            (linum-mode 1)   ;; line numbering
                            (company-mode 1) ;; auto-completion
                            (rainbow-delimiters-mode 1) ;; colored matching parens
                            (elpy-use-ipython) 
                            ;;(fci-mode 1) ;; fill-column-indicator
                            (highlight-indentation-mode -1) ;; so ugly
                            (auto-fill-mode -1)))
(setq jedi:complete-on-dot t)
(setq-default python-indent-guess-indent-offset nil)
(setq-default python-indent-offset 4)

;; set the PYTHONPATH to be what the shell has
(let ((path-from-shell (shell-command-to-string "echo $PYTHONPATH")))
  (setenv "PYTHONPATH" (mapconcat 'identity (split-string path-from-shell) ":")))

;; Smart-mode-line related
(sml/setup)
(setq sml/mule-info nil)
(setq sml/numbers-separator "")
(setq sml/show-remote nil)
(setq sml/modified-char " x ")

;; Org-Mode
(setq org-src-fontify-natively t)
(setq org-html-doctype "html5")
(setq org-html-html5-fancy t)
(setq org-html-postamble nil)

;; Lisp Mode
(dolist (lisp-mode '(scheme emacs-lisp lisp clojure hy))
  (add-hook (intern (concat (symbol-name lisp-mode) "-mode-hook"))
            (lambda ()
              (paredit-mode 1)
              (rainbow-delimiters-mode 1))))

;; Theme Changer
(setq curr-theme nil)

(defun cycle-my-theme ()
  "Cycle through a list of themes, my-themes"
  (interactive)
  (when curr-theme
    (disable-theme curr-theme)
    (setq my-themes (append my-themes (list curr-theme))))
  (setq curr-theme (pop my-themes))
  ;;(message "%s" curr-theme)
  (load-theme curr-theme t)
  (cond ((eq curr-theme 'badger) (badger-ido))
        ((eq curr-theme 'mccarthy) (progn 
                                     (sml/apply-theme 'dark nil t) 
                                     (mccarthy-ido)))))

(global-set-key [(f9)] 'cycle-my-theme)

;; Cycle theme list
(setq my-themes '(badger mccarthy))
(cycle-my-theme)
