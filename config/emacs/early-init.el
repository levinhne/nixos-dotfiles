;; -*- lexical-binding: t; -*-
;; early-init.el - Loaded before init.el

;; Increase garbage collection threshold for faster startup
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; Reset GC after startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024)  ; 16MB
                  gc-cons-percentage 0.1)))

;; Prevent package.el from loading packages before init.el
(setq package-enable-at-startup nil)

;; Disable UI elements early to avoid flickering
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(push '(horizontal-scroll-bars) default-frame-alist)

;; Also set for initial frame
(setq initial-frame-alist default-frame-alist)

;; Disable modes (with check)
(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

(setq frame-inhibit-implied-resize t)

;; Disable startup messages
(setq inhibit-startup-message t
      inhibit-startup-echo-area-message user-login-name)

;; Native compilation settings (Emacs 28+)
(when (featurep 'native-compile)
  (setq native-comp-async-report-warnings-errors 'silent
        native-comp-deferred-compilation t))

;; Faster file name handling during startup
(unless (or (daemonp) noninteractive)
  (let ((old-file-name-handler-alist file-name-handler-alist))
    (setq file-name-handler-alist nil)
    (add-hook 'emacs-startup-hook
              (lambda ()
                (setq file-name-handler-alist old-file-name-handler-alist)))))

(provide 'early-init)
;;; early-init.el ends here
