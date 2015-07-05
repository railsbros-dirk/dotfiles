;;; packages.el --- multiple-cursors Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2014 Sylvain Benner
;; Copyright (c) 2014-2015 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; List of all packages to install and/or initialize. Built-in packages
;; which require an initialization must be listed explicitly in the list.
(setq multiple-cursors-packages
  '(
    multiple-cursors
    )
)

;; List of packages to exclude.
(setq multiple-cursors-excluded-packages '())

defun multiple-cursors/init-multiple-cursors ()
  (use-package multiple-cursors)
  )
