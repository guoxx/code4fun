(+ 1.0 2)
(- 1 2.0)
(* 3 4)
(/ 3 4)
(/ 4 3.0)

(define cons
  (lambda (first last)
    (lambda (arg)
      (if (= arg 1)
          first
          last))))

(define car
  (lambda (list)
    (list 1)))

(define cdr
  (lambda (list)
    (list 2)))

(define alist (cons "aa" "bb"))
(car alist)
(cdr alist)

(define square
  (lambda (v)
    (* v v)))

(square 3)

(define exp
  (lambda (v n)
    (if (= n 0)
        1
        (if (odd? n)
            (* (exp v (- n 1)) v)
            (square (exp v (/ n 2)))))))
 
(exp 3 9)

(begin
  (+ 3 4)
  (/ 3 4))

((lambda (x)
   (+ x x)) 10)

(define func1
  (lambda (x)
    (begin
      (define iter
        (lambda (x v)
          (if (= x 0)
              v
              (iter (- x 1) (+ x v)))))
      (iter x 0))))

(func1 20)

(define yes-or-no
  (lambda (v)
    (if v
        (print "yes")
        (print "no"))))

(yes-or-no true)
(yes-or-no false)


(define fibonacci
  (begin
    (define iter
      (lambda (cur next cnt)
        (if (= cnt 0)
            cur
            (iter next (+ cur next) (- cnt 1)))))
    (lambda (n)
      (iter 0 1 n))))

(fibonacci 8)
