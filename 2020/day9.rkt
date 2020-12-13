#lang racket

(define NUMS (list->vector (map string->number (file->lines "day9.txt"))))
(define PREAMBLE-LENGTH 25)

(define (valid? preamble n)
  (for/fold ([nums (set)]
             [found #f]
             #:result found)
            ([x preamble])
    #:break found
    (values (set-add nums x)
            (set-member? nums (- n x)))))

(define (valid-at? i)
  (valid? (in-vector NUMS (- i PREAMBLE-LENGTH) i) (vector-ref NUMS i)))

(define FIRST-INVALID
  (for/first ([i (in-range PREAMBLE-LENGTH (vector-length NUMS))]
              #:when (not (valid-at? i)))
    (vector-ref NUMS i)))

FIRST-INVALID

(define (sum-range begin end)
  (apply + (sequence->list (in-vector NUMS begin end))))

(define (search begin end)
  (let* ([lst (sequence->list (in-vector NUMS begin end))]
         [sum (apply + lst)])
    (cond [(< sum FIRST-INVALID) (search begin (add1 end))]
          [(> sum FIRST-INVALID) (search (add1 begin) end)]
          [else (+ (apply min lst) (apply max lst))])))

(search 0 1)
                      
  

 
