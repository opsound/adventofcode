#lang racket

(define GROUPS
  (map (λ (s) (string-split s "\n"))
       (string-split (file->string "day6.txt") "\n\n")))

(define (string->set s)
  (list->set (string->list s)))

(define (anyone-yes g)
  (foldl set-union
         (set)
         (map string->set g)))

(define (everyone-yes g)
  (foldl set-intersect
         (string->set (car g))
         (map string->set (cdr g))))

(foldl (λ (s count) (+ count (set-count s))) 0 (map anyone-yes GROUPS))
(foldl (λ (s count) (+ count (set-count s))) 0 (map everyone-yes GROUPS))