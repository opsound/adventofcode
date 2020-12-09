#lang racket

(define LINES (file->lines "day2.txt"))

(define (rule1 fmt)
  (λ (input)
    (match-let* ([(list a b) (string-split fmt " ")]
                 [chr (string-ref b 0)]
                 [(list min max) (map string->number (string-split a "-"))]
                 [cnt (count (λ (c) (char=? c chr)) (string->list input))])
      (and (>= cnt min) (<= cnt max)))))

(define (rule2 fmt)
  (λ (input)
    (match-let* ([(list a b) (string-split fmt " ")]
                 [chr (string-ref b 0)]
                 [(list p1 p2) (map string->number (string-split a "-"))]
                 [c1 (string-ref input p1)]
                 [c2 (string-ref input p2)])
      (xor (char=? chr c1) (char=? chr c2)))))

(define (make-checker rule)
  (λ (l)
    (match-let ([(list fmt str) (string-split l ":")])
      ((rule fmt) str))))
    
(count values (map (make-checker rule1) LINES))
(count values (map (make-checker rule2) LINES))
