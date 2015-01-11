(+ 1.0 2)
(- 1 2.0)
(* 3 4)
(/ 3 4)
(/ 4 3.0)
(* (+ 1 2) 3) ;; equivalent form (1 + 2) * 3

(define square
  (lambda (v)
    (* v v)))

(square 3)

;; function square (v)
;;     return v * v
;; end
;; square(3)

(begin
  (+ 3 4)
  (/ 3 4))

((lambda (x)
   (+ x x)) 10)

(define yes-or-no
  (lambda (v)
    (if v
        (print "yes")
        (print "no"))))

(yes-or-no true)
(yes-or-no false)
