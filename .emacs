;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; EMACS Init File

; first things first, load our c-x, c-c, c-v settings
; load windows keyboard shortcuts
(load-file "~/.emacs_init/cua.el")
(CUA-mode t)

;===========================================================
;;;;;;;;;;;;;;;;;
; Normal emacs stuff

;; Set up the keyboard so the delete key on both the regular keyboard
;; and the keypad delete the character under the cursor and to the right
;; under X, instead of the default, backspace behavior.
(global-set-key [delete] 'delete-char)
(global-set-key [kp-delete] 'delete-char)
; some other nice features
(global-set-key "\C-x\C-e" 'revert-buffer)
(global-set-key "\C-x\C-b" 'electric-buffer-list)
(global-set-key "\C-z" 'undo)

; key bindings for the function keys
(global-set-key [f1] 'goto-line)
(global-set-key [f3] 'shell)
(global-set-key [f8] 'ispell)

; Create Header Guards with f12
(global-set-key [f12] 
 '(lambda () 
  (interactive)
  (if (buffer-file-name)
   (let*
    ((fName (upcase (file-name-nondirectory (file-name-sans-extension buffer-file-name))))
     (ifDef (concat "#ifndef " fName "_H" "\n#define " fName "_H" "\n"))
     (begin (point-marker))
    )
    (progn
     ;Insert the Header Guard
     (goto-char (point-min))
     (next-line 1)
     (insert ifDef)
     (goto-char (point-max))
     (insert "\n#endif" " //" fName "_H")
     (goto-char begin))
    )
   ;else
   (message (concat "Buffer " (buffer-name) " must have a filename"))
  )
 )
)

(global-font-lock-mode t)            ; turn on font-lock mode
(set-scroll-bar-mode 'right)         ; scroll bar on the right
(setq next-line-add-newlines nil)    ; stop at the end of the file, not just add lines
(setq scroll-step 1)                 ; scroll by 1 line at a time
(setq inhibit-startup-message   t)   ; Don't want any startup message
(setq make-backup-files         nil) ; Don't want any backup files
(setq auto-save-list-file-name  nil) ; Don't want any .saves files
(setq auto-save-default         nil) ; Don't want any auto saving 
(setq minibuffer-max-depth nil)      ; no limit on minibuffer

; retitle emacs window
(setq frame-title-format "%b")
;(setq frame-title-format '("Emacs @ " system-name ": %b %+%+ %f"))
;(setq frame-title-format (concat invocation-name "@" system-name ": %b %+%+ %f"))

;===========================================================

; Screen Properties
(set-foreground-color "white")       ; to set foreground color to white
(set-background-color "black")       ; to set background color to black
(set-cursor-color "green")           ; Set cursor color
(set-mouse-color "white")            ; Set mouse color

;(setq default-frame-alist (append (list
;  '(width  . 200)  ; Width set to 81 characters
;  '(height . 69)   ; Height set to 60 lines
;  '(left . 0)     ; start 10 pixels from left 
;  '(top . 0))	   ; start 10 from the top
;  default-frame-alist))

;===========================================================

; set up keys for moving to matching parenthesis
(defun go-matching-paren ()
  "Move cursor to the matching parenthesis."
  (interactive)
  (cond ((looking-at "[[({]") (forward-sexp 1))
        ((save-excursion
           (backward-char 1)
           (looking-at "[])}]")) (backward-sexp 1))
        (t (ding) (message "Unbalanced parenthesis"))))

(defun show-matching-paren ()
  "Move cursor momentarily to the matching parenthesis."
  (interactive)
  (save-excursion
    (cond ((looking-at "[[({]") (forward-sexp 1) (sit-for 1))
          ((save-excursion
             (backward-char 1)
             (looking-at "[])}]")) (backward-sexp 1) (sit-for 1))
          (t (ding) (message "Unbalanced parenthesis")))))

; define keys used for moving between sides of the parenthesis
(define-key global-map "\C-xg" 'go-matching-paren)
(define-key global-map "\C-xs" 'show-matching-paren)

;===========================================================

; Function Collapsing
;(add-hook 'c-mode-hook 'doxymacs-mode)
(add-hook 'c-mode-hook
          (function (lambda ()
                      (outline-minor-mode)
                      (hide-other))))

;(add-hook 'c++-mode-hook 'doxymacs-mode)
(add-hook 'c++-mode-hook
          (function (lambda ()
                      (outline-minor-mode)
                      (hide-other))))

(global-set-key [(meta button5)] 'show-subtree)
(global-set-key [(meta \])] 'show-subtree)
(global-set-key [(meta button4)] 'hide-subtree)
(global-set-key [(meta \[)] 'hide-subtree)

(global-set-key [f9] '(lambda () (interactive)
                        (show-all)
                        (outline-minor-mode)
                        (hide-other)
                        (font-lock-mode)
                        (font-lock-mode)))


;===========================================================
;   File Headers
;===========================================================

(require 'autoinsert)
(auto-insert-mode)                               ;;; Adds hook to find-files-hook
(setq auto-insert-directory "~/.mytemplates/")   ;;; Or use custom, *NOTE* Trailing slash important
(setq auto-insert-query nil)                     ;;; If you don't want to be prompted before insertion
;; FIXME - insert headers for more types here
(define-auto-insert "\.c" "autoinsert.c")
(define-auto-insert "\.cc" "autoinsert.cc")
(define-auto-insert "\.cpp" "autoinsert.cc")
(define-auto-insert "\.h" "autoinsert.h")
(define-auto-insert "\.tw" "autoinsert.h")
(define-auto-insert "\.pl" "autoinsert.pl")
(define-auto-insert "\.cfg" "autoinsert.cfg")

;===========================================================

; File Startup Modes
(defun prepend-path ( my-path )
(setq load-path (cons (expand-file-name my-path) load-path)))    
(defun append-path ( my-path )
(setq load-path (append load-path (list (expand-file-name my-path)))))

(setq auto-mode-alist  
      (append (list
	       ;; tw files are testbuilder header files so really c++
	       (cons "\\.tw\\'" 'c++-mode)
	       ;; Any files that end in .v, .sv, .vh, et cetera should be in verilog mode
               (cons "\\.v\\'" 'verilog-mode)
               (cons "\\.sv\\'" 'verilog-mode)
               (cons "\\.vh\\'" 'verilog-mode)
	       (cons "\\.svh\\'" 'verilog-mode)
	       ;; Any files that end in .e, .e3, et cetera should be in specman mode
               (cons "\\.e\\'" 'specman-mode)
               (cons "\\.e3\\'" 'specman-mode)
               (cons "\\.load\\'" 'specman-mode)
               (cons "\\.ecom\\'" 'specman-mode)
               (cons "\\.etst\\'" 'specman-mode)
	       ;; Any files that end in .tcl, .tk, et cetera should be in tcl mode
               (cons "\\.tcl\\'" 'tcl-mode)
               (cons "\\.tk\\'" 'tcl-mode))
              auto-mode-alist))

;===========================================================
; Specman Mode  ============================================
;===========================================================

;; Look first in the directory ~/elisp for elisp files
(prepend-path "/import/DV_shared/editors/emacs/elisp")
;; Load specman mode only when needed
(autoload 'specman-mode "specman-mode" "Specman mode" t )
;; Any files in specman mode should have their keywords colorized
(add-hook 'specman-mode-hook '(lambda () (font-lock-mode 1)))

;===========================================================
; TCL Mode  ================================================
;===========================================================
(add-hook 'tcl-mode-hook
	  (function 
           (lambda () 
             ;; Tcl mode overwrites delete. We can't have that.
             (define-key tcl-mode-map [(delete)] 'delete-char)
             (setq tcl-indent-level 2)
             ;(turn-on-auto-fill)
             ;(filladapt-mode)
             )))

;===========================================================
; Doxygen Headers for C++===================================
;===========================================================

(define-skeleton norm-fn-skeleton
  "Doxygen function header"
  "Describe the function: "
  "//! " str "\n//! \param \n//! \return")

(define-skeleton reimp-fn-skeleton
  "Doxygen re-implement from base function header"
  "Inherited from: "
  "//! Reimplemented from " str ".")

(define-skeleton member-header-skeleton
  "Doxygen member documentation"
  "Describe the member: "
  " //! " str ".")


(global-set-key [f9]  'member-header-skeleton)
(global-set-key [f10] 'norm-fn-skeleton)
(global-set-key [f11] 'reimp-fn-skeleton)
