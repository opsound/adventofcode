#lang racket

(require rackunit)

(define (string->pos-ids str)
  (let* ([nums (map string->number (string-split str ","))]
         [idxs (range (length nums))]
         [pairs (map list idxs nums)])
    (filter (lambda (p) (number? (second p))) pairs)))

(define LINES (file->lines "day13.txt"))
(define DEPARTURE-TIME (string->number (first LINES)))
(define POS-IDS (string->pos-ids (second LINES)))
(define IDS (second (apply map list POS-IDS)))
(define POS (first (apply map list POS-IDS)))

(define (div-roundup x y)
  (quotient (+ x (- y 1)) y))

(define (next-multiple x multiple)
  (* multiple (div-roundup x multiple)))

(apply * (argmin second
                 (for/list ([id (in-list IDS)])
                   (list id
                         (- (next-multiple DEPARTURE-TIME id)
                            DEPARTURE-TIME)))))

(define (valid? t pos-ids)
  (for/and ([p-id (in-list pos-ids)])
    (let ([pos (first p-id)]
          [id (second p-id)])
      (= 0 (modulo (+ t pos) id)))))

(check-true (valid? 3417 (string->pos-ids "17,x,13,19")))
(check-true (valid? 754018 (string->pos-ids "67,7,59,61")))
(check-true (valid? 1202161486 (string->pos-ids "1789,37,47,1889")))

