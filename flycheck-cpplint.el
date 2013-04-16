;;; flycheck-cpplint.el --- Flycheck checker for cpplint

;; Copyright (C) 2013  ptrv <mail@petervasil.net>

;; Author: ptrv <mail@petervasil.net>
;; Keywords: tools, extensions

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Flycheck checker for C++ using cpplint.py

;;; Code:

(eval-and-compile
  (defvar flycheck-cpplint-path
    (let ((path (or (locate-library "flycheck-cpplint") load-file-name)))
      (and path (file-name-directory path)))
    "Directory containing the flycheck-cpplint package."))

(eval-after-load "flycheck"
  '(progn
     (flycheck-def-option-var flycheck-cpplint-category-filter nil c++-cpplint
       "A Comma-separated list of category-filters to apply.

Only error messages whose category names pass the filters will be
printed. \(Category names are printed with the message and look
like \"[whitespace/indent]\".\) Filters are evaluated left to
right. \"-FOO\" means \"do not print categories that start with
FOO\". \"+FOO\" means \"do print categories that start with FOO.

Examples: \"-whitespace,+whitespace/braces\",
          \"-whitespace,-runtime/printf,+runtime/printf_format\"
          \"-,+build/include_what_you_use\""
       :type '(choice (const :tag "Default empty" nil)
                      (string :tag "Comma-separated list of category filters")))
     (put 'flycheck-cpplint-category-filter 'safe-local-variable #'stringp)

     (flycheck-def-option-var flycheck-cpplint-verbosity 3 c++-cpplint
       "The verbosity level.

Specify a number 0-5 to restrict errors to certain verbosity levels."
       :type '(choice (integer :tag "Default value" :value  3)
                      (integer :tag "Verbosity level")))
     (put 'flycheck-cpplint-verbosity 'safe-local-variable #'integerp)

     (flycheck-declare-checker c++-cpplint
       "A cpp syntax checker using the cpplin.py tool.

See URL `http://google-styleguide.googlecode.com/svn/trunk/cpplint/cpplint.py'."
       :command `(,(concat flycheck-cpplint-path "bin/cpplint.py")
                  (option "--verbose="
                          flycheck-cpplint-verbosity
                          flycheck-option-int)
                  (option "--filter=" flycheck-cpplint-category-filter)
                  source-inplace)
       :error-patterns '(("^\\(?1:.*\\):\\(?2:.*\\):  \\(?4:.*\[[0-4]\]\\)$" warning)
                         ("^\\(?1:.*\\):\\(?2:.*\\):  \\(?4:.*\[[5]\]\\)$" error))
       :modes 'c++-mode)

     (add-to-list 'flycheck-checkers 'c++-cpplint)))

(provide 'flycheck-cpplint)
;;; flycheck-cpplint.el ends here
