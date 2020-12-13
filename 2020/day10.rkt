#lang racket

(define ADAPTERS (map string->number (file->lines "day10.txt")))
(define DEVICE (+ 3 (apply max ADAPTERS)))
(define OUTLET 0)

(define (list-difference lst-a lst-b)
  (for/list ([a (in-list lst-a)]
             [b (in-list lst-b)])
    (- a b)))

(let* ([sorted (sort (cons DEVICE ADAPTERS) <)]
       [with-outlet (cons OUTLET sorted)]
       [diffs (list-difference sorted with-outlet)])
  (* (count (λ (x) (= 3 x)) diffs)
     (count (λ (x) (= 1 x)) diffs)))

(define (num-ways i hsh jolt-set)
  (cond [(< i 0) 0]
        [(= i 0) 1]
        [(not (set-member? jolt-set i)) 0]
        [(hash-has-key? hsh i) (hash-ref hsh i)]
        [else (+ (num-ways (- i 1) hsh jolt-set)
                 (num-ways (- i 2) hsh jolt-set)
                 (num-ways (- i 3) hsh jolt-set))]))

(define (count-ways jolts)
  (let* ([sorted (sort jolts <)]
         [jolt-set (list->set sorted)]
         [device (last sorted)])
    (for/fold ([hsh (hash)]
               #:result (num-ways device hsh jolt-set))
              ([i sorted])
      (hash-set hsh i (num-ways i hsh jolt-set)))))

(count-ways (cons OUTLET (cons DEVICE ADAPTERS)))
