;; Evil

;; Scroll up with C-u (must come before the require call)
(setq evil-want-C-u-scroll t)

;; Require the packages
(require-package 'evil)
(evil-mode 1)
(require-package 'evil-jumper) ; c-i / c-o
(require-package 'evil-visualstar)
(require-package 'evil-indent-textobject)
(require-package 'evil-surround)
(require-package 'evil-leader)
(require-package 'evil-matchit) ; matchit (show matching parenthesis)
(require-package 'evil-search-highlight-persist)
(global-evil-matchit-mode t)
(global-evil-surround-mode t)
(global-evil-search-highlight-persist t)

;; Ace Jump
(evil-leader/set-key "e" 'evil-ace-jump-word-mode) ; ,e for Ace Jump (word)
(evil-leader/set-key "l" 'evil-ace-jump-line-mode) ; ,l for Ace Jump (line)
(evil-leader/set-key "x" 'evil-ace-jump-char-mode) ; ,x for Ace Jump (char)

;; prevent esc-key from translating to meta-key in terminal mode
(setq evil-esc-delay 0)

;; Change cursor color based on mode
(setq evil-emacs-state-cursor '("red" box))
(setq evil-normal-state-cursor '("green" box))
(setq evil-visual-state-cursor '("orange" box))
(setq evil-insert-state-cursor '("red" bar))
(setq evil-replace-state-cursor '("red" bar))
(setq evil-operator-state-cursor '("red" hollow))

;; Change the leader key
(global-evil-leader-mode t)
(setq evil-leader/in-all-states t)
(evil-leader/set-leader ",")

;; Splitting windows
(evil-leader/set-key "v" 'split-window-right)
(evil-leader/set-key "h" 'split-window-below)

;; j/k move over wrapped lines
(define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)

;; ESC all the things
(defun minibuffer-keyboard-quit ()
  "Abort recursive edit.
In Delete Selection mode, if the mark is active, just deactivate it;
then it takes a second \\[keyboard-quit] to abort the minibuffer."
  (interactive)
  (if (and delete-selection-mode transient-mark-mode mark-active)
      (setq deactivate-mark  t)
    (when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
    (abort-recursive-edit)))
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
(global-set-key [escape] 'evil-exit-emacs-state)

(provide 'init-evil)
