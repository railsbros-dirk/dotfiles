;;; init.el --- My emacs config
;;
;; Author: Dirk Breuer <mail@tfcl.de>
;; URL:    http://tfcl.de

;; This file is not part of GNU Emacs.

;;; Commentary:

;; This file is my humble approach to make Emacs work for me.


;;; License:

;; The MIT License (MIT)

;; Copyright (c) 2014 Dirk Breuer

;; Permission is hereby granted, free of charge, to any person obtaining a copy
;; of this software and associated documentation files (the "Software"), to deal
;; in the Software without restriction, including without limitation the rights
;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;; copies of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:

;; The above copyright notice and this permission notice shall be included in all
;; copies or substantial portions of the Software.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.

;;; Code:

(require 'cl)

(setq user-full-name "Dirk Breuer")

(add-to-list 'load-path (expand-file-name "modules" user-emacs-directory))

;; Configure packages
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("org" . "http://orgmode.org/elpa/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa-stable" . "http://melpa.milkbox.net/packages/")))

(package-initialize)

;; Installs a package
(defun require-package (package)
  (setq-default highlight-tabs t)
  "Install given PACKAGE."
  (unless (package-installed-p package)
    (unless (assoc package package-archive-contents)
      (package-refresh-contents))
    (package-install package)))

;; Color scheme
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'pinkiepie-dark t)

;; Basic packages
(require-package 'magit)
(require-package 'browse-kill-ring)
;; Move between windows with Shift-Arrows
(define-key input-decode-map "\e[1;2A" [S-up])
(define-key input-decode-map "\e[1;2B" [S-down])
(define-key input-decode-map "\e[1;2C" [S-right])
(define-key input-decode-map "\e[1;2D" [S-left])
(windmove-default-keybindings)
(require-package 'flycheck)
(require-package 'rainbow-mode)

;; Fix IDO
(require-package 'flx-ido)
(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)

;; Projectile
(require-package 'projectile)
(projectile-global-mode)

;; Helm
;; helm settings (TAB in helm window for actions over selected items,
;; C-SPC to select items)
(require-package 'helm)
(require 'helm-config)
(require-package 'helm-projectile)
(require-package 'helm-ag)
(defun do-in-root (f)
  (if (projectile-project-p)
      (funcall f (projectile-project-root))
      (error "You're not in project")))
(defun helm-do-ag-in-root ()
  (interactive)
  (do-in-root 'helm-do-ag))
(defun do-ag-in-root (string)
  (interactive (list (read-from-minibuffer "Search string: " (ag/dwim-at-point))))
  (do-in-root '(lambda (root) (ag/search string root))))

(require 'helm-misc)
(require 'helm-locate)
(setq helm-quick-update t
      helm-bookmark-show-location t
      helm-buffers-fuzzy-matching t)

(global-set-key (kbd "M-x") 'helm-M-x)

(defun helm-my-buffers ()
  (interactive)
  (require 'helm-files)
  (let ((helm-ff-transformer-show-only-basename nil))
  (helm-other-buffer '(helm-c-source-buffers-list
                       helm-c-source-elscreen
                       helm-c-source-occur
                       ;;                        helm-c-source-projectile-files-list
                       helm-c-source-ctags
                       helm-c-source-recentf
                       helm-c-source-locate)
                     "*helm-my-buffers*")))

(require 'init-evil)

;; Auto-indent settings based on file
(require-package 'dtrt-indent)
(dtrt-indent-mode 1)

;; Flycheck
(require-package 'flycheck)

;; enable on-the-fly syntax checking
(if (fboundp 'global-flycheck-mode)
    (global-flycheck-mode +1)
  (add-hook 'prog-mode-hook 'flycheck-mode))

;; Programming
(require-package 'guru-mode)
(require-package 'smartparens)
;; smart pairing for all
(require 'smartparens-config)
(setq sp-base-key-bindings 'paredit)
(setq sp-autoskip-closing-pair 'always)
(setq sp-hybrid-kill-entire-symbol nil)
(sp-use-paredit-bindings)

(smartparens-global-mode t)
(show-smartparens-global-mode +1)

;; enlist a more liberal guru
(setq guru-warn-only t)

;; Taken from Prelude
(defun custom-local-comment-auto-fill ()
  (set (make-local-variable 'comment-auto-fill-only-comments) t))

(defun custom-font-lock-comment-annotations ()
  "Highlight a bunch of well known comment annotations.

This functions should be added to the hooks of major modes for programming."
  (font-lock-add-keywords
   nil '(("\\<\\(\\(FIX\\(ME\\)?\\|TODO\\|OPTIMIZE\\|HACK\\|REFACTOR\\):\\)"
          1 font-lock-warning-face t))))

(defun custom-prog-mode-defaults ()
  "Default coding hook, useful with any programming language."
  (guru-mode +1)
  (flyspell-prog-mode)
  (smartparens-mode +1)
  (custom-font-lock-comment-annotations)
  (custom-local-comment-auto-fill))

(setq custom-prog-mode-hook 'custom-prog-mode-defaults)

(add-hook 'prog-mode-hook (lambda ()
                            (run-hooks 'custom-prog-mode-hook)))

;; Ruby config

;; Useful packages

(require-package 'ruby-tools)
(require-package 'inf-ruby)
(require-package 'yari)

;; We never want to edit Rubinius bytecode
(add-to-list 'completion-ignored-extensions ".rbc")

(define-key 'help-command (kbd "R") 'yari)

;; Again taken from prelude
(eval-after-load 'ruby-mode
  '(progn
     (defun custom-ruby-mode-defaults ()
       (inf-ruby-minor-mode +1)
       (ruby-tools-mode +1)
       ;; CamelCase aware editing operations
       (subword-mode +1))

     (setq customn-ruby-mode-hook 'custom-ruby-mode-defaults)

     (add-hook 'ruby-mode-hook (lambda ()
                                 (run-hooks 'custom-ruby-mode-hook)))))

;; Rake files are ruby, too, as are gemspecs, rackup files, and gemfiles.
(add-to-list 'auto-mode-alist '("\\.rake\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.gemspec\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("Guardfile\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("Capfile\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.thor\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rabl\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("Thorfile\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("Vagrantfile\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.jbuilder\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("Podfile\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.podspec\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("Puppetfile\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("Berksfile\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("Appraisals\\'" . ruby-mode))

;; SCSS Support
(require-package 'scss-mode)
(require-package 'sass-mode)
(add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode))

(setq-default scss-compile-at-save nil)

;; Markdown

(require-package 'markdown-mode)

;; markdown-mode doesn't have autoloads for the auto-mode-alist
;; so we add them manually if it's already installed
(when (package-installed-p 'markdown-mode)
  (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode)))

;; Writeroom aka Distraction free editing
(require-package 'writeroom-mode)

;; Misc configuration

;; store all backup and autosave files in the system tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; Nyan!
(require-package 'nyan-mode)
(nyan-mode)

;; Remember cursor position
(setq save-place-file "~/.emacs.d/saveplace")
(setq-default save-place t)
(require 'saveplace)

;; No TABS and 2 spaces (Ruby default)
(setq-default indent-tabs-mode nil)   ;; don't use tabs to indent
(setq-default tab-width 2)            ;; but maintain correct appearance

;; Indent on RET
(define-key global-map (kbd "RET") 'newline-and-indent)

;; Don't show scrollbars all the time
(scroll-bar-mode -1)

;; Clipboard integraion OS X
(defun copy-from-osx ()
  (shell-command-to-string "pbpaste"))

(defun paste-to-osx (text &optional push)
  (let ((process-connection-type nil))
    (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
      (process-send-string proc text)
      (process-send-eof proc))))

(setq interprogram-cut-function 'paste-to-osx)
(setq interprogram-paste-function 'copy-from-osx)

;; Smooth Scrolling
(setq scroll-margin 5
      scroll-conservatively 9999
      scroll-step 1)

;; Newline at end of file
(setq require-final-newline t)

;; No lock files
(setq create-lockfiles nil)

;; Don't show the menu bar
(menu-bar-mode -1)

;; Always load newest byte code
(setq load-prefer-newer t)

;; reduce the frequency of garbage collection by making it happen on
;; each 50MB of allocated data (the default is on every 0.76MB)
(setq gc-cons-threshold 50000000)

;; warn when opening files bigger than 100MB
(setq large-file-warning-threshold 100000000)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(menu-bar-mode nil)
 '(safe-local-variable-values (quote ((encoding . utf-8))))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;; init.el ends here
