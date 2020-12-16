#lang racket

(define INPUT (map string->number (string-split "2,20,0,4,1,17" ",")))

(define (initialize nums)
  (for/hash ([n (in-list nums)]
             [i (in-range (length nums))])
    (values n i)))

(define (nth-spoken input n)
  (for/fold ([spoken-nums (initialize (drop-right input 1))]
             [just-said (last input)]
             #:result just-said)
            ([turn (in-range (length input) n)])
    (define to-speak
      (match (hash-ref spoken-nums just-said #f)
        [#f 0]
        [when-spoke (- (sub1 turn) when-spoke)]))
    (values (hash-set spoken-nums just-said (sub1 turn)) to-speak)))

(nth-spoken INPUT 2020)
(nth-spoken INPUT 30000000)