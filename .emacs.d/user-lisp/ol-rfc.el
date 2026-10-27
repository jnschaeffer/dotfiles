;; -*- lexical-binding: t; -*-
(require 'ol)

(org-link-set-parameters "rfc"
                         :follow #'org-rfc-open
                         :export #'org-rfc-export
                         :store #'org-rfc-store-link)

(defun org-rfc-open (rfc-num _)
  "Visit the RFC with the given number."
  (rfc-mode-read (string-to-number rfc-num)))

(defun org-rfc-store-link (&optional _interactive?)
  "Store a link to an RFC."
  (when (eq major-mode 'rfc-mode)
    (let* ((rfc-num (org-rfc-get-number))
           (link (concat "rfc:" rfc-num))
           (description (format "RFC %s" rfc-num)))
      (org-link-store-props
       :type "rfc"
       :link link
       :description description))))

(defun org-rfc-get-number ()
  "Extracts the RFC number from the current buffer."
  (if (string-match "*rfc\\([0-9]+\\)" (buffer-name))
      (match-string 1 (buffer-name))
    (error "cannot get RFC number")))

(defun org-rfc-export (link description format)
  "Export an RFC link from Org files."
  (let ((path (format "https://www.rfc-editor.org/info/rfc%s" link))
        (desc (or description link)))
    (pcase format
      (`html (format "<a target=\"_blank\" href=\"%s\">%s</a>" path desc))
      (`latex (format "\\href{%s}{%s}" path desc))
      (`texinfo (format "@uref{%s,%s}" path desc))
      (`ascii (format "%s (%s)" desc path))
      (`md (format "[%s](%s)" desc path))
      (_ path))))

(provide 'ol-rfc)
