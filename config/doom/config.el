(setq user-full-name "Jonathan Peel"
      user-mail-address "me@jonathanpeel.co.za")

(setenv "PATH" (concat (getenv "PATH") ":/home/me/.local/bin"))

(setq
      doom-font (font-spec :family "Komiki Mono" :size 16 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "Noto Sans" :size 16)
      doom-serif-font (font-spec :family "Noto Serif")
      doom-unicode-font (font-spec :family "Noto Serif" :size 16)
      doom-big-font (font-spec :family "Komiki Mono" :size 21))

(prefer-coding-system       'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)

;;(setq doom-theme 'doom-old-hope)

(defun my/system-dark-mode-p ()
  (string-match-p
   "dark"
   (shell-command-to-string
    "gsettings get org.gnome.desktop.interface color-scheme")))

(defun my/apply-theme ()
  (if (my/system-dark-mode-p)
      (load-theme 'doom-monokai-ristretto t)
      (load-theme 'doom-flatwhite t)))

;; Run when emacs starts
(my/apply-theme)

;; Set up a timer to check periodically
(run-with-timer 0 5 #'my/apply-theme)

(add-hook! 'org-mode-hook
  (setq org-src-block-faces
        (append org-src-block-faces
                '(("plantuml" modus-themes-nuanced-yellow)
                  ("json" modus-themes-nuanced-yellow)
                  ("fsharp" modus-themes-nuanced-blue)
                  ("csharp" modus-themes-nuanced-magenta)))))

;; Set maximum line width to 120 characters
(setq visual-fill-column-width 120
      visual-fill-column-center-text t)
(visual-fill-column-mode 1)
(add-hook! 'org-mode-hook
  (visual-fill-column-mode 1))

(setq display-line-numbers-type t)

(setq org-directory "~/OneDrive/org/")

(setq org-startup-indented t
      org-src-tab-acts-natively t)

(setq-default prettify-symbols-alist '(("#+BEGIN_SRC" . "†")
                                       ("#+END_SRC" . "†")
                                       ("#+begin_src" . "†")
                                       ("#+end_src" . "†")
                                       (">=" . "≥")
                                       ("=>" . "⇨")))
(setq prettify-symbols-unprettify-at-point 'right-edge)
(add-hook 'org-mode-hook 'prettify-symbols-mode)

(custom-theme-set-faces
 'user
 '(org-block                 ((t (:inherit fixed-pitch))))
 '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
 '(org-property-value        ((t (:inherit fixed-pitch))) t)
 '(org-special-keyword       ((t (:inherit (font-lock-comment-face fixed-pitch)))))
 '(org-tag                   ((t (:inherit (shadow fixed-pitch) :weight bold))))
 '(org-verbatim              ((t (:inherit (shadow fixed-pitch))))))

;(use-package org-num
;  :load-path "lisp/"
;  :after org
;  :hook (org-mode . org-num-mode))

(setq org-agenda-files
      (seq-filter (lambda (file)
                   (and (string-match "\\.org$" file)
                       (not (string-match "archive" file))
                       (not (string-match "index-old" file))
                       (not (string-match "tmp" file))))
                 (directory-files-recursively org-directory "\\.")))

(use-package! org-habit
  :after org
  :config
  (setq org-habit-following-days 7
        org-habit-preceding-days 35
        org-habit-show-habits t))

(setq org-superstar-headline-bullets-list '("⁖" "◉" "○" "✸" "✿"))

(use-package org-pretty-tags
  :demand t
  :config
   (setq org-pretty-tags-surrogate-strings
         (quote
          (("TOPIC" . "☆")
           ("russian" . "🇷🇺")

           ("CLR"   . "☀")
           ("DZ"    . "🌦")
           ("RA"    . "🌧")
           ("TS"    . "⛈")
           ("TSRA"  . "⛈")
           ("SN"    . "🌨")
           ("SCT"   . "🌤")
           ("BKN"   . "🌤")
           ("OVC"   . "☁")


           ("@work"    . "⚒")
           ("@study"   . "📚")
           ("birthday" . "🎂")
           ("rain"     . "🌧")
           ("time"     . "⌚")
           ("grat"     . "🤗")
           ("lena"     . "👩‍❤️‍👩")
           ("fp"       . "🤦🏻‍♂️")
           ("train"    . "🚆")
           ("mountain" . "⛰️")

           ("security" . "🔥"))))
   (org-pretty-tags-global-mode))

(after! org-roam
  (setq org-roam-dailies-capture-templates
      '(("j" "Journal" entry "\n\n* Entry - %<%H:%M> \n%U\n\n%?"
         :target (file+datetree "daily.org" "#+TITLE: Journal\n"))

        ("g" "Goals" entry "* [ ] Goals - %<%d %B %Y> [/]\nSCHEDULED: %t\n** [ ] %?"
         :target (file+datetree "daily.org" "#+TITLE: Journal\n"))

                )))

(setq org-capture-templates
      '(
        ;; ("j" "Journal")
        ;; ("jj" "journal" entry (file+datetree "~/OneDrive/org/journal.org")
        ;;  "\n\n* %U\n%?")
        ;; ("jt" "journal" entry (file+datetree "~/OneDrive/org/journal.org")
        ;;  "* [ ] %?\nSCHEDULED: %t")


        ("b" "blog-post" entry (file+olp "~/repos/blog-home/blog.org" "blog")
         "* TODO %^{Title} %^g \n:PROPERTIES:\n:EXPORT_FILE_NAME: %^{Slug}\n:EXPORT_DATE: %T\n:END:\n\n%?"
         :empty-lines-before 2)

        ("m" "Email Workflow")
        ("mf" "Follow Up" entry (file+olp "~/OneDrive/org/mail.org" "Follow Up")
         "* TODO Follow up with %:fromname on %a\nSCHEDULED:%t\n\n%i")
        ("mr" "Read Later" entry (file+olp "~/OneDrive/org/mail.org" "Read Later")
         "* TODO Read %a\nSCHEDULED:%t\n\n%i")

      ("s" "Sleep Entry" table-line
         (file+headline "sleep.org" "Data")
         "|#|%^{Date}u|%^{Move (kcal)}|%^{Exercise (min)}|%^{Caffeine (mg)}|%^{Tim in daylight (min)}|%^{Time in bed}|%^{Time out of bed}|%^{Sleep Duration (h:mm)}||%^{Tags}g|"
         :immediate-finish t :jump-to-captured t
         )))

(add-hook! 'elfeed-search-mode-hook #'elfeed-update)
(add-hook! 'elfeed-search-mode-hook (elfeed-search-set-filter "+unread"))
(after! elfeed
  (setq elfeed-show-entry-switch 'display-buffer)
  (setq elfeed-search-remain-on-entry t))

(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e/")

(setq
  mu4e-get-mail-command "mbsync -a"    ;; or fetchmail, or ...
  mu4e-update-interval (* 5 60))        ;; update every 5 minutes

(setq mu4e-change-filenames-when-moving t)

(setq mu4e-maildir "~/.mail")
(setq mu4e-root-maildir "~/.mail")

(after! mu4e
  (setq my-mu4e-context-poly
        (make-mu4e-context
         :name "Polymorphic"
         :enter-func (lambda () (mu4e-message "Enter Polymorphic context"))
         :leave-func (lambda () (mu4e-message "Leave Polymorphic context"))
         :match-func (lambda (msg) (when msg (string-prefix-p "/poly" (mu4e-message-field msg :maildir))))
         :vars '((mu4e-sent-folder       . "/poly/Sent")
                 (mu4e-drafts-folder     . "/poly/Drafts")
                 (mu4e-trash-folder      . "/poly/Trash")
                 (mu4e-refile-folder     . "/poly/Archive")
                 (mu4e-get-mail-command  . "mbsync polymorphic")
                 (smtpmail-smtp-user     . "jonathanp@polymorphic.group")
                 (user-mail-address      . "jonathanp@polymorphic.group")
                 (user-full-name         . "Jonathan Peel")
                 (mu4e-bookmarks         .
                        ((:name "INBOX (Polymorphic)" :query "maildir:/poly/INBOX" :key ?i)
                         (:name "Unread messages"
                          :query "maildir:/poly/* AND flag:unread AND NOT flag:trashed" :key 117)
                         (:name "Today's messages"
                          :query "maildir:/poly/* AND date:today..now" :key 116)
                         (:name "Last 7 days"
                          :query "maildir:/poly/* AND date:7d..now" :hide-unread t :key 119)
                         (:name "Messages with images"
                          :query "maildir:/poly/* AND mime:image/*" :key 112)))
                 (mu4e-compose-signature . "")))))

(after! mu4e
  (setq my-mu4e-context-comm
        (make-mu4e-context
         :name "CommStack"
         :enter-func (lambda () (mu4e-message "Enter jonathanp@commstack.co.uk context"))
         :leave-func (lambda () (mu4e-message "Leave jonathanp@commstack.co.uk context"))
         :match-func (lambda (msg) (when msg (string-prefix-p "/comm" (mu4e-message-field msg :maildir))))
         :vars '((mu4e-sent-folder       . "/comm/Sent")
                 (mu4e-drafts-folder     . "/comm/Drafts")
                 (mu4e-trash-folder      . "/comm/Trash")
                 (mu4e-refile-folder     . "/comm/Archive")
                 (mu4e-get-mail-command  . "mbsync commstack")
                 (smtpmail-smtp-user     . "jonathanp@commstack.co.uk")
                 (user-mail-address      . "jonathanp@commstack.co.uk")
                 (user-full-name         . "Jonathan Peel")
                 (mu4e-bookmarks         .
                        ((:name "INBOX (CommStack)" :query "maildir:/comm/INBOX" :key ?i)
                         (:name "Unread messages"
                          :query "maildir:/comm/* AND flag:unread AND NOT flag:trashed" :key 117)
                         (:name "Today's messages"
                          :query "maildir:/comm/* AND date:today..now" :key 116)
                         (:name "Last 7 days"
                          :query "maildir:/comm/* AND date:7d..now" :hide-unread t :key 119)
                         (:name "Messages with images"
                          :query "maildir:/comm/* AND mime:image/*" :key 112)))
                 (mu4e-compose-signature . "")))))

(after! mu4e
  (setq my-mu4e-context-jp
        (make-mu4e-context
         :name "Jonathan Peel"
         :enter-func (lambda () (mu4e-message "Enter me@jonathanpeel.co.za context"))
         :leave-func (lambda () (mu4e-message "Leave me@jonathanpeel.co.za context"))
         :match-func (lambda (msg) (when msg (string-prefix-p "/comm" (mu4e-message-field msg :maildir))))
         :vars '((mu4e-sent-folder       . "/jp/[Gmail]/Sent Mail")
                 (mu4e-drafts-folder     . "/jp/[Gmail]/Drafts")
                 (mu4e-trash-folder      . "/jp/[Gmail]/Bin")
                 (mu4e-refile-folder     . "/jp/[Gmail]/All Mail")
                 (mu4e-get-mail-command  . "mbsync jonathanpeel")
                 (smtpmail-smtp-user     . "me@jonathanpeel.co.za")
                 (user-mail-address      . "me@jonathanpeel.co.za")
                 (user-full-name         . "Jonathan Peel")
                 (mu4e-bookmarks         .
                        ((:name "INBOX" :query "maildir:/jp/INBOX" :key ?i)
                         (:name "Unread messages"
                          :query "maildir:/jp/* AND flag:unread AND NOT flag:trashed" :key 117)
                         (:name "Today's messages"
                          :query "maildir:/jp/* AND date:today..now" :key 116)
                         (:name "Last 7 days"
                          :query "maildir:/jp/* AND date:7d..now" :hide-unread t :key 119)
                         (:name "Messages with images"
                          :query "maildir:/jp/* AND mime:image/*" :key 112)))
                 (mu4e-compose-signature . "")))))

(after! mu4e
  (setq mu4e-contexts (list my-mu4e-context-poly
                            my-mu4e-context-comm
                            my-mu4e-context-jp)))

(setq mu4e-maildir-shortcuts
  '((:maildir "/comm/Inbox" :key ?c :name "CommStack")
    (:maildir "/poly/Inbox" :key ?p :name "Polymorphic")
    (:maildir "/jp/Inbox" :key ?j :name "Jonathan")))

;(define-key mu4e-main-mode-map (kbd "U")
;  (lambda ()
;    (interactive)
;    (message "Syncing mail...")
;    (let ((process (async-shell-command "mbsync -aV")))
;      (set-process-sentinel
;       process
;       (lambda (proc event)
;         (when (string= event "finished\n")
;           (if (= 0 (process-exit-status proc))
;               (progn
;                 (kill-buffer (process-buffer proc))
;                 (delete-window (get-buffer-window (process-buffer proc)))
;                 (message "Mail sync completed successfully"))
;             (message "Mail sync finished with errors"))))))))

(after! mu4e
  (setq sendmail-program (executable-find "msmtp")
	send-mail-function #'smtpmail-send-it
	message-sendmail-f-is-evil t
	message-sendmail-extra-arguments '("--read-envelope-from")
	message-send-mail-function #'message-send-mail-with-sendmail))

;(after! mu4e
;    :defer 20
;    mu4e t)

;(after! org-gcal
;  (setq org-gcal-client-id "jonathanp@polymorphic.group"
;        org-gcal-client-secret "your-client-secret"
;        org-gcal-fetch-file-alist '(("jonathanp@polymorphic.group" . "~/OneDrive/org/calendar.org"))))

;(use-package! org-caldav
;  :config
;  (setq org-caldav-url "http://localhost:1080/users/jonathanp@polymorphic.group/calendar"
;        org-caldav-calendar-id "Calendar"
;        org-caldav-inbox "~/OneDrive/org/calendar.org"
;        org-caldav-files '("~/OneDrive/org/calendar.org")
;        org-caldav-sync-direction 'twoway
;        org-caldav-delete-calendar-entries 'ask
;        org-caldav-resume-aborted-sync t))

(setq org-plantuml-jar-path "/home/me/bin/plantuml.jar")
(setq org-plantuml-default-exec-mode 'executable)
(setq plantuml-default-exec-mode 'executable)

(defun org-latex-quote-block (quote-block contents info)
  "Transcode a QUOTE-BLOCK element from Org to LaTeX.
    CONTENTS holds the contents of the block.  INFO is a plist
    holding contextual information."
  (org-latex--wrap-label
   quote-block
   (format "\\begin{shaded*}\\begin{quote}\n%s\\end{quote}\\end{shaded*}" contents) info))

;(org-export-define-derived-backend 'my-latex 'latex
;  :translate-alist '((quote-block . my-org-latex-quote-block)))

(setq org-latex-listings 'minted)
(setq org-latex-packages-alist '(("" "minted")))
(setq org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))
(setq org-latex-minted-options
      '(("frame" "leftline")
        ("framesep" "2mm")))

(after! ess
  (setq ess-style 'RStudio
        ess-eval-visibly 'nowait
        ess-use-flymake nil)  ; Use flycheck instead

  ;; Enable rainbow delimiters in R scripts
  (add-hook! 'ess-r-mode-hook #'rainbow-delimiters-mode)

  ;; Enable line numbers in R scripts
  (add-hook! 'ess-r-mode-hook #'display-line-numbers-mode)

  ;; Auto-completion settings
  (setq ess-use-company t
        company-R-args t
        company-R-objects t))

(after! lsp-mode
  (setq lsp-r-server-path "R"
        lsp-r-lsp-server 'languageserver))

(define-derived-mode astro-mode web-mode "astro")
(setq auto-mode-alist
      (append '((".*\\.astro\\'" . astro-mode))
              auto-mode-alist))

(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-language-id-configuration
               '(astro-mode . "astro"))

  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection '("astro-ls" "--stdio"))
                    :activation-fn (lsp-activate-on "astro")
                    :server-id 'astro-ls)))

(after! org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((typescript . t))))

;(use-package! ob-typescript
;  :after org
;  :config
;  ;; Use tsx instead of ts-node
;  (setq org-babel-typescript-command "tsx"))

(org-babel-do-load-languages 'org-babel-load-languages '((csharp . t)))

(after! fsharp-mode
  (setq fsharp-ac-use-popup nil)  ; Use display-buffer instead of pop-up
  (setq lsp-fsharp-server-runtime 'net-core)  ; Use .NET Core runtime

  ;; Optional: Configure formatting
  (setq-hook! 'fsharp-mode-hook
    tab-width 4
    indent-tabs-mode nil))

;; Optional: Add key bindings
(map! :map fsharp-mode-map
      :localleader
      "b" #'fsharp-load-buffer-file    ; Load current buffer
      "e" #'fsharp-eval-region         ; Evaluate region
      "i" #'fsharp-ac-load-project     ; Load project
      "p" #'fsharp-ac-start-process)   ; Start F# process

(after! yasnippet
  (setq yas-snippet-dirs '("~/.doom.d/snippets")))

(add-to-list 'auto-mode-alist '("\\.pl$" . prolog-mode))
(setq prolog-electric-if-then-else-flag t)

; Org-Babel Support
(setq org-babel-prolog-command "swipl")
(org-babel-do-load-languages
 'org-babel-load-languages
 '((prolog . t)))
