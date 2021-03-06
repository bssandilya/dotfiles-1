;; mac ctrl == emacs ctrl
;; mac alt == emacs meta
;; mac cmd == emacs alt
;; C-h f == look up any function
;; C-h a == search everything in emacs
;; C-h w == check to see if function is bound to a key
;; C-x C-d == browse directory
;; C-x C-e == execute expression at the end of your cursor
;; C-W == closes frame
;; C-u M-! == executes shell
;; M-: == execute arbitrary statement
;; A-l == go to line

;;TODO - C-f seems to just advance the cursor; maybe figger out a way to make it
;; bring up a Textmate-style search/replace prompt?

;;TODO - I want tabs to be a darker grey.
;;TODO - When I C-x 3 I want the new pane to open to the most recently edited file, not the one i'm lookin' at
;;TODO - code folding
;;TODO - I want replace to fucking show me how many things it goddamned replaced

;;TODO - When I launch emacs from command line, I think I always want it to use the same frame.
;; not the one that I launched from the Dock - but spawn a new one, only once.

;;TODO - why does this happen? Occasionally, CMD-c will insert a ¢ character,
;;and C-h k CMD-c shows this:
;;		¢ (translated from A-c) runs the command self-insert-command, which is
;;		an interactive built-in function in `C source code'.
;;			
;;		It is bound to many ordinary text characters.
;;			
;;		(self-insert-command N)
;;			
;;		Insert the character you type.
;;		Whichever character you type to run this command is inserted.
;;		Before insertion, `expand-abbrev' is executed if the inserted character does
;;		not have word syntax and the previous character in the buffer does.
;;		After insertion, the value of `auto-fill-function' is called if the
;;		`auto-fill-chars' table has a non-nil value for the inserted character.
;;			
;;		[back]
;;Temporary solution, I guess, is to re-bind it to 
;;clipboard-kill-ring-save

;;TODO - map C-S-d to duplicate line, or equiv
;;TODO - map A-` to "next buffer", S-A-` to "previous buffer"
;;TODO - when i tab complete a file, i don't want it to automatically open
;;TODO - make directory browsing -alhrt style
;;TODO - emulate texmate's column select mode.
;; - eh, it's better now.
;;TODO - date insert http://stackoverflow.com/questions/251908/how-can-i-insert-current-date-and-time-into-a-file-using-emacs
;;TODO - figure out how to open multiple files
;;TODO - what the fuck, PHP mode. http://i.imgur.com/8dWRI.png

;; 14:03:15 < Arkamist> look into a symbol tagging system
;; 14:03:32 < Arkamist> like xcscope or gnu global with emacs integration
;; 14:03:43 < Arkamist> and be enlightened
;; 14:03:54 < Arkamist> also sr-speedbar

;; Default indent is four spaces
(setq c-basic-offset 4)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)

;; hitting backspace should delete a tab, not convert it to spaces
(setq-default c-backspace-function 'backward-delete-char)

;; I want help to pop up in a new window the first time,
;; but after that, stay put forever
;; keep things in the same window
;;(setq pop-up-windows nil)
;;(add-to-list 'same-window-buffer-names "*Help*")
;;(add-to-list 'same-window-buffer-names "*Apropos*")
;;(add-to-list 'same-window-buffer-names "*Summary*")
;; I think I also want the same thing to happen for the buffer window.

;; bind delete to forward-delete
(global-set-key [delete] 'delete-char)
(global-set-key [kp-delete] 'delete-char)
;; C-x C-c should not fucking kill emacs
(define-key global-map (kbd "C-x C-c") 'ignore)
;; C-z shouldn't minimize the frame, either.
(define-key global-map (kbd "C-z") 'ignore)
;; A-n (cmd-n) should open new frame
(define-key global-map (kbd "A-n") 'make-frame-command)
;; allow command-v to paste in search - I believe this is mac-only
(define-key isearch-mode-map [(alt ?v)] 'isearch-yank-kill)
;; make sure command-x actually cuts the goddamned text
(define-key global-map (kbd "A-x") 'kill-region)
;; C-x h should run string-replace
(define-key global-map (kbd "C-x h") 'replace-string)
;; Tired of accidentally spellchecking.
(define-key global-map (kbd "M-$") 'ignore)
;; Disable help, since it fucking breaks Command-C
(define-key global-map (kbd "C-x C-h") 'ignore)

;; This is where my stuff lives
(setq dotfiles-dir (expand-file-name "~/.emacs.d/"))
(add-to-list 'load-path dotfiles-dir)

;Get rid of the annoying splash and startup screens
(setq inhibit-splash-screen t
      inhibit-startup-message t)

;; I like seeing column numbers
(setq column-number-mode t)

;; Make my cursor a vertical line, and quit blinking at me
(setq-default cursor-type 'bar)
(blink-cursor-mode -1)

;; color-theme, with blackboard theme, i think
(add-to-list 'load-path (concat dotfiles-dir "color-theme"))
(require 'color-theme)
(setq color-theme-is-global t
      frame-background-mode 'dark)
(color-theme-initialize)
(progn (load-file (concat dotfiles-dir "themes/blackboard.el")) 
  (color-theme-blackboard))

;; whitespace - show me trailing bullshit, and show tabs as characters
;;TODO - I want my tab background color darker, so it's almost same as background http://i.imgur.com/cYvMn.png
(require 'whitespace)
(setq-default whitespace-style '(face tabs trailing tab-mark) )
(defun turn-on-whitespace () (whitespace-mode 1))
(add-hook 'css-mode-hook (lambda () (progn (turn-on-whitespace) ) ) )
(add-hook 'js-mode-hook (lambda () (progn (turn-on-whitespace) ) ) )
(add-hook 'php-mode-hook (lambda () (progn (turn-on-whitespace) ) ) )
(add-hook 'python-mode-hook (lambda () (progn (turn-on-whitespace) ) ) )
(add-hook 'markdown-mode-hook (lambda () (progn (turn-on-whitespace) ) ) )

;; Markdown
(require 'markdown-mode)
(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))

;; Php
(require 'php-mode)

;; yaml
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

;; scpaste
(require 'scpaste)
(setq scpaste-http-destination "http://paste.lishin.org"
      scpaste-scp-destination "lishin.org:/var/domains/scpaste.lishin.org/")

;; ido, as recommended by brett.
;; I do not know what this does.
(setq ido-auto-merge-work-directories-length -1
      ido-case-fold t
      ido-create-new-buffer 'always
      ido-enable-flex-matching t
      ido-save-directory-list-file nil)
(require 'ido)
(ido-mode t)
(ido-everywhere t)

;; use ctrl-tab and shift-ctrl-tab to move around windows
;; like tabs in Chrome, etc.
(defun other-other-window ()
  (interactive)
  (other-window -1))
(global-set-key [(control tab)] 'other-window)
(global-set-key [(control shift tab)] 'other-other-window)


;; dear emacs, please stop shitting files everywhere
(custom-set-variables
  '(auto-save-file-name-transforms '((".*" "~/.emacs.d/autosaves/\\1" t)))
  '(backup-directory-alist '((".*" . "~/.emacs.d/backups/"))))
;; create the autosave dir if necessary, since emacs won't.
(make-directory "~/.emacs.d/autosaves/" t)

;; I dunno, man, emacs did this shit on its own when I changed my default font shit.
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#000000" :foreground "#F8F8F8" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 100 :width normal :foundry "apple" :family "Monaco")))))

;; delete key now deletes what i have selected
(delete-selection-mode 1)

;; show me where i am in this stupid lisp
(setq show-paren-delay 0)
(setq show-paren-style 'parenthesis)
(show-paren-mode 1)

;; revert changed files automatically
(global-auto-revert-mode t)

;; makes shit work like native os x apps
(require 'redo+)
(require 'mac-key-mode)
(mac-key-mode 1)

;; don't wrap long lines
(setq-default truncate-lines t)

;; I don't know what this does
(require 'imenu)

;; what are you
(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

;; recent files list
(require 'recentf)
(recentf-mode t)
(setq recentf-max-saved-items 300)
(global-set-key (kbd "C-x C-r") 'ido-recentf-open)
(defun ido-recentf-open ()
  "Use `ido-completing-read' to \\[find-file] a recent file"
  (interactive)
  (if (find-file (ido-completing-read "Find recent file: " recentf-list))
      (message "Opening file...")
    (message "Aborting")))


;; comment line(s)
(defun comment-or-uncomment-line (&optional lines)
  "Comment current line. Argument gives the number of lines
forward to comment"
  (interactive "P")
  (commnt-or-uncomment-region
   (lin-beginning-position)
   (lin-end-position lines)))
;; commnt region or just this line
(defun comment-or-uncomment-region-or-line (&optional lines)
  "If te line or region is not a comment, comments region
if markis active, line otherwise. If the line or region
is a comment, uncomment."
  (interactive "P")
  (if mark-active
      (if (< (mark) (point))
          (comment-or-uncomment-region (mark) (point))
    (comment-or-uncomment-region (point) (mark)))
    (comment-or-uncomment-line lines)))
;; bind above to alt-#
(global-set-key [(meta ?#)] 'comment-or-uncomment-region-or-line)
;;TODO - in PHP, this wraps every selected line in /* */ - I want it to just prepend // after the leading whitespace

;; Change directory into my virtual machine, so I don't have to do it by hand each morning.
;;(defun go-vodkamat () (cd "/vodka:/home/pavel/projects/mobilityserver") )
(defun go-vodkamat () (cd "/Users/pavel/projects/mobilityserver") )

;; cua-mode
(setq cua-rectangle-mark-key (kbd "<f5>"))
(cua-mode t)
;; only use cua-mode for rectangle-edit
(setq cua-enable-cua-keys nil)

;; trying PHP debugging
(add-to-list 'load-path "~/.emacs.d/cedet-1.0/eieio")
(load-file "~/.emacs.d/cedet-1.0/common/cedet.el")
(add-to-list 'load-path "~/.emacs.d/geben-0.26")
(autoload 'geben "geben" "PHP Debugger on Emacs" t)

;; Hey tramp, try not locking up every five minutes
(setq-default tramp-chunksize 500)

;; Open initial window with a reasonable size and position
;; http://ilovett.com/blog/emacs/emacs-frame-size-position
(defun arrange-frame (w h x y)
  "Set the width, height, and x/y position of the current frame"
  (let ((frame (selected-frame)))
    (delete-other-windows)
    (set-frame-position frame x y)
    (set-frame-size frame w h)))
(arrange-frame 240 60 2 22)
(split-window-right)

;; let's see if I can remote sudo
(set-default 'tramp-default-proxies-alist (quote ((".*" "\\`root\\'" "/ssh:%h:"))))

;; start server
(server-start)
;; I want Cmd-W (A-w) to run mac-key-close-window AND server-edit, so that
;; my buffers/windows/whatever-the-fuck die and piss off, server or no.
;;(define-key global-map (kbd "A-w") (lambda () (progn (mac-key-close-window) (server-edit))))
(remove-hook 'kill-buffer-query-functions 'server-kill-buffer-query-function)


;; Quiet, scratch
(setq initial-scratch-message "")


;; Persist the scratch buffer
(defvar persistent-scratch-filename 
    "~/Documents/.emacs-scratch"
    "Location of *scratch* file contents for persistent-scratch.")
(defvar persistent-scratch-backup-directory 
    "~/Documents/.emacs-scratch-backups/"
    "Location of backups of the *scratch* buffer contents for persistent-scratch.")
(defun make-persistent-scratch-backup-name ()
  "Create a filename to backup the current scratch file by
  concatenating PERSISTENT-SCRATCH-BACKUP-DIRECTORY with the
  current date and time."
  (concat 
   persistent-scratch-backup-directory
   (format-time-string "%Y-%m-%d-%H%M%S.bak")))
(defun save-persistent-scratch ()
  "Write the contents of *scratch* to the file name
  PERSISTENT-SCRATCH-FILENAME, making a backup copy in
  PERSISTENT-SCRATCH-BACKUP-DIRECTORY."
  (with-current-buffer (get-buffer "*scratch*")
    (if (file-exists-p persistent-scratch-filename)
        (copy-file persistent-scratch-filename
                   (make-persistent-scratch-backup-name)))
    (write-region (point-min) (point-max) 
                  persistent-scratch-filename)))
(defun load-persistent-scratch ()
  "Load the contents of PERSISTENT-SCRATCH-FILENAME into the
  scratch buffer, clearing its contents first."
  (if (file-exists-p persistent-scratch-filename)
      (with-current-buffer (get-buffer-create "*scratch*")
        (message (concat "Loading saved buffer into " (buffer-name)))
        (delete-region (point-min) (point-max))
        (shell-command (format "cat %s" persistent-scratch-filename) (current-buffer)))))

;; bury *scratch* buffer instead of kill it
(defadvice kill-buffer (around kill-buffer-around-advice activate)
  (if (equal (buffer-name) "*scratch*")
      (progn
        (message "Burying scratch buffer instead of killing")
        (bury-buffer)
        )
    (progn
      ad-do-it)))

;; Load last saved scratch on startup
(load-persistent-scratch)
;; Save scratch on emacs exit
(push #'save-persistent-scratch kill-emacs-hook)


(defun insert-current-line-number ()
  (interactive)
  (insert (format "%d" (line-number-at-pos))))
;; A-L (cmd-shift-L) should insert current line number
(define-key global-map (kbd "A-L") 'insert-current-line-number)

