#lang racket

(define v (cons "first" "second"))
(car v)
(cdr v)

(set! v (cons "first" (cons "second" "third")))
(car v) ;; "first"
(car (cdr v)) ;; "second"
(cdr (cdr v)) ;; "third"
