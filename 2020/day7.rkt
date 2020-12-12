#lang racket

(define LINES (file->lines "day7.txt"))

(struct bag (adjective color) #:transparent)

(define (string-split-normalize s sep)
  (map string-normalize-spaces (string-split s sep)))

(define (string->words s)
  (string-split s " "))

(define (string->bag-num s)
  (let ([words (string->words s)])
    (cons (apply bag (cdr words))
          (string->number (car words)))))

(define (string->bags s)
  (if (string-prefix? s "no")
      '()
      (map string->bag-num (string-split s ","))))
   
(define (string->rule s)
  (match-let* ([cleaned (string-replace (string-replace s #rx"bags?" "") "." "")]
               [(list left right) (string-split-normalize cleaned "contain")]
               [left-bag (apply bag (string->words left))]
               [right-bags (string->bags right)])               
    (list left-bag right-bags)))

(define RULES (apply hash (apply append (map string->rule LINES))))

(define (bag-contains? b c)
  (let ([bags (hash-ref RULES b)])
    (if (empty? bags)
        #f
        (if (assoc c bags)
            #t
            (for/or ([candidate (map car bags)])
              (bag-contains? candidate c))))))

(count values (map (λ (b) (bag-contains? b (bag "shiny" "gold"))) (hash-keys RULES)))

(define (bag-count b)
  (let ([bags (hash-ref RULES b)])
    (if (empty? bags)
        0
        (+ (apply + (map cdr bags))
           (for/fold ([sum 0])
                     ([candidate (map car bags)]
                      [count (map cdr bags)])
             (+ sum (* count (bag-count candidate))))))))

(bag-count (bag "shiny" "gold"))