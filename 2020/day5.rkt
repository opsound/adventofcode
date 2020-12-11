#lang racket

(define LINES (file->lines "day5.txt"))

(define (bin->num one-char l n pos)
  (cond [(equal? '() l) n]
        [(char=? one-char (car l))
         (bin->num one-char (cdr l) (+ pos n) (* 2 pos))]
        [else
         (bin->num one-char (cdr l) n (* 2 pos))]))

(define (row s)
  (bin->num #\B (reverse (string->list (substring s 0 7)))
            0 1))

(define (col s)
  (bin->num #\R (reverse (string->list (substring s 7)))
            0 1))

(define (id s) (+ (col s) (* 8 (row s))))

(define IDS (sort (map id LINES) <))

(last IDS)

(define (find ids prev)
  (if (not (= 1 (- (car ids) prev)))
      (+ 1 prev)
      (find (cdr ids) (car ids))))

(find (cdr IDS) (car IDS))
