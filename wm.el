

(use-package exwm
  :straight (exwm :type git :host github :repo "emacs-straight/exwm" :files ("*" (:exclude ".git")))
  :config

  ;; necessary to configure exwm manually
  ;; (require 'exwm-config)

  ;; fringe size, most people prefer 1 
  (fringe-mode 3)

  ;; emacs as a daemon, use "emacsclient <filename>" to seamlessly edit files from the terminal directly in the exwm instance
  (server-start)

  ;; fix slack window parenting issues
  (add-to-list 'exwm-manage-configurations '((equal exwm-class-name "Slack") managed t))

  ;; this fixes issues with ido mode, if you use helm, get rid of it
  ;;      (exwm-config-ido)

  ;; a number between 1 and 9, exwm creates workspaces dynamically so I like starting out with 1
  (setq exwm-workspace-number 5)

  (add-to-list 'exwm-manage-configurations '((equal exwm-class-name "Slack") managed t))
  ;; make x buffers available on all workspaces
  (setq exwm-workspace-show-all-buffers t)
  (setq exwm-layout-show-all-buffers t)

  ;; this is a way to declare truly global/always working keybindings
  ;; this is a nifty way to go back from char mode to line mode without using the mouse
  (exwm-input-set-key (kbd "s-r") #'exwm-reset)
  (exwm-input-set-key (kbd "s-k") #'exwm-workspace-delete)
  (exwm-input-set-key (kbd "s-w") #'exwm-workspace-swap)
  (exwm-input-set-key (kbd "s-n") 'ibuffer)
  (exwm-input-set-key (kbd "s-m") 'next-buffer)
  (exwm-input-set-key (kbd "s-,") 'previous-buffer)
  (exwm-input-set-key (kbd "s-/") 'kill-current-buffer) 

  (exwm-input-set-key (kbd "s-h") 'windmove-left)
  (exwm-input-set-key (kbd "s-j") 'windmove-down)
  (exwm-input-set-key (kbd "s-k") 'windmove-up)
  (exwm-input-set-key (kbd "s-l") 'windmove-right) 
  (exwm-input-set-key (kbd "s-;") 'delete-window) 


  (exwm-input-set-key (kbd "s-s h") 'split-window-right)
  (exwm-input-set-key (kbd "s-s j") 'split-window-below)
  (exwm-input-set-key (kbd "s-s k") 'split-and-follow-horizontally)
  (exwm-input-set-key (kbd "s-s l") 'split-and-follow-vertically)

  ;; the next loop will bind s-<number> to switch to the corresponding workspace
  (dotimes (i 10)
    (exwm-input-set-key (kbd (format "s-%d" i))
                        `(lambda ()
                           (interactive)
                           (exwm-workspace-switch-create ,i))))

  ;; the simplest launcher, I keep it in only if dmenu eventually stopped working or something
  (exwm-input-set-key (kbd "s-&")
                      (lambda (command)
                        (interactive (list (read-shell-command "$ ")))
                        (start-process-shell-command command nil command)))

  ;; an easy way to make keybindings work *only* in line mode
  (push ?\C-q exwm-input-prefix-keys)
  (define-key exwm-mode-map [?\C-q] #'exwm-input-send-next-key)

  ;; simulation keys are keys that exwm will send to the exwm buffer upon inputting a key combination
  ;; (exwm-input--set-simulation-keys
  ;;  '(
  ;;    ;; movement
  ;;    ([?\C-b] . left)
  ;;    ([?\M-b] . C-left)
  ;;    ([?\C-f] . right)
  ;;    ([?\M-f] . C-right)
  ;;    ([?\C-p] . up)
  ;;    ([?\C-n] . down)
  ;;    ([?\C-a] . home)
  ;;    ([?\C-e] . end)
  ;;    ([?\M-v] . prior)
  ;;    ([?\C-v] . next)
  ;;    ([?\C-d] . delete)
  ;;    ([?\C-k] . (S-end delete))
  ;;    ;; cut/paste
  ;;    ([?\C-w] . ?\C-x)
  ;;    ([?\M-w] . ?\C-c)
  ;;    ([?\C-y] . ?\C-v)
  ;;    ;; search
  ;;    ([?\C-f] . ?\C-f)
  ;;    ;; movement
  ;;    ([?\M-h] . return)
  ;;    ([?\M-m] . return)
  ;;    ([?\M-l] . right)
  ;;    ([?\M-k] . down)
  ;;    ([?\M-j] . left)
  ;;    ([?\M-\\] . prior)
  ;;    ([?\M-'] . next)))
  (add-hook 'exwm-manage-finish-hook
            (lambda ()
              (when (and exwm-class-name
                         (string= exwm-class-name "XTerm"))
                (exwm-input-set-local-simulation-keys '(([?\C-c ?\C-c] . ?\C-c))))))
  ;; this little bit will make sure that XF86 keys work in exwm buffers as well
  (dolist (k '(XF86AudioLowerVolume
               XF86AudioRaiseVolume
               XF86PowerOff
               XF86AudioMute
               XF86AudioPlay
               XF86AudioStop
               XF86AudioPrev
               XF86AudioNext
               XF86ScreenSaver
               XF68Back
               XF86Forward
               Scroll_Lock
               print))
    (cl-pushnew k exwm-input-prefix-keys))

  (require 'exwm-randr)
  (setq exwm-randr-workspace-monitor-plist '(0 "HDMI-0" 1 "HDMI-0" 2 "DP-0"  3 "DP-0"  4 "DP-0"  5 "DP-0" 6 "DP-0"  7 "DP-0" 8 "DP-0"  9 "DP-0"  ))
  (add-hook 'exwm-randr-screen-change-hook
            (lambda ()
              (start-process-shell-command
               "xrandr" nil " xrandr --output HDMI-0 --mode 800x600 --pos 4200x1440 --rotate normal --output DP-0 --mode 5120x1440 -r 240 --pos 0x0 --rotate normal --output DP-1 --off --output DP-2 --off --output DP-3 --off --output DP-4 --off --output DP-5 --off")))
  ;; (exwm-randr-enable)
  (exwm-randr-mode)
  ;; this just enables exwm, it started automatically once everything is ready
  (exwm-enable))'
;; (shell-command "picom --config ~/.config/picom.conf -b")

(setq x-no-window-manager t)

;; (use-package desktop-environment
;;   :straight t
;;   :config
;;   (desktop-environment-mode))
(require 'exwm-systemtray)
(exwm-systemtray-mode 1)
(use-package dmenu
  :straight t
  :bind
  ("s-SPC" . 'dmenu))
(use-package dashboard
  :straight t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner "~/.emacs.vanilla.d/img/dashLogo.png")
  (setq dashboard-items '((recents  . 5)
                          (projects . 5)))
  (setq dashboard-banner-logo-title "TAYMACS"))
(use-package sudo-edit
  :straight t
  :bind
  ("s-e" . sudo-edit))
(add-hook 'exwm-update-class-hook
          (lambda ()
            (exwm-workspace-rename-buffer exwm-class-name)))
(add-to-list 'exwm-manage-configurations '((equal exwm-class-name "Slack") managed t))
