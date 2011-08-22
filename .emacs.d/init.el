;; This is where my stuff lives
(setq dotfiles-dir (expand-file-name "~/.emacs.d/"))
(add-to-list 'load-path dotfiles-dir)

;Get rid of the annoying splash and startup screens
(setq inhibit-splash-screen t
      inhibit-startup-message t)


;; color-theme, with blackboard theme, i think
(add-to-list 'load-path (concat dotfiles-dir "color-theme"))
(require 'color-theme)
(setq color-theme-is-global t
      frame-background-mode 'dark)
(color-theme-initialize)
(progn (load-file (concat dotfiles-dir "themes/blackboard.el")) 
  (color-theme-blackboard))

;; scpaste
(require 'scpaste)
(setq scpaste-http-destination "http://paste.lishin.org"
      scpaste-scp-destination "lishin.org:/var/domains/lishin.org/scpaste")


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

;; I dunno, man, emacs did this shit on its own when I changed my default font shit.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#000000" :foreground "#F8F8F8" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 100 :width normal :foundry "apple" :family "Monaco")))))
