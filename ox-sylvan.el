;;; ox-sylvan.el --- The least opinionated HTML org-mode export backend -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2022 Ian S. Pringle
;;
;; Author: Ian S. Pringle <ian@dapringles.com>
;; Maintainer: Ian S. Pringle <ian@dapringles.com>
;; Created: September 26, 2022
;; Modified: September 26, 2022
;; Version: 0.0.1
;; Keywords: org
;; Homepage: https://github.com/ian/ox-sylvan
;; Package-Requires: ((emacs "24.4"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  This is the least opinionated HTML org-mode export backend that exists. The
;;  reason I can make that claim is because ox-sylvan doesn't assume anything
;;  about how your website's HTML should be structured. When ox-sylvan is called
;;  one of three general things will happen:
;;  1. If you have no further configuration for ox-sylvan, it will default to
;;     the ox-html formated HTML for exporting
;;  2. If you provide /some/ configuration for ox-sylvan, it will export the
;;     parts that you have specified as such, and it will fallback on ox-html
;;     for everything else
;;  3. If you provide all configuration for ox-sylvan, it will export all your
;;     elements of your HTML as you have specified
;;
;;; Code:
(require 'ox-html)
(require 's)

;;; Define backend
(org-export-define-derived-backend 'sylvan-site 'html
                                   :translate-alist '(())
                                   :menu-entry '(
                                                 ?T "Export Sylvan Site (HTML)"
                                                 ((?T "To temporary buffer"
                                                      (lambda (a s v b) (ox-sylvan-export-to-buffer a s v)))
                                                  (?t "To file" (lambda (a s v b) (ox-sylvan-export-to-file a s v)))
                                                  (?o "To file and open"
                                                      (lambda (a s v b)
                                                        (if a (ox-sylvan-export-to-file t s v)
                                                          (org-open-file (ox-sylvan-export-to-file nil s v))))))))


;;; Export functions

;;;###autoload
(defun ox-sylvan-export-to-buffer (&optional async subtreep visible-only)
  "Export current buffer to a HTML buffer.
If narrowing is active in the current buffer, only export its
narrowed part.
If a region is active, export that region.
A non-nil optional argument ASYNC means the process should happen
asynchronously.  The resulting buffer should be accessible
through the `org-export-stack' interface.
When optional argument SUBTREEP is non-nil, export the sub-tree
at point, extracting information from the headline properties
first.
When optional argument VISIBLE-ONLY is non-nil, don't export
contents of hidden elements.
Export is done in a buffer named \"*Org Sylvan Export*\", which will
be displayed when `org-export-show-temporary-export-buffer' is
non-nil."
  (interactive)
    (org-export-to-buffer 'sylvan-html "*Org Sylvan Export*"
      async subtreep visible-only nil nil (lambda () (text-mode))))

;;;###autoload
(defun ox-sylvan-export-to-file (&optional async subtreep visible-only)
  "Export current buffer to a Sylvan HTML file.
If narrowing is active in the current buffer, only export its
narrowed part.
If a region is active, export that region.
A non-nil optional argument ASYNC means the process should happen
asynchronously.  The resulting file should be accessible through
the `org-export-stack' interface.
When optional argument SUBTREEP is non-nil, export the sub-tree
at point, extracting information from the headline properties
first.
When optional argument VISIBLE-ONLY is non-nil, don't export
contents of hidden elements.
Return output file's name."
  (interactive)
  (let ((outfile (org-export-output-file-name ".html" subtreep)))
    (org-export-to-file 'tufte-html outfile async subtreep visible-only)))


;;; publishing function

;;;###autoload
(defun ox-sylvan-publish-to-html (plist filename pub-dir)
  "Publish an org file to Sylvan-styled HTML.
PLIST is the property list for the given project.  FILENAME is
the filename of the Org file to be published.  PUB-DIR is the
publishing directory.
Return output file name."
  (org-publish-org-to 'sylvan-html filename
                      (concat "." (or (plist-get plist :html-extension)
                                      org-html-extension
                                      "html"))
                      plist pub-dir))

(provide 'ox-sylvan)
;;; ox-sylvan.el ends here
