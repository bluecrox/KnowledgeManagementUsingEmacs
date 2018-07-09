;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;;包管理器
(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/"))
(package-initialize)

;;解决保存文件（含中文）时提示select coding system的问题
;; C-h C RET
;; M-x describe-current-coding-system
(add-to-list 'file-coding-system-alist '("\\.tex" . utf-8-unix) )
(add-to-list 'file-coding-system-alist '("\\.txt" . utf-8-unix) )
(add-to-list 'file-coding-system-alist '("\\.el" . utf-8-unix) )
(add-to-list 'file-coding-system-alist '("\\.scratch" . utf-8-unix) )
(add-to-list 'file-coding-system-alist '("user_prefs" . utf-8-unix) )
(add-to-list 'process-coding-system-alist '("\\.txt" . utf-8-unix) )
(add-to-list 'network-coding-system-alist '("\\.txt" . utf-8-unix) )

(prefer-coding-system 'utf-8-unix)
(set-default-coding-systems 'utf-8-unix)
(set-terminal-coding-system 'utf-8-unix)
(set-keyboard-coding-system 'utf-8-unix)
(set-selection-coding-system 'utf-8-unix)
(setq-default buffer-file-coding-system 'utf-8-unix)

;; Treat clipboard input as UTF-8 string first; compound text next, etc.
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

;; mnemonic for utf-8 is "U", which is defined in the mule.el
(setq eol-mnemonic-dos ":CRLF")
(setq eol-mnemonic-mac ":CR")
(setq eol-mnemonic-undecided ":?")
(setq eol-mnemonic-unix ":LF")

(defalias 'read-buffer-file-coding-system 'lawlist-read-buffer-file-coding-system)
(defun lawlist-read-buffer-file-coding-system ()
  (let* ((bcss (find-coding-systems-region (point-min) (point-max)))
         (css-table
          (unless (equal bcss '(undecided))
            (append '("dos" "unix" "mac")
                    (delq nil (mapcar (lambda (cs)
                                        (if (memq (coding-system-base cs) bcss)
                                            (symbol-name cs)))
                                      coding-system-list)))))
         (combined-table
          (if css-table
              (completion-table-in-turn css-table coding-system-alist)
            coding-system-alist))
         (auto-cs
          (unless find-file-literally
            (save-excursion
              (save-restriction
                (widen)
                (goto-char (point-min))
                (funcall set-auto-coding-function
                         (or buffer-file-name "") (buffer-size))))))
         (preferred 'utf-8-unix)
         (default 'utf-8-unix)
         (completion-ignore-case t)
         (completion-pcm--delim-wild-regex ; Let "u8" complete to "utf-8".
          (concat completion-pcm--delim-wild-regex
                  "\\|\\([[:alpha:]]\\)[[:digit:]]"))
         (cs (completing-read
              (format "Coding system for saving file (default %s): " default)
              combined-table
              nil t nil 'coding-system-history
              (if default (symbol-name default)))))
    (unless (zerop (length cs)) (intern cs))))

;;解决windows复制粘贴显示乱码的问题
(when (eq system-type 'windows-nt)
(set-next-selection-coding-system 'utf-16-le)
(set-selection-coding-system 'utf-16-le)
(set-clipboard-coding-system 'utf-16-le))

;;解决中文表格不对齐的问题，使用微软雅黑字体
;; Setting English Font 
(set-face-attribute 
'default nil :font "Consolas 11") 
;; Chinese Font 
(dolist (charset '(kana han symbol cjk-misc bopomofo)) 
(set-fontset-font (frame-parameter nil 'font) 
charset 
(font-spec :family "Microsoft Yahei" :size 16)))

(add-to-list 'load-path "~/.emacs.d/my-elisp")
(require 'unicad)
(require 'multi-scratch)

;;启动时最大化窗口
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;;启动不显示欢迎窗口
(setq inhibit-startup-message t)

;;Org-mode
;;按shift键选择
(setq org-support-shift-select t)

;;折叠TODO
(global-set-key (kbd "C-l") 'org-show-todo-tree)

;;不用按完整的yes/no
(fset 'yes-or-no-p 'y-or-n-p)

;;默认目录
(setq default-directory "~/../")

;;暂不备份文件，如果要查看历史修改记录可以借助坚果云
(setq make-backup-files nil)

(defconst emacs-tmp-dir (expand-file-name (format "tmp-dir") "~/.emacs-saves/"))
(setq backup-directory-alist `((".*" . , emacs-tmp-dir)))
(setq auto-save-file-name-transforms `((".*" , emacs-tmp-dir t)))
(setq auto-save-list-file-prefix emacs-tmp-dir)

;;json-mode
(add-to-list 'load-path "~/.emacs.d/elpa/json-mode-0.1")
(require 'json-mode)

;;文件导航器
(add-to-list 'load-path "~/.emacs.d/elpa/treemacs-2.1.1")
(require 'treemacs)
;;F8显示或隐藏treemacs窗口
(global-set-key [f8] 'treemacs)
;;启动Emacs时自动打开treemacs
(run-with-idle-timer 0.2 nil 'treemacs)
;;treemacs启动后按回车自动展开根目录
(run-with-idle-timer 0.5 nil 'treemacs-RET-action)
;;监听文件变更，刷新时间3秒
(treemacs-filewatch-mode t)
(setq treemacs-file-event-delay	3000)
;;按r重命名
;;默认R重命名，r刷新，由于启用filewatch自动刷新模式，所以refresh几乎不用，这里把小写的r重新绑定为rename
(define-key treemacs-mode-map (kbd "r") 'treemacs-rename)
;;按Delete键删除
(define-key treemacs-mode-map [delete] 'treemacs-delete)
;;find text in files
(define-key treemacs-mode-map (kbd "C-f") 'xah-find-text)

;;按Ctrl-TAB切换窗口
(global-set-key [C-tab] 'other-window)
;;避免org-mode对Ctrl-TAB的重定义
(add-hook 'org-mode-hook
          '(lambda ()
             (define-key org-mode-map [C-tab] 'other-window)))

(setq split-height-threshold nil)
(setq split-width-threshold 0)

;;根据不同文件类型自动切换到对应mode
(setq auto-mode-alist
  '(
    ("\\.org$" . org-mode)
    ("\\.txt$" . org-mode)
    ("README\\.md\\'" . gfm-mode)
    ("\\.md\\'" . markdown-mode)
    ("\\.markdown\\'" . markdown-mode)
))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(initial-scratch-message "")
 '(cua-mode t nil (cua-base))
 '(package-selected-packages
   (quote
    (json-mode markdown-mode impatient-mode treemacs neotree))))

;;===============================定制快捷键======================
;;复制粘贴剪切撤销
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;打开文件对话框
(global-set-key (kbd "C-o") 'find-file)
;;模拟鼠标点击，参考：https://stackoverflow.com/questions/26483918/bind-file-open-file-with-gui-dialog-to-c-o-as-global-set-key
(defadvice find-file-read-args (around find-file-read-args-always-use-dialog-box act)
  "Simulate invoking menu item as if by the mouse; see `use-dialog-box'."
  (let ((last-nonmenu-event nil))
     ad-do-it))
     
;;保存
(global-set-key (kbd "C-s") 'save-buffer)

;;查找
(global-set-key (kbd "M-f") 'list-matching-lines)

(global-set-key (kbd "C-f") 'isearch-forward)
(define-key isearch-mode-map (kbd "<left>") 'isearch-repeat-backward)
(define-key isearch-mode-map (kbd "<right>") 'isearch-repeat-forward)
(add-hook 'isearch-mode-hook
          '(lambda ()
             (define-key isearch-mode-map (kbd "C-v") 'isearch-yank-kill)))

(setq default-ext "\"txt\"")
(autoload 'xah-find-text "xah-find" "find replace" t)
(autoload 'xah-find-text-regex "xah-find" "find replace" t)
(autoload 'xah-find-replace-text "xah-find" "find replace" t)
(autoload 'xah-find-replace-text-regex "xah-find" "find replace" t)
(autoload 'xah-find-count "xah-find" "find replace" t)
			 
;;新建Scratch
(global-set-key (kbd "C-n") 'multi-scratch-new)

;;Esc键退出
(global-set-key (kbd "<escape>") 'top-level)
(define-key minibuffer-local-map "<escape>" 'top-level)
(define-key minibuffer-local-ns-map "<escape>" 'top-level)
(define-key minibuffer-local-completion-map "<escape>" 'top-level)
(define-key minibuffer-local-must-match-map "<escape>" 'top-level)
(define-key minibuffer-local-isearch-map "<escape>" 'top-level)