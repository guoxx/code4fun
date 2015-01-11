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
