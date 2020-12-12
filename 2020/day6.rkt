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

(apply + (map (λ (g) (set-count (anyone-yes g))) GROUPS))
(apply + (map (λ (g) (set-count (everyone-yes g))) GROUPS))