;;;
;;; 1. name macro: name-last-kbd-macro
;;; 2. show macro: insert-kbd-macro
;;;

;;;
;;; untabify and indent-region
;;;
(fset 'cpptabindent
   [?\C-x ?[ ?\C-  ?\C-x ?] ?\C-[ ?x ?u ?n ?t ?a ?b ?i ?f ?y return ?\C-[ ?x ?i ?n ?d ?e ?n ?t ?- ?r ?e ?g ?i ?o ?n return])

;;;
;;; // -> /**/
;;;
(fset 'cppconvcomment
   "\C-s//\C-b\C-d*\C-e*/")

;;;
;;; qjqj -> qj
;;;
(fset 'qjqj2qj
   "\C-x[\C-[xreplace-string\C-m\C-q\C-j\C-q\C-j\C-m\C-q\C-j\C-m")

;;;
;;; remove // comment.
;;;
(fset 'nocppcomment
   "\C-s//\C-b\C-b\C-k\C-f")
;;;
;;; remove /* */ comment.
;;;
(fset 'noccomment
   [?\C-s ?/ ?* ?\C-b ?\C-b ?\C-  ?\C-s ?* ?/ ?\C-f ?\C-b ?\C-w])

;;;
;;; remove bitfield.
;;;
(fset 'nobitfield
   "\C-s:\C-a\C-k")

;;;
;;; macro
;;; ->
;;; #ifndef macro
;;; #define macro(...)
;;; #endif
;;;
(fset 'add-ifndef
   [?\C-  ?\C-e ?\C-[ ?w ?\C-a ?# ?i ?f ?n ?d ?e ?f ?  ?\C-e return ?# ?d ?e ?f ?i ?n ?e ?  ?\C-y ?( ?. ?. ?. ?) return ?# ?e ?n ?d ?i ?f return ?\C-d])

;;;
;;; case_label
;;; ->
;;; case case_label:
;;; {
;;; }
;;; break;
;;;
(fset 'add-caselist
   [?c ?a ?s ?e ?  ?\C-  ?\C-e ?\C-[ ?w ?: return ?{ return ?} ?\C-j ?b ?r ?e ?a ?k ?\; ?\C-f])

;;;
;;; ; xxxxxx
;;; ->
;;;
;;;
(fset 'nosemicolon
   "\C-s;\C-b\C-k\C-f")

;;;
;;; [\tab\space]\ret
;;; ->
;;; \ret
;;;
(fset 'end-beautify0
   [?\C-x ?[ ?\C-[ ?x ?r ?e ?p ?l ?a ?c ?e ?- ?r ?e ?g return ?[ tab ?  ?] ?\C-q ?\C-j return ?\C-q ?\C-j return])

;;;
;;; [\tag\space\ret]\ret -> ret
;;;
(fset 'end-beautify1
   [?\C-x ?[ ?\C-[ ?x ?r ?e ?p ?l tab ?r ?e ?g tab return ?[ tab ?  ?\C-q ?\C-j ?] ?\C-q ?\C-j return ?\C-q ?\C-j return])
