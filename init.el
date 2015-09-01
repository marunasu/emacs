; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-
;; ------------------------------------------------------------------------
;; @ load-path

;; load-pathの追加関数
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

;; load-pathに追加するフォルダ
;; 2つ以上フォルダを指定する場合の引数 => (add-to-load-path "elisp" "xxx" "xxx")
(add-to-load-path "elisp")

;; ------------------------------------------------------------------------
;; @ general

;; common lisp
(require 'cl)

;; 文字コード
(set-language-environment "Japanese")
(let ((ws window-system))
  (cond ((eq ws 'w32)
         (prefer-coding-system 'utf-8-unix)
         (set-default-coding-systems 'utf-8-unix)
         (setq file-name-coding-system 'sjis)
         (setq locale-coding-system 'utf-8))
        ((eq ws 'ns)
         (require 'ucs-normalize)
         (prefer-coding-system 'utf-8-hfs)
         (setq file-name-coding-system 'utf-8-hfs)
         (setq locale-coding-system 'utf-8-hfs))))


;; Windowsで英数と日本語にMeiryoを指定
;; Macで英数と日本語にRictyを指定
(let ((ws window-system))
  (cond ((eq ws 'w32)
         (set-face-attribute 'default nil
           :family "MeiryoKe_Gothic"  ;; 英数
           :height 100)
        (set-fontset-font nil 'japanese-jisx0208
           (font-spec :family "MeiryoKe_Gothic")))  ;; 日本語
        ((eq ws 'ns)
        (set-face-attribute 'default nil
           :family "Ricty"  ;; 英数
           :height 140)
        (set-fontset-font nil 'japanese-jisx0208
           (font-spec :family "Ricty")))))  ;; 日本語

;; encording
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)

;; スタートアップ非表示
(setq inhibit-startup-screen t)

;; scratchの初期メッセージ消去
(setq initial-scratch-message "")

;; ツールバー非表示
(tool-bar-mode -1)

;; メニューバーを非表示
(menu-bar-mode -1)

;; スクロールバー非表示
(set-scroll-bar-mode nil)

;; タイトルバーにファイルのフルパス表示
(setq frame-title-format
      (format "%%f - Emacs@%s" (system-name)))

;; 行番号表示
(global-linum-mode t)
(set-face-attribute 'linum nil
                    :foreground "#bf616a"
                    :height 0.9)

;; 行番号フォーマット
(setq linum-format "%4d")

;; 括弧の範囲内を強調表示
(show-paren-mode t)
(setq show-paren-delay 0)
(setq show-paren-style 'expression)

;; 括弧の範囲色
(set-face-background 'show-paren-match-face "#1ABC9C")

;; 選択領域の色
(set-face-background 'region "#555")

;; 行末の空白を強調表示
(setq-default show-trailing-whitespace t)
(set-face-background 'trailing-whitespace "#b14770")

;; タブをスペースで扱う
(setq-default indent-tabs-mode nil)

;; タブ幅
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" default)))
 '(safe-local-variable-values (quote ((eval if (boundp (quote rainbow-mode)) (rainbow-mode)))))
 '(tab-width 4))

;; yes or noをy or n
(fset 'yes-or-no-p 'y-or-n-p)

;; 最近使ったファイルをメニューに表示
(recentf-mode t)

;; 最近使ったファイルの表示数
(setq recentf-max-menu-items 10)

;; 最近開いたファイルの保存数を増やす
(setq recentf-max-saved-items 3000)

;; ミニバッファの履歴を保存する
(savehist-mode 1)

;; ミニバッファの履歴の保存数を増やす
(setq history-length 3000)

;; バックアップを残さない
(setq make-backup-files nil)

;; 行間
(setq-default line-spacing 0)

;; 1行ずつスクロール
(setq scroll-conservatively 35
      scroll-margin 0
      scroll-step 1)
(setq comint-scroll-show-maximum-output t) ;; shell-mode

;; ウィンドウサイズ
;(set-frame-parameter nil 'fullscreen 'fullboth)

;;; 新規フレームのデフォルト設定
(setq default-frame-alist
      (append
       '((top                 . 0)    ; フレームの Y 位置(ピクセル数)
         (left                . 1002)  ; フレームの X 位置(ピクセル数)
         (width               . 96)    ; フレーム幅(文字数)
         (height              . 55))   ; フレーム高(文字数)
       default-frame-alist))

;; フレームの透明度
(set-frame-parameter (selected-frame) 'alpha '(1.0))

;; ------------------------------------------------------------------------
;; @ modeline

;; モードラインに行番号表示
(line-number-mode t)

;; モードラインに列番号表示
(column-number-mode t)

;; モードラインの割合表示を総行数表示
(defvar my-lines-page-mode t)
(defvar my-mode-line-format)

(when my-lines-page-mode
  (setq my-mode-line-format "%d")
  (if size-indication-mode
      (setq my-mode-line-format (concat my-mode-line-format " of %%I")))
  (cond ((and (eq line-number-mode t) (eq column-number-mode t))
         (setq my-mode-line-format (concat my-mode-line-format " (%%l,%%c)")))
        ((eq line-number-mode t)
         (setq my-mode-line-format (concat my-mode-line-format " L%%l")))
        ((eq column-number-mode t)
         (setq my-mode-line-format (concat my-mode-line-format " C%%c"))))

  (setq mode-line-position
        '(:eval (format my-mode-line-format
                        (count-lines (point-max) (point-min))))))

;; ------------------------------------------------------------------------
;; @ initial frame maximize

;; 起動時にウィンドウ最大化
;; http://www.emacswiki.org/emacs/FullScreen#toc12
(defun jbr-init ()
  "Called from term-setup-hook after the default
   terminal setup is
   done or directly from startup if term-setup-hook not
   used.  The value
   0xF030 is the command for maximizing a window."
  (interactive)
  (w32-send-sys-command #xf030)
  (ecb-redraw-layout)
  (calendar))

(let ((ws window-system))
  (cond ((eq ws 'w32)
         (set-frame-position (selected-frame) 0 0)
         (setq term-setup-hook 'jbr-init)
         (setq window-setup-hook 'jbr-init))
        ((eq ws 'ns)
         ;; for MacBook Air(Late2010) 11inch display
         (set-frame-position (selected-frame) 0 0)
         (set-frame-size (selected-frame) 95 47))))

;; ------------------------------------------------------------------------
;; @  color-theme.el

;; Emacsのカラーテーマ
;; http://code.google.com/p/gnuemacscolorthemetest/
(when (and (require 'color-theme nil t) (window-system))
  (color-theme-initialize)
  (color-theme-clarity))

;(when (and (require 'color-theme-solarized nil t) (window-system))
;  (color-theme-initialize)
;  (color-theme-solarized)
;(add-hook 'after-make-frame-functions
;          (lambda (frame)
;            (let ((mode (if (display-graphic-p frame) 'light 'dark)))
;              (set-frame-parameter frame 'background-mode mode)
;              (set-terminal-parameter frame 'background-mode mode))
;            (enable-theme 'solarized)))
;)


;;; カスタムテーマのロード
;(setq custom-theme-directory "~/.emacs.d/elisp/theme/")
;(load-theme 'FlatUI t)
;; zenburn-theme
;(load-theme 'hc-zenburn t)

;; ------------------------------------------------------------------------
;; @ whitespace

(global-whitespace-mode 1)
(setq whitespace-space-regexp "\\(\u3000\\)")
(setq whitespace-style '(face tabs tab-mark spaces space-mark))
(setq whitespace-display-mappings ())
(set-face-foreground 'whitespace-tab "#F1C40F")
(set-face-background 'whitespace-space "#E74C3C")

;; -------------------------------------------------------------------------
;; C-h is backspace
(global-set-key "\C-h" 'delete-backward-char)
;; C-xf is recentf-open-files
(global-set-key "\C-xf" 'recentf-open-files)

;; -------------------------------------------------------------------------
;;; package.el
(require 'package)

;; MELPAを追加
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))

;; Marmaladeを追加
(add-to-list 'package-archives  '("marmalade" . "http://marmalade-repo.org/packages/"))

;; 初期化
(package-initialize)

;; ------------------------------------------------------------------------
;; @ autocomplete.el
(require 'auto-complete)
(require 'auto-complete-config)
(global-auto-complete-mode t)

(define-key ac-completing-map (kbd "C-n") 'ac-next)
(define-key ac-completing-map (kbd "C-p") 'ac-previous)
(define-key ac-completing-map (kbd "C-m") 'ac-complete)

;; ------------------------------------------------------------------------
;; @ auto-install.el

;; パッケージのインストールを自動化
;; http://www.emacswiki.org/emacs/auto-install.el
(when (require 'auto-install nil t)
  (setq auto-install-directory "~/.emacs.d/elisp/")
  (auto-install-update-emacswiki-package-name t)
  (auto-install-compatibility-setup))
;; パッケージのインストールを自動化
;; http://www.emacswiki.org/emacs/auto-install.el
(when (require 'auto-install nil t)
  (setq auto-install-directory "~/.emacs.d/elisp/")
  (auto-install-update-emacswiki-package-name t)
  (auto-install-compatibility-setup))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; ------------------------------------------------------------------------
;; @ redo+.el

;; redoできるようにする
;; http://www.emacswiki.org/emacs/redo+.el
(when (require 'redo+ nil t)
  (define-key global-map (kbd "C-_") 'redo))

;; ------------------------------------------------------------------------
;; @ emacs-init-check

;; チェックしてエラーが出ない場合は「emacs-init-check exited normally.」と出るだけ
(require 'emacs-init-check)
;; 以下のディレクトリにあるファイルのみ有効にする
(setq auto-emacs-init-check-file-regexp ""/\\.emacs\\.d/"")
;; unixならばniceコマンドがあるので、ゆったりと動作させる
(add-to-list 'auto-emacs-init-check-program-args "nice")
;; VCにコミットされたときに自動でチェック
(add-hook 'vc-checkin-hook 'auto-emacs-init-check)

;;auto-async-byte-compile
;(require 'auto-async-byte-compile)
;(setq auto-async-byte-compile-exclude-files-regexp "/junk/")
;(add-hook 'emacs-lisp-mode-hook 'enable-auto-async-byte-compile-mode)

;; auto-complete
(require 'auto-complete-config)
(global-auto-complete-mode 1)
(defun emacs-lisp-ac-setup()
  (setq ac-sources '(ac-source-words-in-same-mode-buffers ac-source-symbols)))
(add-hook 'emacs-lisp-mode-hook 'emacs-lisp-ac-setup)

;; ruby environment
(electric-pair-mode t)
(add-to-list 'electric-pair-pairs '(?| . ?|))

;; ruby-mode
(autoload 'ruby-mode "ruby-mode"
  "Mode for editing ruby source files" t)
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Capfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile$" . ruby-mode))
(add-hook 'ruby-mode-hook
          '(lambda ()
             (setq tab-width 2)
             (setq ruby-indent-level tab-width)
             (setq ruby-deep-indent-paren-style nil)
             (define-key ruby-mode-map [return] 'reindent-then-newline-and-indent)))

;; ruby-block
(require 'ruby-block)
(ruby-block-mode t)
(setq ruby-block-highlight-toggle t)


;; direx
(when (require 'direx nil t)
  (global-set-key (kbd "C-x C-j") 'direx:jump-to-directory))

;; popwin
;(setq display-buffer-function 'popwin:display-buffer)
;; direx:direx-modeのバッファをウィンドウ左辺に幅25でポップアップ
;; :dedicatedにtを指定することで、direxウィンドウ内でのバッファの切り替えが
;; ポップアップ前のウィンドウに移譲される
(when (require 'popwin nil t)
  (push '(direx:direx-mode :position left :width 25 :dedicated t)
      popwin:special-display-config))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; web mode
;; http://web-mode.org/
;; http://yanmoo.blogspot.jp/2013/06/html5web-mode.html
(require 'web-mode)

;;; 適用する拡張子
(add-to-list 'auto-mode-alist '("\\.phtml$"     . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x$"   . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?$"     . web-mode))

;;; インデント数
(defun web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-html-offset   2)
  (setq web-mode-css-offset    2)
  (setq web-mode-script-offset 2)
  (setq web-mode-php-offset    2)
  (setq web-mode-java-offset   2)
  (setq web-mode-asp-offset    2))
(add-hook 'web-mode-hook 'web-mode-hook)

;; 色の設定
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(web-mode-comment-face ((t (:foreground "#D9333F"))))
 '(web-mode-css-at-rule-face ((t (:foreground "#FF7F00"))))
 '(web-mode-css-pseudo-class-face ((t (:foreground "#FF7F00"))))
 '(web-mode-css-rule-face ((t (:foreground "#A0D8EF"))))
 '(web-mode-doctype-face ((t (:foreground "#82AE46"))))
 '(web-mode-html-attr-name-face ((t (:foreground "#C97586"))))
 '(web-mode-html-attr-value-face ((t (:foreground "#82AE46"))))
 '(web-mode-html-tag-face ((t (:foreground "#E6B422" :weight bold))))
 '(web-mode-server-comment-face ((t (:foreground "#D9333F")))))

;;;
;;; mode-line full path show 5sec
;;; http://yak-shaver.blogspot.jp/2013/04/blog-post.html
;;;
(defvar mode-line-buffer-fullpath
  (list 'buffer-file-name
        (propertized-buffer-identification "%12f")
        (propertized-buffer-identification "%12b")))

(add-hook 'dired-mode-hook
          (lambda ()
            ;; TODO: handle (DIRECTORY FILE ...) list value for dired-directory
            (setq mode-line-buffer-identification
                  ;; emulate "%17b" (see dired-mode):
                  '(:eval
                    (propertized-buffer-identification
                     (if (< (length default-directory) 17)
                         (concat default-directory
                                 (make-string (- 17 (length default-directory))
                                              ?\s))
                       default-directory))))))

(setq  mode-line-buffer-default mode-line-buffer-identification)

(defun show-mode-line-fullpath (event)
  (interactive "e")
  (when (buffer-file-name)
    (select-window (posn-window (event-start event))) ; activate window
    (let ((wait-sec 5))
      (setq mode-line-buffer-identification mode-line-buffer-fullpath)
      (force-mode-line-update)
      (my-copy-buffer-file-name)                      ; copy path string to killring
      (sit-for wait-sec)
      (setq mode-line-buffer-identification mode-line-buffer-default)
      (force-mode-line-update)
      (message ""))))

(define-key mode-line-buffer-identification-keymap [mode-line mouse-1] 'show-mode-line-fullpath) ; left click
(set-face-attribute 'mode-line-highlight nil :box nil) ; remove box when hover mouse

(defun my-copy-buffer-file-name ()
  "copy buffer-file-name to kill-ring."
  (interactive)
  (let ((fn (unwind-protect
                (buffer-file-name)
              nil)))
    (if fn
        (let ((f (abbreviate-file-name (expand-file-name fn))))
          (kill-new f)
          (message "copied: \"%s\"" f))
      (message "no file name"))))

;;window save freme
(defconst my-save-frame-file
  "~/.emacs.d/.framesize"
  "フレームの位置、大きさを保存するファイルのパス")
(defun my-save-frame-size()
  "現在のフレームの位置、大きさを`my-save-frame-file'に保存します"
  (interactive)
  (let* ((param (frame-parameters (selected-frame)))
         (current-height (frame-height))
         (current-width (frame-width))
         (current-top-margin (if (integerp (cdr (assoc 'top param)))
                                 (cdr (assoc 'top param))
                                 0))
         (current-left-margin (if (integerp (cdr (assoc 'left param)))
                                  (cdr (assoc 'left param))
                                  0))
         (buf nil)
         (file my-save-frame-file)
         )
    ;; ファイルと関連付けられたバッファ作成
    (unless (setq buf (get-file-buffer (expand-file-name file)))
      (setq buf (find-file-noselect (expand-file-name file))))
    (set-buffer buf)
    (erase-buffer)
    ;; ファイル読み込み時に直接評価させる内容を記述
    (insert
     (concat
      "(set-frame-size (selected-frame) "(int-to-string current-width)" "(int-to-string current-height)")\n"
      "(set-frame-position (selected-frame) "(int-to-string current-left-margin)" "(int-to-string current-top-margin)")\n"
      ))
    (save-buffer)))
(defun my-load-frame-size()
  "`my-save-frame-file'に保存されたフレームの位置、大きさを復元します"
  (interactive)
  (let ((file my-save-frame-file))
    (when (file-exists-p file)
        (load-file file))))

(add-hook 'emacs-startup-hook 'my-load-frame-size)
(add-hook 'kill-emacs-hook 'my-save-frame-size)
(run-with-idle-timer 60 t 'my-save-frame-size)


;; php-mode
(require 'php-mode)

;; ffap
(ffap-bindings)

;; iswitchb
(iswitchb-mode 1)
(setq read-buffer-function 'iswitchb-read-buffer)
(setq iswitchb-regexp nil)
(setq iswitchb-prompt-newbuffer nil)

;; bookmark.el
(setq bookmark-save-flag 1)
(progn
  (setq bookmark-sort-flag nil)
  (defun bookmark-arrange-latest-top ()
    (let ((latest (bookmark-get-bookmark bookmark)))
      (setq bookmark-alist (cons latest (delq latest bookmark-alist))))
    (bookmark-save))
  (add-hook 'bookmark-after-jump-hook 'bookmark-arrange-latest-top))

;; igrep.el
(require 'igrep)
(igrep-define lgrep (igrep-use-zgrep nil)(igrep-regex-option "-n -0u8"))
(igrep-find-define lgrep (igrep-use-zgrep nil)(igrep-regex-option "-n -0u8"))

(require 'f)
