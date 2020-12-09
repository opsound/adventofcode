#lang racket

(define LINES (list->vector (file->lines "day3.txt")))
(define NCOLS (string-length (vector-ref LINES 0)))
(define NROWS (vector-length LINES))

(define (tree-at? row col)
  (char=? #\#
          (string-ref (vector-ref LINES row)
                      (modulo col NCOLS))))

(define (traverse row col n down right)
    (if (>= row NROWS)
        n
        (let ([next-row (+ row down)]
              [next-col (+ col right)]
              [next-n (if (tree-at? row col) (add1 n) n)])
          (traverse next-row next-col next-n down right))))

(traverse 0 0 0 1 3)

(for/fold ([prod 1])
          ([d '(1 1 1 1 2)]
           [r '(1 3 5 7 1)])
  (* prod (traverse 0 0 0 d r)))

               


          
