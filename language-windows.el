;;;
;;; coding-system の設定
;;;
(set-language-environment "Japanese")
(set-terminal-coding-system 'utf-8-unix)
(set-keyboard-coding-system 'utf-8-unix)
(set-buffer-file-coding-system 'utf-8-unix)
(setq default-buffer-file-coding-system 'utf-8-unix)
(set-default-coding-systems 'utf-8-unix)
(setq default-file-name-coding-system 'shift_jis) ;; dired-x でファイル名の文字化け対処


;;;
;;; 日本語の設定
;;;
(setq default-input-method "W32-IME")
(setq-default w32-ime-mode-line-state-indicator "[--]")                 ;; インジケーター設定
(setq w32-ime-mode-line-state-indicator-list '("[--]" "[あ]" "[--]"))   ;; インジケーター設定
(setq ime-activate-cursor-color   "#00a000")                            ;; カーソル色設定
(setq ime-inactivate-cursor-color "#000000")                            ;; カーソル色設定
(set-cursor-color ime-inactivate-cursor-color)                          ;; カーソル色設定
(add-hook 'w32-ime-on-hook 												;; カーソル色設定
          (function (lambda () 											;; カーソル色設定
                      (set-cursor-color ime-activate-cursor-color)))) 	;; カーソル色設定
(add-hook 'w32-ime-off-hook 											;; カーソル色設定
          (function (lambda () 											;; カーソル色設定
                      (set-cursor-color ime-inactivate-cursor-color)))) ;; カーソル色設定
(w32-ime-initialize)

;;;
;;; font の設定
;;;
(set-default-font "Ricty-13.5") ; 半角:全角が1:2になるのは、限られている
