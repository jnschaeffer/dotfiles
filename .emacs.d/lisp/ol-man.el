;; -*- lexical-binding: t; -*-
(require 'ol)

(org-link-set-parameters "man"
                         :follow #'org-man-open
                         :export #'org-man-export
                         :store #'org-man-store-link)

(defun org-man-open (path _)
  "Visit the man page on PATH."
  (man path))

(defun org-man-store-link (&optional _interactive?)
  "Store a link to a man page."
  (when (eq major-mode 'Man-mode)
    (let* ((page (org-man-get-page-name))
           (link (concat "man:" page))
           (description (format "man %s" page)))
      (org-link-store-props
       :type "man"
       :link link
       :description description))))

(defun org-man-get-page-name ()
  "Extracts the page name fromt he current buffer."
  (if (string-match " \\(\\S-+\\)\\*" (buffer-name))
      (match-string 1 (buffer-name))
    (error "cannot get page name")))

(defun org-man-export (link description format _)
  "Export a man page link from Org files."
  (let ((path (format "http://man.he.net/?topic=%s&section=all" link))
        (desc (or description link)))
    (pcase format
      (`html (format "<a target=\"_blank\" href=\"%s\">%s</a>" path desc))
      (`latex (format "\\href{%s}{%s}" path desc))
      (`texinfo (format "@uref{%s,%s}" path desc))
      (`ascii (format "%s (%s)" desc path))
      (_ path))))

(provide 'ol-man)
