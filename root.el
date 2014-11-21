;;;================================================================================
;;; 言語の設定
;;;================================================================================
(cond ((eq window-system 'w32)
       (load-file (expand-file-name "language-windows.el" emacs-setting-root))) ;;; for windows.
      ((eq window-system 'mac)
       (load-file (expand-file-name "language-mac.el" emacs-setting-root))))    ;;; for mac.

;;;================================================================================
;;; キーバインドの設定．
;;;================================================================================
;;; On
(global-set-key "\C-c\C-c" 'comment-region)
(global-set-key "\C-o"   'occur)
(global-set-key "\C-l"   'goto-line)
(global-set-key (kbd "C-;") 'anything)
(global-set-key "\C-cr"  'org-remember)
(global-set-key "\C-ca"  'org-agenda)
(global-set-key "\C-cl"  'org-store-link)
(global-set-key "\C-cn"  'org-add-note)
(global-set-key "\C-cts" 'org-agenda-clock-in)
(global-set-key "\C-cte" 'org-agenda-clock-out)
(global-set-key "\C-cg" 'anything-imenu)
(global-set-key "\C-xf" 'find-file-at-point)
;;; Off
(global-unset-key "\C-xb") ;;; anything の入り口を C-; にするが、C-b が癖になっているので Off にする


;;;================================================================================
;;; タブ幅の設定
;;;================================================================================
(setq default-tab-width 4)

;;;================================================================================
;;; ChangeLog のユーザ名の指定．
;;;================================================================================
(setq user-full-name "Daisuke Funamoto")
(setq user-mail-address "Daisuke.Funamoto@jp.sony.com")

;;;================================================================================
;;; 折り返しの設定
;;;================================================================================
(set-default 'truncate-lines t)

;;;================================================================================
;;; dired-x
;;;================================================================================
(load "dired-x")
; ディレクトリを先に表示する
(setq ls-lisp-dirs-first t)
; diredでディレクトリのバッファを作らない。
(put 'dired-find-alternate-file 'disabled nil)
(define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file)
(define-key dired-mode-map "a" 'dired-advertised-find-file)

;;;================================================================================
;;; スクロールした時に表示される行数
;;;================================================================================
(setq scroll-step 1)

;;;================================================================================
;;; ビープ音をOff
;;;================================================================================
(setq visible-bell 1)

;;;================================================================================
;;; Windowsみたいに選んだところを消しながらコピーする
;;;================================================================================
(delete-selection-mode 1)

;;;================================================================================
;;; 表示/非表示
;;;================================================================================
(setq inhibit-startup-screen t)   ; スタートアップ
(menu-bar-mode 0)                 ; メニューバー
(tool-bar-mode 0)                 ; ツールバー
(scroll-bar-mode t)               ; スクロールバー

;;;================================================================================
;;; uniquify
;;; 同一ファイル名を分かりやすく表示
;;;================================================================================
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-ignore-buffers-re "*[^*]+*")

;;;
;;; font-lock
;;;
(global-font-lock-mode 1)  ; 全てのファイルが font-lock

;;;
;;; load-path
;;;
(defconst my-elisp-directory (expand-file-name "elisp" emacs-setting-root) "The directory for my elisp file.")
(dolist (dir (let ((dir (expand-file-name my-elisp-directory)))
               (list dir (format "%s%d" dir emacs-major-version))))
  (when (and (stringp dir) (file-directory-p dir))
    (let ((default-directory dir))
      (add-to-list 'load-path default-directory)
      (normal-top-level-add-subdirs-to-load-path))))

;;;
;;; kill-ring 設定
;;;
(defadvice kill-new (around my-kill-ring-disable-text-property activate)
(let ((new (ad-get-arg 0)))
  (set-text-properties 0 (length new) nil new)
  ad-do-it))
(autoload 'browse-kill-ring "browse-kill-ring")
(define-key global-map "\ey" 'browse-kill-ring)


;;;
;;; column 表示
;;;
(column-number-mode 1)

;;;
;;; 改行もdelete
;;;
(setq kill-whole-line t)

;;;
;;; タブ幅を 4 に設定
;;;
(setq-default tab-width 4)

;;;
;;; scratch file を消したときに新しいものを新たに作成する
;;;
(defun my-make-scratch (&optional arg)
  (interactive)
  (progn
    ;; "*scratch*" を作成して buffer-list に放り込む
    (set-buffer (get-buffer-create "*scratch*"))
    (funcall initial-major-mode)
    (erase-buffer)
    (when (and initial-scratch-message (not inhibit-startup-message))
      (insert initial-scratch-message))
    (or arg (progn (setq arg 0)
                   (switch-to-buffer "*scratch*")))
    (cond ((= arg 0) (message "*scratch* is cleared up."))
          ((= arg 1) (message "another *scratch* is created")))))

(defun my-buffer-name-list ()
  (mapcar (function buffer-name) (buffer-list)))

(add-hook 'kill-buffer-query-functions
    ;; *scratch* バッファで kill-buffer したら内容を消去するだけにする
          (function (lambda ()
                      (if (string= "*scratch*" (buffer-name))
                          (progn (my-make-scratch 0) nil)
                        t))))

(add-hook 'after-save-hook
;; *scratch* バッファの内容を保存したら *scratch* バッファを新しく作る
          (function (lambda ()
                      (unless (member "*scratch*" (my-buffer-name-list))
                        (my-make-scratch 1)))))

;;;
;;; 初期フレームの設定
;;;
(if (boundp 'window-system)
    (setq initial-frame-alist
          (append (list
;		   '(foreground-color . "azure3") ;; 文字が白
;                   '(background-color . "black") ;; 背景は黒
;                   '(border-color     . "black")
;                   '(mouse-color      . "white")
;                   '(cursor-color     . "white")
;                   '(background-color . "white") ;; 背景は黒
;                   '(border-color     . "white")
;                   '(mouse-color      . "black")
;                   '(cursor-color     . "black")
;				   '(cursor-type . box) ;
;		    '(width . 240)  ;; ウィンドウ幅
;		    '(height . 68) ;; ウィンドウの高さ
		    '(top . 0)
		    '(left . 0)
                   )
                  initial-frame-alist)))
(setq default-frame-alist initial-frame-alist)

;;;
;;; org 設定
;;;
(setq note-path "note.org")
(require 'org)
(org-remember-insinuate)
(setq org-default-notes-file (expand-file-name "org/memo.org" emacs-setting-root))
(setq org-remember-templates
	  '(("NowHow" ?n "** %^{Head Line} %U\n  %i\n%a\n%?"         "c:/Users/0000126209/Desktop/emacs/setting/org/know_how.org" "Inbox")
		("Todo"   ?t "** TODO %^{BriefDesc} %U\n%i\n%a\n%?"  "c:/Users/0000126209/Desktop/emacs/setting/org/todo.org"     "Inbox")
		("Giji"   ?g "** %U %^{BriefDesc}\n%?"               "c:/Users/0000126209/Desktop/emacs/setting/org/giji.org"     "Inbox")
		("Memo"   ?m "** %^{Head Line} %U\n%i\n%a\n%?"       "c:/Users/0000126209/Desktop/emacs/setting/org/memo.org"     "Inbox")))
(setq org-agenda-files (list
						"c:/Users/0000126209/Desktop/emacs/setting/org/know_how.org"
						"c:/Users/0000126209/Desktop/emacs/setting/org/todo.org"
						"c:/Users/0000126209/Desktop/emacs/setting/org/giji.org"
						"c:/Users/0000126209/Desktop/emacs/setting/org/memo.org"))

;;;================================================================================
;;; プログラミング
;;;================================================================================
;;;
;;; スタイル。
;;;
(setq-default indent-tabs-mode nil)
(add-hook 'c++-mode-hook
          '(lambda ()
             (setq tab-width 4)
             (setq c-basic-offset 4)
             (setq c++-auto-newline nil)
             (setq c++-tab-always-indent t)
             (c-set-offset 'access-label '-)
             ;;;
             ;;; 設定すると意図通りにならないので設定しない
             ;;;
;             (c-set-offset 'arglist-close 0)
;             (c-set-offset 'arglist-cont  0)
;             (c-set-offset 'arglist-cont-nonempty 0)
;             (c-set-offset 'arglist-intro 0)
             (c-set-offset 'block-close 0)
             (c-set-offset 'block-open 0)
             (c-set-offset 'brace-entry-open 0)
             (c-set-offset 'brace-list-close 0)
             (c-set-offset 'brace-list-entry 0)
             (c-set-offset 'brace-list-intro '+)
             (c-set-offset 'brace-list-open 0)
             (c-set-offset 'c 1)
             (c-set-offset 'case-label '+)
             (c-set-offset 'catch-clause 0)
             (c-set-offset 'class-close 0)
             (c-set-offset 'class-open 0)
             (c-set-offset 'comment-intro 0)
             (c-set-offset 'cpp-macro -128)
             (c-set-offset 'cpp-macro-cont 4)
             (c-set-offset 'defun-block-intro '+)
             (c-set-offset 'defun-close 0)
             (c-set-offset 'defun-open 0)
             (c-set-offset 'do-while-closure 0)
             (c-set-offset 'else-clause 0)
             (c-set-offset 'extern-lang-close 0)
             (c-set-offset 'extern-lang-open 0)
             (c-set-offset 'friend 0)
             (c-set-offset 'func-decl-cont 0)
             (c-set-offset 'inclass '+)
             (c-set-offset 'inextern-lang 0)
             (c-set-offset 'inher-cont 0)
             (c-set-offset 'inher-intro 0)
             (c-set-offset 'inline-close 0)
             (c-set-offset 'inline-open 0)
             (c-set-offset 'innamespace 0)
             (c-set-offset 'label 0)
             (c-set-offset 'member-init-cont 0)
             (c-set-offset 'member-init-intro '+)
             (c-set-offset 'namespace-close 0)
             (c-set-offset 'namespace-open 0)
             (c-set-offset 'statement 0)
             (c-set-offset 'statement-block-intro '+)
             (c-set-offset 'statement-case-intro 0)
             (c-set-offset 'statement-case-open 0)
             (c-set-offset 'statement-cont '+)
             (c-set-offset 'stream-op 0)
             (c-set-offset 'string 0)
             (c-set-offset 'substatement 0)
             (c-set-offset 'substatement-open 0)
             (c-set-offset 'template-args-cont 0)
             (c-set-offset 'topmost-intro 0)
             (c-set-offset 'topmost-intro-cont 0)
             ))

;;;
;;; #ディレクティブの補完。
;;;
(add-hook 'c-mode-common-hook
          (function (lambda ()
                      (require 'cpp-complt)
                      (define-key c-mode-map "#"
                        'cpp-complt-instruction-completing)
                      (define-key c-mode-map "\C-c#"
                        'cpp-complt-ifdef-region)
                      (define-key c++-mode-map "#"
                        'cpp-complt-instruction-completing)
                      (define-key c++-mode-map "\C-c#"
                        'cpp-complt-ifdef-region)
                      (cpp-complt-init))))
; 標準ヘッダのサーチパス。
(setq cpp-complt-standard-header-path
      '(
        "c:/cygwin/lib/gcc/i686-pc-cygwin/4.5.3/include"
        "c:/cygwin/lib/gcc/i686-pc-cygwin/4.5.3/include/c++"
		"c:/cygwin/usr/include"
        ))

;;;
;;; バックスペースの設定。
;;;
(setq backward-delete-char-untabify-method 'hungry)
(setq backward-delete-char-untabify-method 'all)

;;;
;;; 無駄な空白、タブ、を赤字で表示
;;;
(setq-default show-trailing-whitespace t)

;;;
;;; gtags設定
;;;
(autoload 'gtags-mode "gtags" "" t)
(setq gtags-mode-hook
      '(lambda ()
         (local-set-key "\C-ctd" 'gtags-find-tag)
         (local-set-key "\C-ctr" 'gtags-find-rtag)
         (local-set-key "\C-ctu" 'gtags-find-symbol)
         (local-set-key "\C-ctt" 'gtags-pop-stack)
         ))
(setq gtags-select-mode-hook
      '(lambda ()
         (local-set-key "\C-ctt" 'gtags-pop-stack)
         ))
; C、C++ モードで自動で読み込むようにしよう。
; C用
(add-hook 'c-mode-common-hook
          '(lambda()
             (gtags-mode 1)
             (gtags-make-complete-list)
             ))
; C++用
(add-hook 'c++-mode-common-hook
          '(lambda()
             (gtags-mode 1)
             (gtags-make-complete-list)
             ))


;;;
;;; .h <-> .cpp切り替え
;;;
(require 'toggle-source)

;;;
;;; 括弧の対に飛ぶ
;;;
(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))
(global-set-key "\C-ce" 'match-paren)

;;;
;;; 括弧の対をハイライト
;;;
(show-paren-mode t)
(setq show-paren-style 'mixed)
(set-face-background 'show-paren-match-face "dodger blue")
(set-face-foreground 'show-paren-match-face "light cyan")
(setq show-paren-style 'expression)


;;;
;;; shellとしてbashを使用する
;;;
(setq explicit-shell-file-name "bash")
(setq shell-file-name "sh")
(setq shell-command-switch "-c")
(modify-coding-system-alist 'process ".*sh\\.exe" '(undecided-dos . euc-japan))

;;;
;;; /cygdrive/c/をc:/に置き換える
;;; gdbとかを使用する場合に必要
;;;
(defadvice expand-file-name (before strip-cygdrive (NAME &optional DEFAULT-DIRECTORY) activate)
"replace /cygdrive/x to x: in path string." ;; コマンドのコメント．
(if (string-match "^/cygdrive/\\([a-zA-Z]\\)/" NAME)
(setq NAME (replace-match "\\1:/" nil nil NAME))))

;;;
;;; .hをC++Modeで開く
;;;
(setq auto-mode-alist
      (append '(("\\.h$" . c++-mode))
              auto-mode-alist))

;;;
;;; moccur.
;;; 1. M-x moccur-grep-find
;;; 2. ディレクトリ指定
;;; 3. パターンとファイルマスクを指定 (ex. Input Regexp and FileMask: xxxx \.cpp$\|\.hpp$)
;;; 4. rでエディット状態へ
;;; 5. 好きに編集
;;; 6. C-x C-sで変更を実行
;;; 7. C-u C-x sで全てのバッファーを保存
;;;
(require 'color-moccur)
(require 'moccur-edit)

;;;
;;; grepなどで、関数をたくさん呼ぶと
;;; Lisp nesting exceeds max-lisp-eval-depth
;;; というメッセージが出る。
;;; 関数呼び出し回数を制限しているようなので、その制限を上げる
;;;
(setq max-lisp-eval-depth 1000)

;;;
;;; キーボードマクロファイルのリード
;;;
(load-file (expand-file-name "kbdmacro/kbdmacro.el" emacs-setting-root))

;;;
;;; javascript mode
;;;
(load-file (expand-file-name "elisp/js2-mode/js2-20090723b.elc" emacs-setting-root))
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;;;
;;; ejacs
;;;
(autoload 'js-console "js-console" nil t)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;;;
;;; auto-install
;;;
(add-to-list 'load-path (expand-file-name "auto-install/" emacs-setting-root))
(when(require 'auto-install nil t)
  ;;インストールディレクトリを設定する　初期値は~/.emacs.d/auto-install/
  (setq auto-install-directory (expand-file-name "auto-install/" emacs-setting-root))
  ;;EmacsWikiに登録されているelispの名前を取得する
  (auto-install-update-emacswiki-package-name t)
  ;;必要であればプロキシの設定を行う
  ;;(setq url-proxy-services '(("http" . "localhost:8339")))
  ;;install-elispの関数を利用可能にする
  (auto-install-compatibility-setup)
  (setq ediff-window-setup-function 'ediff-setup-windows-plain))


;;;================================================================================
;;; 最近開いたファイルの履歴を覚えておく
;;; - リンク切れたファイルがあると固まるので設定しないでおく
;;;================================================================================
;(setq recentf-max-saved-items 500)
;(recentf-mode 1)

;;;================================================================================
;;; anything
;;;================================================================================
(require 'anything-startup)
(setq anything-sources
      '(anything-c-source-buffers
        anything-c-source-files-in-current-dir
        anything-c-source-buffer-not-found
        anything-c-source-recentf
        anything-c-source-emacs-commands
        anything-c-source-imenu
        ))


;;;
;;; migemo
;;; ローマ字のまま日本語をインクリメンタルサーチする
;;; ruby が必要
;;;
;(require 'migemo)

;;;================================================================================
;;; 使い道がないもの群
;;;================================================================================
;;;
;;; zshのような補完候補表示
;;;
; (require 'zlc)
; (let ((map minibuffer-local-map))
;   ;;; like menu select
;   (define-key map (kbd "<down>")  'zlc-select-next-vertical)
;   (define-key map (kbd "<up>")    'zlc-select-previous-vertical)
;   (define-key map (kbd "<right>") 'zlc-select-next)
;   (define-key map (kbd "<left>")  'zlc-select-previous)
;   ;;; reset selection
;   (define-key map (kbd "C-c") 'zlc-reset)
;   )

;;;
;;; ffap
;;; カーソルにあるS式をデフォルトの URL として C-xC-f できる
;;; 例えば、https://www.google.co.jp にカーソルを合わせて、C-xC-fとすると、
;;; 初期値を https://www.google.co.jp として、入れることができる。
;;;
; (ffap-bindings)
