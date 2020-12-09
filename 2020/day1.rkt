#lang racket

(define NUMS (map string->number (file->lines "day1.txt")))

(define (2sum target nums)
  (let* ([cmpl (λ (x) (- target x))]
         [cmpls (list->set (map cmpl nums))]
         [matches (set-intersect cmpls (list->set nums))])
    (set->list matches)))

(foldl * 1 (2sum 2020 NUMS))

(define (3sum target nums)
  (let* ([cmpl (λ (x) (- target x))]
         [cmpls (map cmpl NUMS)])
    (filter (λ (l) (> (length l) 1))
            (for/list ([t cmpls])
              (cons (cmpl t) (2sum t nums))))))

(foldl * 1 (first (3sum 2020 NUMS)))


  
       

  