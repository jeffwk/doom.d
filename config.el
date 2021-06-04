;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Jeff Workman"
      user-mail-address "jeff.workman@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;;(setq doom-font (font-spec :family "InputC4Mono Nerd Font" :size 16 :weight 'regular))
(setq doom-font "FiraCode Nerd Font:pixelsize=25")
;;(setq doom-font "InputC4Mono Nerd Font 15")
;;(setq doom-big-font (font-spec :family "InputC3Mono Nerd Font" :size 18 :weight 'regular))
(setq doom-big-font "FiraCode Nerd Font:pixelsize=30")
(setq doom-variable-pitch-font "Lato 15")
;;(set-frame-font doom-font)
;;(set-frame-font "FiraCode Nerd Font:weight=medium:pixelsize=25")
;;(set-frame-font "FiraCode Nerd Font 14")
;;(set-frame-font "FiraCode Nerd Font 15")
;;(set-frame-font "FiraCode Nerd Font 16")
;;(set-frame-font "FiraCode Nerd Font 17")
;;(set-frame-font "FiraCode Nerd Font 18")
;;(set-frame-font "FiraCode Nerd Font 19")

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)
;;(setq doom-theme 'doom-tomorrow-night)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)

(defun --window-system-available () (< 0 (length (getenv "DISPLAY"))))
(defun --wayland-available () (< 0 (length (getenv "WAYLAND_DISPLAY"))))
(defun graphical? () (cl-some #'display-graphic-p (frame-list)))
(defun laptop? () (or (equal (system-name) "jeff-mbp")
                      (equal (system-name) "jeff-laptop")
                      (equal (system-name) "jeff-m1.lan")))
(defun mac? () (eql system-type 'darwin))
(defun gui-mac-std? () (eql window-system 'ns))
(defun gui-emacs-mac? () (eql window-system 'mac))
(defun gui-mac? () (or (gui-mac-std?) (gui-emacs-mac?)))

(defun --indent-tabs-on ()
  (setq-local indent-tabs-mode t))
(defun --indent-tabs-off ()
  (setq-local indent-tabs-mode nil))
(defmacro --indent-tabs-mode (hook enable-tabs)
  `(add-hook! ,hook ,(if enable-tabs '--indent-tabs-on '--indent-tabs-off)))

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(defmacro define-map-keys (map &rest defs)
  `(progn ,@(mapcar (lambda (entry)
                      (cl-destructuring-bind (kbd-str func) entry
                        `(bind-key ,kbd-str ,func ,map)))
                    defs)))

(defmacro define-map-keys* (map &rest defs)
  `(progn ,@(mapcar (lambda (entry)
                      (cl-destructuring-bind (kbd-str func) entry
                        `(bind-key* ,kbd-str ,func ,map)))
                    defs)))

(defmacro define-map-keys-multi (maps &rest defs)
  `(progn ,@(mapcar (lambda (m) `(define-map-keys ,m ,@defs))
                    maps)))

(defmacro define-map-keys-multi* (maps &rest defs)
  `(progn ,@(mapcar (lambda (m) `(define-map-keys* ,m ,@defs))
                    maps)))

(define-key key-translation-map (kbd "(") (kbd "["))
(define-key key-translation-map (kbd ")") (kbd "]"))
(define-key key-translation-map (kbd "[") (kbd "("))
(define-key key-translation-map (kbd "]") (kbd ")"))

(defun --scroll-down-one-line ()
  (interactive)
  (scroll-up 1)
  (forward-line 1))

(defun --scroll-up-one-line ()
  (interactive)
  (scroll-down 1)
  (forward-line -1))

;;(featurep 'elisp-slime-nav)
(undefine-key! evil-normal-state-map "M-.")
(undefine-key! evil-motion-state-map "C-o")
(undefine-key! 'global "C-o")
;;(undefine-key! global-map "M-,")

(turn-on-elisp-slime-nav-mode)
(add-hook! (emacs-lisp-mode ielm-mode) #'turn-on-elisp-slime-nav-mode)
(define-key! elisp-slime-nav-mode-map "M-." #'elisp-slime-nav-find-elisp-thing-at-point)
(define-key! 'global "M-," #'pop-tag-mark)

(define-map-keys global-map ("M-." 'elisp-slime-nav-find-elisp-thing-at-point))
;;(define-key! 'global "C-M-w" #'other-window)

(define-key! 'global "C-o" #'ace-window)

(define-map-keys global-map
  ;; redefine bad default bindings
  ;;("C-o"          'ace-window)
  ("C-o"          'other-window)
  ("C-1"          'delete-other-windows)
  ("C-x 1"        'delete-other-windows) ; terminal
  ("C-2"          'delete-other-windows-vertically)
  ("C-M-2"        'delete-other-windows-vertically)
  ("C-x 2"        'delete-other-windows-vertically) ; terminal
  ("C-3"          'goto-line)
  ("C-x 3"        'goto-line)
  ("C-q"          'delete-window)
  ("C-x x"        'split-window-below)
  ("C-S-x"        'split-window-below)
  ("C-<tab>"      '+ivy/switch-workspace-buffer)
  ("C-x TAB"      '+ivy/switch-workspace-buffer)           ; terminal
  ("C-c TAB"      '+ivy/switch-buffer)
  ("M-<tab>"      '+ivy/switch-buffer)
  ;; 'projectile-switch-to-buffer
  ;;("C-x s"        'save-buffer)
  ;;("C-x C-s"      'save-buffer)
  ;;("C-x f"        'helm-find-files)
  ;;("C-x C-f"      'helm-find-files)
  ("C-x F"        'find-file)
  ;; unset defaults
  ("C-x o"        nil)                  ; other-window
  ;; ("C-x 0"        nil)                  ; delete-window
  ;;("C-x 3"        nil)                  ; split-window-right
  ("C-x b"        nil)                  ; ido-switch-buffer
  ;; custom bindings
  ("C-<left>"     'previous-buffer)
  ("C-<right>"    'next-buffer)
  ("M-<left>"     'previous-buffer)
  ("M-<right>"    'next-buffer)
  ("C-<down>"     '--scroll-down-one-line)
  ("C-<up>"       '--scroll-up-one-line)
  ("S-<down>"     'forward-paragraph)
  ("S-<up>"       'backward-paragraph)
  ("C-x k"        'kill-this-buffer)
  ("C-l"          'recenter-top-bottom)
  ("C-f"          'forward-sexp)
  ("C-b"          'backward-sexp)
  ("C-t"          'transpose-sexps)
  ("C-w"          'backward-kill-word)
  ("C-x C-k"      'kill-region)
  ("M-q"          'indent-sexp)
  ("C-M-k"        'kill-sexp)
  ("C-M-w"        'split-window-auto)
  ;;("C-M-s"        'split-window-auto)
  ("C-M-f"        'toggle-frame-fullscreen)
  ("C-c ;"        'comment-or-uncomment-region)
  ;;("M-/"          'hippie-expand)
  ;;("s-/"          'hippie-expand)
  ("C-x \\"       '--align-regexp)
  ("C-\\"         '--align-regexp)
  ("C-M-<tab>"    '+workspace/switch-to))

(defvar mac-command-modifier)
(defvar mac-option-modifier)

;; set modifier keys for MacOS
(when (mac?)
  (cond ((or (and (equal (system-name) "jeff-m1.lan") (gui-emacs-mac?))
             (and (equal (system-name) "jeff-mbp") (gui-mac-std?)))
         (progn (setq mac-command-modifier 'meta)
                (setq mac-option-modifier 'super)))
        (t
         (progn (setq mac-command-modifier 'super)
                (setq mac-option-modifier 'meta)))))

(defvar override-faces nil)

(defun set-override-face (face spec)
  (face-spec-set face spec)
  (add-to-list 'override-faces face))

(defun set-override-faces (&rest face-specs)
  (dolist (fs face-specs)
    (cl-destructuring-bind (face spec) fs
      (set-override-face face spec))))

(defun reset-override-faces ()
  (dolist (face override-faces)
    (face-spec-set face nil 'reset))
  (setq override-faces nil))

(reset-override-faces)

(set-override-faces
 `(font-lock-comment-face
   ((t (:foreground ,(doom-lighten "#5B6268" 0.15))))))

(setq confirm-kill-processes nil
      frame-title-format '((:eval
                            (concat
                             (if (buffer-file-name)
                                (abbreviate-file-name (buffer-file-name))
                              "%b")
                             " - Doom Emacs")))
      require-final-newline t)

(setq-default fill-column 95)



(defun symbol-matches (sym str)
  (not (null (string-match-p str (symbol-name sym)))))

(eval-and-compile
  (defun symbol-suffix (sym suffix)
    (intern (concat (symbol-name sym) suffix))))

(defmacro set-mode-name (mode name)
  (let ((func-name (intern (concat "--set-mode-name--" (symbol-name mode)))))
    `(progn
       (defun ,func-name () (setq mode-name ,name))
       (add-hook ',(symbol-suffix mode "-hook") #',func-name 100)
       (when (eql major-mode ',mode)
         (,func-name)))))

(defun set-frame-fullscreen (frame active)
  (let ((current (frame-parameter (or frame (selected-frame)) 'fullscreen)))
    (when (or (and active (not current))
              (and current (not active)))
      (toggle-frame-fullscreen frame))))

(defun print-to-buffer (x)
  (princ (concat "\n" (with-output-to-string (print x))) (current-buffer)))

(defun active-minor-modes ()
  (--filter (and (boundp it) (symbol-value it)) minor-mode-list))

(defun minor-mode-active-p (minor-mode)
  (if (member minor-mode (active-minor-modes)) t nil))

(eval-and-compile
  (defun native-comp? ()
    (and (functionp 'native-comp-available-p)
         (native-comp-available-p))))

(defun --body-title (body)
  (let* ((form (car (last body)))
         (full (prin1-to-string form)))
    (cond ((<= (length full) 40)
           full)
          ((and (listp form) (symbolp (car form)))
           (format "(%s ...)" (symbol-name (car form))))
          (t "<body>"))))

(defun --elapsed-seconds (start-time)
  (time-to-seconds (time-since start-time)))

(defmacro --with-elapsed-time (&rest body)
  `(let ((time-start (current-time)))
     ,@body
     (let ((elapsed (time-since time-start)))
       (time-to-seconds elapsed))))

(defun --init-time (&optional as-string)
  (let ((init-time (float-time
                    (time-subtract after-init-time before-init-time))))
    (if as-string (format "%.2fs" init-time) init-time)))
;;(--init-time t)

(defmacro with-delay (seconds &rest body)
  (declare (indent 1))
  `(let ((seconds ,seconds))
     (if (and (numberp seconds) (> seconds 0))
         (run-with-timer seconds nil (lambda () ,@body))
       (progn ,@body))))

(defun --set-paren-face-colors ()
  (let ((paren-color  (cond (t "#707070")))
        (square-color (cond (t "#bbbf40")))
        (curly-color  (cond (t "#4f8f3d"))))
    (face-spec-set 'parenthesis `((t (:foreground ,paren-color))))
    (defface square-brackets
      `((t (:foreground ,square-color)))
      "Face for displaying square brackets."
      :group 'paren-face)
    (defface curly-brackets
      `((t (:foreground ,curly-color)))
      "Face for displaying curly brackets."
      :group 'paren-face)))

(when (gui-mac?) 
  (set-frame-fullscreen nil t))

(defun nxml-pretty-format ()
  (interactive)
  (save-excursion
    (shell-command-on-region (point-min) (point-max)
                             "xmllint --format -" (buffer-name) t)
    (nxml-mode)
    (indent-region (point-min) (point-max))))

(defun --align-regexp (beg end regexp &optional group spacing repeat)
  "Modified version of `align-regexp`, changed to always prompt
interactively for spacing value."
  (interactive
   (append
    (list (region-beginning) (region-end))
    (if current-prefix-arg
        (list (read-string "Complex align using regexp: "
                           "\\(\\s-*\\)" 'align-regexp-history)
              (string-to-number
               (read-string
                "Parenthesis group to modify (justify if negative): " "1"))
              (string-to-number
               (read-string "Amount of spacing (or column if negative): "
                            (number-to-string align-default-spacing)))
              (y-or-n-p "Repeat throughout line? "))
      (list (concat "\\(\\s-*\\)"
                    (read-string "Align regexp: "))
            1
            (string-to-number
             (read-string "Amount of spacing (or column if negative): "
                          (number-to-string align-default-spacing)))
            nil))))
  (align-regexp beg end regexp group spacing repeat))

;; This sets up terminal-mode Emacs instances to use the X shared clipboard
;; for kill and yank commands.
;;
;; Emacs needs to be started after the X server for this to work.

(defun xsel-paste ()
  (shell-command-to-string "xsel -ob"))

(defun xsel-copy (text &optional _push)
  (let ((process-connection-type nil))
    (let ((proc (start-process "xsel -ib" "*Messages*" "xsel" "-ib")))
      (process-send-string proc text)
      (process-send-eof proc))))

(defun do-xsel-copy-paste-setup ()
  (when (and (not (mac?))
             (null window-system)
             (--window-system-available)
             (file-exists-p "/usr/bin/xsel")
             (not (equal (user-login-name) "root")))
    (setq interprogram-cut-function 'xsel-copy)
    (setq interprogram-paste-function 'xsel-paste)))

;;;
;;; copy/paste for Wayland
;;;

(defun wl-paste ()
  (shell-command-to-string "wl-paste -n"))

(defun wl-copy (text &optional _push)
  (let ((process-connection-type nil))
    (let ((proc (start-process "wl-copy" "*Messages*" "wl-copy")))
      (process-send-string proc text)
      (process-send-eof proc))))

(defun do-wayland-copy-paste-setup ()
  (when (and (--wayland-available)
             (null window-system)
             (file-exists-p "/usr/bin/wl-copy")
             (file-exists-p "/usr/bin/wl-paste")
             (not (equal (user-login-name) "root")))
    (setq interprogram-cut-function 'wl-copy)
    (setq interprogram-paste-function'wl-paste)))

(defun --init-copy-paste ()
  (interactive)
  (let ((inhibit-message t))
    (cond ((mac?)                nil)
          ((--wayland-available) (do-wayland-copy-paste-setup))
          (t                     (do-xsel-copy-paste-setup)))))

(--init-copy-paste)

(after! tramp
  (setq tramp-default-method "ssh")
  (add-to-list 'tramp-methods '("vcsh"
                                (tramp-login-program "vcsh")
                                (tramp-login-args
                                 (("enter")
                                  ("%h")))
                                (tramp-remote-shell "/bin/sh")
                                (tramp-remote-shell-args
                                 ("-c")))))

(defun --sh-mode-hook ()
  (setq-local tab-width 2)
  (add-hook! 'after-save-hook :local
             'executable-make-buffer-file-executable-if-script-p))

(after! sh-script
  (set-mode-name sh-mode "Sh")
  (add-hook! sh-mode '--sh-mode-hook)
  (add-hook! (sh-mode shell-mode) 'rainbow-mode))

(after! rainbow-mode
  (setq rainbow-html-colors t
        rainbow-html-colors-alist nil
        rainbow-ansi-colors 'auto
        rainbow-x-colors nil
        rainbow-latex-colors nil
        rainbow-r-colors nil))

(after! cc-mode
  (--indent-tabs-mode 'c-mode-hook t)
  (--indent-tabs-mode 'c++-mode-hook t)
  (--indent-tabs-mode 'objc-mode-hook t)
  (--indent-tabs-mode 'java-mode-hook t))

'(after! python-mode
   (set-mode-name python-mode "Python"))

(after! aggressive-indent
  (setq aggressive-indent-sit-for-time 0.025)
  (dolist (mode '(cider-repl-mode c-mode c++-mode objc-mode java-mode))
    (add-to-list 'aggressive-indent-excluded-modes mode))
  (aggressive-indent-global-mode 1))

(after! company
  (setq company-dabbrev-downcase nil
        company-dabbrev-ignore-case nil
        company-dabbrev-other-buffers t
        company-minimum-prefix-length 3
        company-idle-delay 0.15)
  (add-to-list 'company-transformers 'company-sort-by-occurrence)
  (require 'company-quickhelp)
  (require 'company-statistics)
  (global-company-mode 1))

(after! company-quickhelp
  (setq company-quickhelp-delay 0.5)
  (company-quickhelp-mode 1))

(after! company-statistics
  (company-statistics-mode 1))

(after! projectile
  (setq projectile-indexing-method 'hybrid
        projectile-enable-caching t)
  (define-map-keys global-map
    ("C-M-s" '+ivy/project-search)))

(after! swiper
  (setq swiper-action-recenter t)
  (define-map-keys global-map
    ("C-s" 'swiper)
    ("C-r" 'swiper)
    ("C-S-S" 'swiper-all)))

(use-package! ligature
  :load-path "~/.doom.d/ligature.el/"
  :config
  (let ((all '("www" "**" "***" "**/" "*>" "*/" "\\\\" "\\\\\\" "{-" "::"
               ":::" ":=" "!!" "!=" "!==" "-}" "----" "-->" "->" "->>"
               "-<" "-<<"  "#{" "#[" "##" "###" "####" "#(" "#?" "#_"
               "#_(" ".-" ".=" ".." "..<" "..." "?=" "??"  "/*" "/**"
               "/=" "/==" "/>" "//" "///" "&&" "||" "||=" "|=" "|>" "^=" "$>"
               "++" "+++" "+>" "=:=" "==" "===" "==>" "=>" "=>>" "<="
               "=<<" "=/=" ">-" ">=" ">=>" ">>" ">>-" ">>=" ">>>" "<*"
               "<*>" "<|" "<|>" "<$" "<$>" "<!--" "<-" "<--" "<->" "<+"
               "<+>" "<=" "<==" "<=>" "<=<" "<>" "<<" "<<-" "<<=" "<<<"
               "<~" "<~~" "</" "</>" "~>" "~~>" "%%"
               ;; ";;" "~-" "~@" "~~" "-~"
               )))
    ;; (ligature-set-ligatures 'prog-mode all)
    (ligature-set-ligatures 't all))
  (global-ligature-mode t))

(after! hl-todo
  (global-hl-todo-mode 1))

(use-package! alert
  :config
  (setq alert-default-style (if (graphical?) 'libnotify 'message)
        alert-fade-time 3))

(defun --elapsed-alert (title elapsed)
  (let ((alert-fade-time 3))
    (alert (format "Elapsed: %.3fs" elapsed) :title title)))

(defmacro --with-elapsed-time-alert (&rest body)
  `(--elapsed-alert (--body-title ',body)
                    (--with-elapsed-time ,@body)))
;;(--with-elapsed-time-alert (+ 1 2))

(defun --describe-init ()
  (interactive)
  (let ((alert-fade-time (if (display-graphic-p) 3 2))
        (inhibit-message nil))
    (alert (format "Emacs started in %s" (--init-time t))
           :title (format "Emacs <%s>" (buffer-name))
           :category 'emacs-init)))

(when (graphical?)
  (add-hook! 'after-init-hook '--describe-init))

(setq-default flycheck-disabled-checkers
              '(clojure-cider-typed
                clojure-cider-kibit
                clojure-cider-eastwood
                emacs-lisp-checkdoc))

(after! flycheck
  (setq flycheck-global-modes '(not org-mode js-mode)
        ;; '(clojure-mode clojurec-mode clojurescript-mode groovy-mode)
        ;; git-gutter is in the left fringe
        flycheck-indication-mode 'right-fringe)
  (define-map-keys flycheck-mode-map
    ("C-c ." 'flycheck-next-error)
    ("C-c ," 'flycheck-previous-error))
  (use-package! fringe-helper)
  (fringe-helper-define
    'flycheck-fringe-bitmap-double-arrow 'center
    "...X...."
    "..XX...."
    ".XXX...."
    "XXXX...."
    ".XXX...."
    "..XX...."
    "...X....")
  (global-flycheck-mode 1))

(use-package! paren-face
  :disabled t
  :config
  (setq paren-face-regexp "[\\(\\)]")
  (global-paren-face-mode)
  (--set-paren-face-colors)
  (defconst clojure-brackets-keywords
    '(("\\[" 0 'square-brackets)
      ("\\]" 0 'square-brackets)
      ("[\\{\\}]" 0 'curly-brackets)))
  (defun --custom-paren-face-mode-hook ()
    (if paren-face-mode
        (font-lock-add-keywords nil clojure-brackets-keywords t)
      (font-lock-remove-keywords nil clojure-brackets-keywords))
    (when (called-interactively-p 'any)
      (font-lock-ensure)))
  (add-hook! 'paren-face-mode-hook '--custom-paren-face-mode-hook))

(use-package! paredit
  :disabled t
  :config
  (define-map-keys paredit-mode-map
    ("C-<left>"     nil)
    ("C-<right>"    nil)
    ("C-M-<left>"   nil)
    ("C-M-<right>"  nil)
    ("C-M-<up>"     nil)
    ("C-M-<down>"   nil)
    ("C-M-f"        nil)
    ("M-s"          nil)))

(use-package! paxedit
  :disabled t
  :config
  (setq paxedit-alignment-cleanup t
        paxedit-whitespace-cleanup t)
  (define-map-keys paxedit-mode-map
    ("s-<right>"      'paxedit-transpose-forward)
    ("s-<left>"       'paxedit-transpose-backward)
    ("s-<up>"         'paxedit-backward-up)
    ("s-<down>"       'paxedit-backward-end)
    ("s-b"            'paxedit-previous-symbol)
    ("s-f"            'paxedit-next-symbol)
    ("s-c"            'paxedit-copy)
    ("s-k"            'paxedit-kill)
    ("s-<backspace>"  'paxedit-delete)
    ("M-s-<up>"       'paxedit-sexp-raise)
    ;; symbol backward/forward kill
    ("C-w"            'paxedit-backward-kill)
    ("M-w"            'paxedit-forward-kill)
    ;; symbol manipulation
    ("M-u"            'paxedit-symbol-change-case)
    ("M-s-k"          'paxedit-symbol-kill)
    ("M-s-c"          'paxedit-symbol-copy)
    ;; special
    ("s-d"            'paxedit-dissolve)
    ("s-0"            'paxedit-compress)
    ("s-1"            'paxedit-format-1)
    ;; parens
    ("("              'paxedit-open-round)
    ("["              'paxedit-open-bracket)
    ("{"              'paxedit-open-curly)
    ("s-'"            'paxedit-open-quoted-round))
  (add-to-list 'emacs-lisp-mode-hook 'paxedit-mode))

(use-package! git-timemachine
  :bind (("s-g" . git-timemachine)
         ("H-s-g" . git-timemachine)))

(use-package! expand-region
  :bind ("C-=" . er/expand-region))

(use-package! whitespace
  :config
  ;; (add-hook! 'before-save-hook 'whitespace-cleanup)
  (add-hook! (prog-mode text-mode) 'whitespace-mode)
  ;; render warning background for lines exceeding `fill-column`
  (setq whitespace-line-column nil)
  (setq whitespace-style '(face
                           tabs empty trailing lines-tail
                           indentation space-after-tab space-before-tab)))
(use-package! systemd
  :mode (("\\.service\\'"  . systemd-mode)
         ("\\.target\\'"   . systemd-mode)))

(use-package! groovy-mode
  :mode "/Jenkinsfile"
  :config
  (setq groovy-indent-offset 2)
  (defun --groovy-mode-config ()
    (setq-local tab-width 2))
  (add-hook 'groovy-mode-hook #'--groovy-mode-config))

(after! markdown-mode
  (use-package! gh-md))

(use-package! nginx-mode
  :mode ("/nginx.conf$"
         "\\.nginx-site\\'"))

(defun --load-org-notify ()
  (interactive)
  (when (not (featurep 'org-notify))
    (require 'org)
    (add-to-list 'load-path "~/.doom.d/org-notify")
    (require 'org-notify)
    (setq org-notify-interval 600
          org-notify-fade-time 7)))

(use-package! org
  :bind (("C-c l" . org-store-link)
         ("C-c a" . org-agenda)
         ("C-c c" . org-capture))
  :config
  (setq org-log-done 'time
        org-agenda-files '("~/org/self.org"
                           "~/org/schedule.org"
                           "~/org/work.org"
                           "~/org/sysrev.org")
        org-agenda-timegrid-use-ampm t)
  (define-map-keys org-mode-map
    ("C-S-<left>"     'org-metaleft)
    ("C-S-<right>"    'org-metaright)
    ("C-S-<down>"     'org-metadown)
    ("C-S-<up>"       'org-metaup)
    ("C-S-<return>"   'org-meta-return))
  ;; unbind conflicting keys
  (define-map-keys org-mode-map
    ("C-c C-p"        nil)
    ("C-c p"          nil)
    ("C-<tab>"        nil)
    ("M-s a"          'org-agenda-list)
    ("M-s s"          'org-schedule)
    ("M-s d"          'org-deadline))
  (define-map-keys-multi (global-map org-mode-map)
    ("M-s p"          'org-pomodoro)
    ("M-s c"          'org-notify-check))
  (use-package! org-ql)
  (use-package! org-present)
  (use-package! org-projectile)
  (use-package! org-super-agenda)
  (use-package! org-gcal)
  (use-package! org-fancy-priorities)
  (--load-org-notify)
  (use-package! org-bullets
    :config
    (add-hook! 'org-mode-hook 'org-bullets-mode)
    ;; ◉ ○ ✸ ✿ ♥ ● ◇ ✚ ✜ ☯ ◆ ♠ ♣ ♦ ☢ ❀ ◆ ◖ ▶
    ;; ► • ★ ▸
    ;; '("◆" "◇")
    (setq org-bullets-bullet-list '("●" "◉")))
  (use-package! org-pomodoro
    ;; https://github.com/marcinkoziej/org-pomodoro
    ;; M-x org-pomodoro (activate on org task)
    :config
    (defun --org-clock-heading () "")
    (setq org-pomodoro-length 25
          org-pomodoro-short-break-length 5
          org-pomodoro-audio-player (executable-find "mpv-quiet")
          org-clock-clocked-in-display nil
          ;; org-clock-string-limit 1
          org-clock-heading-function #'--org-clock-heading))
  (use-package! mpv
    :config
    (org-link-set-parameters "mpv" :follow #'mpv-play)
    (add-hook! 'org-open-at-point-functions #'mpv-seek-to-position-at-point)
    (defun org-mpv-complete-link (&optional arg)
      (replace-regexp-in-string "file:" "mpv:"
                                (org-link-complete-file arg)
                                t t))))

(use-package! pkgbuild-mode :mode "/PKGBUILD")

(use-package! yaml-mode :mode "\\.yml\\'")

(after! cider
  (require 'tramp)
  (setq clojure-use-backtracking-indent t
        clojure-indent-style 'always-align ;; 'align-arguments
        cider-repl-use-pretty-printing t
        cider-auto-select-error-buffer t
        cider-prompt-for-symbol nil
        cider-save-file-on-load t
        nrepl-use-ssh-fallback-for-remote-hosts t
        cider-preferred-build-tool 'shadow-cljs
        cider-default-cljs-repl 'shadow-select
        cider-shadow-default-options ":dev")
  (when (featurep 'auto-highlight-symbol)
    (dolist (mode '(clojure-mode clojurescript-mode))
      (add-to-list 'ahs-modes mode)))
  (setq clojure-docstring-fill-column 80)
  (set-mode-name clojure-mode "CLJ")
  (set-mode-name clojurescript-mode "CLJS")
  (set-mode-name clojurec-mode "CLJC")
  (dolist (mh '(clojure-mode-hook clojurescript-mode-hook))
    (add-hook mh 'cider-mode))
  (when nil
    (dolist (m '(clojure-mode clojurescript-mode cider-repl-mode))
      (add-to-list 'sp-ignore-modes-list m))
    (dolist (mh '(clojure-mode-hook clojurescript-mode-hook cider-repl-mode-hook))
      (add-hook mh 'enable-paredit-mode)
      (add-hook mh 'paxedit-mode))
    '(enable-lispy 'clojure-mode-hook 'cider-mode-hook 'cider-repl-mode-hook))
  (defun --cider-reload-repl-ns ()
    (let ((ns (buffer-local-value 'cider-buffer-ns (car (cider-repls)))))
      (when ns
        (cider-nrepl-request:eval
         (format "(require '%s :reload)" ns)
         (lambda (_response) nil)))))
  (add-hook 'cider-file-loaded-hook '--cider-reload-repl-ns)
  (define-map-keys cider-mode-map
    ("C-c C-k" 'cider-load-buffer)
    ("C-c n" 'cider-repl-set-ns)
    ("C-c C-p" nil))
  (define-map-keys cider-repl-mode-map
    ("C-c C-p" nil)
    ("C-M-l" 'cider-repl-clear-buffer))
  '(require 'auto-cider)
  (use-package! clj-refactor
    :config
    (setq cljr-warn-on-eval nil
          cljr-suppress-middleware-warnings nil)
    (defun clj-refactor-clojure-mode-hook ()
      (clj-refactor-mode 1)
      (yas-minor-mode 1)
      ;; cljr--all-helpers
      (cljr-add-keybindings-with-prefix "C-'"))
    (bind-keys* :map clojure-mode-map
                ("C-<return>" . hydra-cljr-help-menu/body))
    (add-hook 'clojure-mode-hook #'clj-refactor-clojure-mode-hook)
    (add-hook 'clojurescript-mode-hook #'clj-refactor-clojure-mode-hook))
  (use-package! flycheck-clojure
    :config
    (flycheck-clojure-setup))
  (use-package! flycheck-clj-kondo))

(defun --elisp-mode-hook ()
  (require 'ielm)
  (elisp-slime-nav-mode 1)
  (eldoc-mode 1)
  (rainbow-mode 1)
  (when nil
    (turn-off-smartparens-mode)
    (enable-paredit-mode)))

'(enable-lispy 'emacs-lisp-mode-hook)

(use-package! scala-mode
  :disabled t
  :mode (("\\.scala\\'" . scala-mode)
         ("\\.sbt\\'" . scala-mode))
  :config
  (use-package! ensime
    :disabled t
    :diminish ensime-mode
    :config
    (setq ensime-startup-snapshot-notification nil)
    (setq ensime-auto-generate-config t)
    (setq ensime-typecheck-idle-interval 0.3)
    (setq ensime-completion-style 'company)
    (define-map-keys scala-mode-map
      ("C-t"     'ensime-type-at-point)
      ("C-M-e"   'ensime-print-errors-at-point)
      ("C-c ."   'ensime-forward-note)
      ("C-c ,"   'ensime-backward-note)
      ("C-M-."   'ensime-show-uses-of-symbol-at-point))))

(use-package! haskell-mode
  :disabled t
  :mode "\\.hs\\'" "\\.hs-boot\\'" "\\.lhs\\'" "\\.lhs-boot\\'"
  :config
  (use-package! ghc)
  (use-package! ac-haskell-process
    :disabled t
    :config
    (add-hook 'interactive-haskell-mode-hook 'ac-haskell-process-setup)
    (add-hook 'haskell-interactive-mode-hook 'ac-haskell-process-setup)
    (add-to-list 'ac-modes 'haskell-interactive-mode))
  (add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
  (add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
  (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
  (autoload 'ghc-init "ghc" nil t)
  (autoload 'ghc-debug "ghc" nil t)
  (add-hook 'haskell-mode-hook (lambda () (ghc-init)))
  (setq haskell-process-suggest-remove-import-lines t)
  (setq haskell-process-auto-import-loaded-modules t)
  (setq haskell-process-log t)
  (setq haskell-process-type 'cabal-repl))

(use-package! less-css-mode
  :mode ("\\.less\\'"
         "\\.variables\\'"
         "\\.overrides\\'")
  :config (add-hook! less-css 'rainbow-mode))

(use-package! js2-mode
  :disabled t
  :mode ("\\.js\\'"
         "\\.json\\'"
         "\\.config/waybar/config\\'")
  :config
  (flycheck-add-mode 'javascript-eslint 'js2-mode)
  (flycheck-add-mode 'javascript-eslint 'js2-jsx-mode)
  (setq js2-include-node-externs t
        js2-include-browser-externs t
        js2-strict-trailing-comma-warning nil
        js2-basic-offset 2)
  (defun --custom-js2-mode-hook ()
    (setq-local js2-basic-offset 2)
    ;;(tern-mode t)
    (when (executable-find "eslint")
      (flycheck-select-checker 'javascript-eslint)))
  (add-hook! js2-mode '--custom-js2-mode-hook)
  (add-hook js2-jsx-mode '--custom-js2-mode-hook))

(use-package! js
  :disabled t
  :mode (("\\.js\\'"                      . js-mode)
         ("\\.json\\'"                    . js-mode)
         ("\\.config/waybar/config\\'"    . js-mode))
  :init (setq js-indent-level 2))

(use-package! web-mode
  :disabled t
  :mode "\\.jsx\\'" ;; ("\\.js\\'" "\\.jsx\\'" "\\.json\\'")
  :config
  (use-package! tern :disabled t)
  (flycheck-add-mode 'javascript-eslint 'web-mode)
  (add-to-list 'flycheck-disabled-checkers 'javascript-jshint)
  (add-to-list 'flycheck-disabled-checkers 'json-jsonlist)
  (defun --custom-web-mode-hook ()
    (setq web-mode-markup-indent-offset 2)
    (setq web-mode-css-indent-offset 2)
    (setq web-mode-code-indent-offset 2)
    (flycheck-mode 1)
    ;; (tern-mode t)
    (when (executable-find "eslint")
      (flycheck-select-checker 'javascript-eslint)))
  (add-hook! web-mode '--custom-web-mode-hook))

(use-package! jade-mode
  :disabled t
  :mode "\\.jade\\'")

(global-auto-revert-mode t)
(transient-mark-mode t)
(delete-selection-mode t)

;;(windmove-default-keybindings '(shift))
(windmove-default-keybindings '(control meta))

;; ITERM2 MOUSE SUPPORT
(when (and (mac?) (null window-system))
  (require 'mwheel)
  (require 'mouse)
  (xterm-mouse-mode t)
  (mouse-wheel-mode t)
  (global-set-key [mouse-5] 'next-line)
  (global-set-key [mouse-4] 'previous-line))

(use-package! uniquify
  :config
  (setq uniquify-buffer-name-style 'post-forward
        uniquify-separator "/"
        uniquify-after-kill-buffer-p t
        uniquify-ignore-buffers-re "^\\*"))

;; Make sure Emacs has the correct ssh-agent config,
;; in order to use tramp and git commands without requesting a password.
(unless (mac?)
  (if (equal (user-login-name) "root")
      (setenv "SSH_AUTH_SOCK" "/run/ssh-agent.socket")
    (setenv "SSH_AUTH_SOCK" (concat (getenv "XDG_RUNTIME_DIR") "/ssh-agent.socket"))))

;; Need to make sure emacs server daemon and emacsclient
;; are using the same path for the socket file.
;; The path is set here, and the same is set in a script
;; for starting emacsclient (/usr/local/bin/e).
(unless (graphical?)
  (setq server-socket-dir (format "/tmp/%s/emacs%d" (user-login-name) (user-uid))))

(setq hippie-expand-try-functions-list '(try-expand-dabbrev
                                         try-expand-dabbrev-all-buffers
                                         try-expand-dabbrev-from-kill
                                         try-complete-file-name-partially
                                         try-complete-file-name
                                         try-expand-all-abbrevs
                                         try-expand-list
                                         try-expand-line
                                         try-complete-lisp-symbol-partially
                                         try-complete-lisp-symbol))

(global-hl-line-mode +1)

(use-package! recentf
  :disabled t
  :config
  (setq recentf-save-file (expand-file-name "recentf" --savefile-dir)
        recentf-max-saved-items 500
        recentf-max-menu-items 15
        ;; disable recentf-cleanup on Emacs start, because it can cause
        ;; problems with remote files
        recentf-auto-cleanup 'never)
  (recentf-mode +1))

(defvar --all-config-files
  (list "~/.emacs.d/init.el"
        "~/.emacs.d/early-init.el"
        "~/.gitconfig"
        "~/.ssh/config"
        "~/.config/mpv/mpv.conf"
        "~/.config/sway/config"
        "~/.config/mako/config"
        "~/.config/waybar/config"
        "~/.config/wofi/config"
        "~/.config/alacritty/alacritty.yml"
        "~/.config/systemd/user/compile.slice"
        "~/.config/systemd/user/sway-session.target"
        "~/bin/launch-sway-programs"
        "~/bin/makepkg-chroot"
        "~/abs/build"
        "~/abs/build-one"
        "~/abs/build-all"))

(defun --launch-user-main ()
  (interactive)
  (with-delay 0.5
    (delete-other-windows)
    (dolist (f (append --all-config-files '("~/.emacs.d/init.el")))
      (message "opened: %s" f)
      (find-file-existing f))))

(defun --launch-todo ()
  (interactive)
  (with-delay 0.5
    (find-file "~/.doom.d/config.el")
    (find-file "~/org/self.org")
    (delete-other-windows)
    (org-shifttab)
    (org-shifttab)
    (org-shifttab)
    (split-window-right)
    (org-agenda-list)
    (--load-org-notify)
    (org-notify-enable)))

(defun --launch-code ()
  (interactive)
  (with-delay 0.5
    (find-file "~/code/sysrev/project.clj")
    (split-window-right)
    (magit-status-setup-buffer default-directory)
    (sysrev)))

(defun --cider-load-buffer-reload-repl (&optional buffer)
  (interactive)
  (let ((result (if buffer
                    (cider-load-buffer buffer)
                  (cider-load-buffer))))
    (--cider-reload-repl-ns)
    result))

(defun all-sesman-sessions ()
  (sesman-sessions (sesman--system) t))

(defun test-buffer-name (buf regexp &optional exclude-regexp)
  (and (string-match regexp (buffer-name buf))
       (if (null exclude-regexp) t
         (not (string-match exclude-regexp (buffer-name buf))))))

(defun match-buffer-name (regexp &optional exclude-regexp)
  (--filter (test-buffer-name it regexp exclude-regexp)
            (buffer-list)))

(defun match-sesman-session (regexp &optional exclude-regexp)
  (->> (all-sesman-sessions)
    (--remove (not (test-buffer-name (cl-second it) regexp exclude-regexp)))
    (cl-first)))

(defun stop-cider-all ()
  (interactive)
  (dolist (buf (match-buffer-name "\*cider-repl\ .*"))
    (save-excursion
      (switch-to-buffer buf)
      (cider-quit))))

(defvar --wait-on-condition-lock nil)

(defun --wait-on-condition (ready-p on-ready &optional interval timeout delay)
  (let* ((interval (or interval 0.025))
         (timeout (or timeout 5))
         (max-attempts (round (/ timeout interval)))
         (delay delay))
    (cond ((< max-attempts 1)
           nil)
          ((and (null --wait-on-condition-lock)
                (let (;; (--wait-on-condition-lock t)
                      )
                  (funcall ready-p)))
           (with-delay delay
             (let ((--wait-on-condition-lock t))
               (funcall on-ready))))
          (t (run-with-timer interval nil
                             #'--wait-on-condition
                             ready-p on-ready interval (- timeout interval) delay)))))

(defmacro wait-on-condition (test-form args &rest body)
  (declare (indent 2))
  `(--wait-on-condition (lambda () ,test-form)
                        (lambda () ,@body)
                        ,@args))
;;(wait-on-condition t nil (alert "hi"))

(defun --wait-on-buffer-text (buffer match-regexp on-ready
                                     &optional interval timeout delay)
  (let ((buffer buffer)
        (match-regexp match-regexp)
        ;; (delay (or delay 0.02))
        )
    (--wait-on-condition (lambda ()
                           (string-match-p match-regexp
                                           (with-current-buffer buffer
                                             (buffer-string))))
                         on-ready interval timeout delay)))

(defmacro wait-on-buffer-text (buffer match-regexp args &rest body)
  (declare (indent 3))
  `(let ((buffer ,buffer)
         (match-regexp ,match-regexp))
     (--wait-on-buffer-text buffer match-regexp
                            (lambda () ,@body)
                            ,@args)))
;;(wait-on-buffer-text (current-buffer) "body\) *$" (0.1 3) (alert "hi"))

(defvar --run-cider-progress nil)
(defvar --run-cider-target nil)

(defun --init-run-cider (target)
  (setq --run-cider-progress 0
        --run-cider-target target))

(defun --update-run-cider-progress ()
  (setq --run-cider-progress (+ 1 --run-cider-progress)))

(defun --run-cider-finished ()
  (= --run-cider-progress --run-cider-target))

(defun run-cider-project (project-name
                          project-file-path
                          clj-file-path
                          cljs-file-path
                          clj-test-file-path
                          figwheel-port
                          _cljs-user-ns
                          clj-repl-forms
                          cljs-repl-forms)
  (--init-run-cider 2)
  (let ((start-time (current-time))
        (project-name project-name)
        (project-file-path project-file-path)
        (clj-file-path clj-file-path)
        (cljs-file-path cljs-file-path)
        (clj-test-file-path clj-test-file-path)
        (figwheel-port figwheel-port)
        ;; (cljs-user-ns cljs-user-ns)
        (clj-repl-forms clj-repl-forms)
        (cljs-repl-forms cljs-repl-forms)
        (clj-file-buffer nil)
        (cljs-file-buffer nil))
    (cl-labels
        ((open-project
          ()
          (find-file project-file-path))
         (start-clj
          ()
          (find-file clj-file-path)
          (setq clj-file-buffer (current-buffer))
          (cider-connect
           `(:host
             "localhost"
             :port
             ,(cl-second (assoc project-name (cider-locate-running-nrepl-ports))))))
         (start-cljs
          ()
          (find-file cljs-file-path)
          (setq cljs-file-buffer (current-buffer))
          (cider-connect-cljs
           `(:host "localhost" :port ,figwheel-port :cljs-repl-type shadow-select)))
         (link-sesman-dirs
          ()
          (with-current-buffer clj-file-buffer
            (when-let ((clj-ses (match-sesman-session
                                 (format ".*cider-repl.*%s.*" project-name)
                                 (format "%d" figwheel-port))))
              (sesman-link-with-directory nil clj-ses)))
          (with-current-buffer cljs-file-buffer
            (when-let ((cljs-ses (match-sesman-session
                                  (format ".*cider-repl.*%s.*%d.*"
                                          project-name figwheel-port))))
              (sesman-link-with-directory nil cljs-ses)))
          (save-excursion
            (find-file clj-test-file-path)
            (when-let ((clj-test-ses (match-sesman-session
                                      (format ".*cider-repl.*%s.*" project-name)
                                      (format "%d" figwheel-port))))
              (sesman-link-with-directory nil clj-test-ses))
            (kill-buffer)))
         (find-clj-repl
          ()
          (cl-first (match-buffer-name
                     (format ".*cider-repl.*%s.*" project-name)
                     (format "%d" figwheel-port))))
         (find-cljs-repl
          ()
          (cl-first (match-buffer-name
                     (format ".*cider-repl.*%s.*%d.*"
                             project-name figwheel-port))))
         (have-repl-buffers
          ()
          (not (null (and (find-clj-repl) (find-cljs-repl)))))
         (show-repl-buffers
          (&optional no-init)
          (let ((clj-repl (find-clj-repl))
                (cljs-repl (find-cljs-repl)))
            (delete-other-windows)
            (when clj-repl
              (switch-to-buffer clj-repl)
              (when no-init
                (goto-char (point-max))))
            (when cljs-repl
              (if clj-repl
                  (switch-to-buffer-other-window cljs-repl)
                (switch-to-buffer cljs-repl))
              (when no-init
                (goto-char (point-max))))
            (unless no-init
              (init-repl-buffers))))
         (init-repl-buffers
          ()
          (let ((clj-repl (find-clj-repl))
                (cljs-repl (find-cljs-repl)))
            (when clj-repl
              (wait-on-buffer-text clj-repl "user>" ()
                                   (let ((ns (with-current-buffer clj-file-buffer
                                               (cider-current-ns))))
                                     (save-excursion
                                       (switch-to-buffer clj-repl)
                                       (insert (format "(in-ns '%s)" ns))
                                       (cider-repl-return))
                                     (wait-on-buffer-text clj-repl (format "%s> *$" ns) ()
                                                          (dolist (s clj-repl-forms)
                                                            (save-excursion
                                                              (switch-to-buffer clj-repl)
                                                              (insert (format "%s" s))
                                                              (cider-repl-return)))
                                                          (--update-run-cider-progress)))))
            (when cljs-repl
              (wait-on-buffer-text cljs-repl "cljs\.user>" (nil nil 0.025)
                                   (let ((ns (with-current-buffer cljs-file-buffer
                                               (cider-current-ns))))
                                     (save-excursion
                                       (switch-to-buffer cljs-repl)
                                       (insert (format "(in-ns '%s)" ns))
                                       (cider-repl-return))
                                     (wait-on-buffer-text cljs-repl (format "%s> *$" ns) (nil nil 0.05)
                                                          (save-excursion
                                                            (switch-to-buffer cljs-file-buffer)
                                                            (--cider-load-buffer-reload-repl))
                                                          (dolist (s cljs-repl-forms)
                                                            (save-excursion
                                                              (switch-to-buffer cljs-repl)
                                                              (goto-char (point-max))
                                                              (insert (format "%s" s))
                                                              (cider-repl-return)))
                                                          (--update-run-cider-progress)))))
            (wait-on-condition (--run-cider-finished) ()
                               (show-repl-buffers t)
                               (--elapsed-alert project-name (--elapsed-seconds start-time))))))
      (stop-cider-all)
      (open-project)
      (start-clj)
      (start-cljs)
      (link-sesman-dirs)
      (wait-on-condition (have-repl-buffers) ()
                         (show-repl-buffers)))))

(defun sysrev ()
  (interactive)
  (run-cider-project
   "sysrev"
   "~/code/sysrev/project.clj"
   "~/code/sysrev/src/clj/sysrev/user.clj"
   "~/code/sysrev/src/cljs/sysrev/user.cljs"
   "~/code/sysrev/test/clj/sysrev/test/core.clj"
   7888
   "sysrev.user"
   '("(->> (all-projects) count time)")
   '("@(subscribe [:active-panel])")))

(defun --cider-quit-all ()
  (interactive)
  (stop-cider-all)
  (save-excursion
    (find-file "~/code/sysrev/project.clj")
    (dolist (b (projectile-project-buffers))
      (kill-buffer b))))

(defun --benchmark-sysrev ()
  (interactive)
  (--cider-quit-all)
  (with-delay 0.1 (garbage-collect))
  (with-delay 0.25 (sysrev))
  (with-delay 2.5 (--cider-quit-all)))

(defun --cider-repl-p (b)
  (eql 'cider-repl-mode (with-current-buffer b major-mode)))

(defun --cider-repl-cljs-p (b)
  (and (--cider-repl-p b)
       (not (null (string-match ".*cljs.*" (buffer-name b))))))

(defun --cider-repl-buffers ()
  (cl-remove-if-not '--cider-repl-p (buffer-list)))

(defun --cider-next-repl (current-repl)
  (->> (--cider-repl-buffers)
    (cl-remove-if (lambda (b) (equal (buffer-name b)
                                     (buffer-name current-repl))))
    (car)))

(defun --cider-goto-repl ()
  (interactive)
  (cond ((--cider-repl-p (current-buffer))
         (when-let ((b (--cider-next-repl (current-buffer))))
           (switch-to-buffer b)))
        (t
         (when-let ((b (--cider-next-repl (current-buffer))))
           (switch-to-buffer-other-window b)))))

(define-map-keys global-map
  ("C-M-r" '--cider-goto-repl))

(setq doom-modeline-buffer-file-name-style 'auto)

;; Controls max width for a centered window
(defvar auto-margin/custom-frame-width 110)
(defvar auto-margin/custom-min-margin 20)
(defun --min-margin-left (&optional window)
  (let ((current (-> (window-margins window) car (or 0))))
    (if (and (> current 0)
             (not (display-graphic-p (window-frame window))))
        1 0)))

(defun split-window-prefer-horizontal (&optional window)
  "Modified version of `split-window-sensibly' that splits horizontally
   by default when allowed."
  (interactive)
  (let ((window (or window (selected-window))))
    (if (< (frame-width (window-frame window))
           split-width-threshold)
        ;; use the default behavior if the frame isn't wide enough to
        ;; support two full-size horizontal windows
        (split-window-sensibly window)
      (set-window-margins window (--min-margin-left window) 0)
      (or (and (window-splittable-p window t)
               ;; Split window horizontally.
               (with-selected-window window
                 (split-window-right)))
          (and (window-splittable-p window)
               ;; Split window vertically.
               (with-selected-window window
                 (split-window-below)))
          (and
           ;; If WINDOW is the only usable window on its frame (it is
           ;; the only one or, not being the only one, all the other
           ;; ones are dedicated) and is not the minibuffer window, try
           ;; to split it vertically disregarding the value of
           ;; `split-height-threshold'.
           (let ((frame (window-frame window)))
             (or
              (eq window (frame-root-window frame))
              (catch 'done
                (walk-window-tree (lambda (w)
                                    (unless (or (eq w window)
                                                (window-dedicated-p w))
                                      (throw 'done nil)))
                                  frame nil 'nomini)
                t)))
           (not (window-minibuffer-p window))
           (let ((split-height-threshold 0))
             (when (window-splittable-p window)
               (with-selected-window window
                 (split-window-below)))))))))

(defun split-window-auto ()
  (interactive)
  ;; Bind threshold to allow vertical split from interactive calls
  (let ((split-height-threshold 40))
    (let ((new-window (split-window-prefer-horizontal)))
      (unless (null new-window)
        (select-window new-window))
      new-window)))

;; Use this in place of `split-window-sensibly'
(setq split-window-preferred-function 'split-window-prefer-horizontal)

;; Set a low height threshold to generally allow vertical splits
;; when window is not wide enough for horizontal split.
;;(setq split-height-threshold 20)

;; or set high height threshold to avoid automatic vertical splitting of
;; both window columns.
;;(setq split-height-threshold 40)

;; Set a high width threshold to use a horizontal split whenever
;; the window is wide enough.
;; (setq split-width-threshold 160)

(defun autoset-window-margins (&optional window &rest _args)
  (let* ((min-left (--min-margin-left window))
         (w (or (and (windowp window) window)
                (selected-window)))
         (ws (window-size w t))
         (mtotal (min (- ws auto-margin/custom-frame-width 1)
                      (- (floor (/ ws 2)) 4))))
    (if (>= mtotal (* 2 auto-margin/custom-min-margin))
        (let ((m (floor (/ (- ws auto-margin/custom-frame-width 1) 2))))
          (set-window-margins w (max m min-left) m))
      (set-window-margins w (max 0 min-left) 0))))

(defun remove-frame-margins (&optional frame)
  (let ((frame (or (and (framep frame) frame)
                   (selected-frame))))
    (dolist (window (window-list frame))
      (set-window-margins window (--min-margin-left window) 0))))

(defun autoset-frame-margins (&optional frame &rest _args)
  (->> (or (and (framep frame) frame)
           (selected-frame))
    (window-list)
    (mapc 'autoset-window-margins)))

(defun autoset-window-frame-margins (window)
  (autoset-frame-margins (window-frame window)))

(dolist (hook '(window-setup-hook
                window-size-change-functions
                after-make-frame-functions
                after-setting-font-hook))
  (add-hook hook 'autoset-frame-margins))

;;(add-hook 'pre-redisplay-functions 'autoset-window-frame-margins)
;;(add-hook 'post-command-hook 'autoset-frame-margins)
