#lang racket

(require rackunit)

(struct mask (ones zeros xs) #:transparent)

(define (mask-value m val)
  (bitwise-and (bitwise-ior val (mask-ones m))
               (bitwise-not (mask-zeros m))))

(define (mask-permute-xs m xs)
  (bitwise-and (mask-xs m)
               (+ 1 xs (bitwise-ior (mask-ones m) (mask-zeros m)))))

(define (mask-list-xs m)
  (let loop ([list-xs '(0)])
    (if (= (car list-xs) (mask-xs m))
        list-xs
        (loop (cons (mask-permute-xs m (car list-xs)) list-xs)))))
        
(define (mask-addresses m addr)
  (for/list ([xs (in-list (mask-list-xs m))])
    (bitwise-ior xs
                 (mask-ones m)
                 (bitwise-and addr (mask-zeros m)))))

(define (string->mask str)
  (for/fold ([ones 0]
             [zeros 0]
             [xs 0]
             #:result (mask ones zeros xs))
            ([ch (in-list (string->list str))])
    (case ch
      [(#\X) (values (* 2 ones) (* 2 zeros) (add1 (* 2 xs)))]
      [(#\0) (values (* 2 ones) (add1 (* 2 zeros)) (* 2 xs))]
      [(#\1) (values (add1 (* 2 ones)) (* 2 zeros) (* 2 xs))])))
      
(define (parse-line line)
  (match line
    [(regexp #rx"mask = ([X01]+)" (list _ m)) (string->mask m)]
    [(regexp #rx"mem\\[([0-9]+)\\] = ([0-9]+)" (list _ addr val))
     (list (string->number addr) (string->number val))]))

(define (transform1 memory msk addr val)
  (hash-set memory addr (mask-value msk val)))

(define (transform2 memory msk addr val)
  (for/fold ([memory memory])
            ([addr (in-list (mask-addresses msk addr))])
    (hash-set memory addr val)))

(define (run-program lines transform)
  (for/fold ([memory (hash)]
             [msk (mask 0 0 0)]
             #:result memory)
            ([line (in-list lines)])
    (match (parse-line line)
      [(list addr val) (values (transform memory msk addr val) msk)]
      [m (values memory m)])))

(let ([lines (file->lines "day14.txt")])
  (values (apply + (hash-values (run-program lines transform1)))
          (apply + (hash-values (run-program lines transform2)))))