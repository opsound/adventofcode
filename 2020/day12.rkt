#lang racket

(define (manhattan-distance x y)
  (+ (abs x) (abs y)))

(define (angle->vec angle)
  (case (modulo angle 360)
    [(0) (list 1 0)]
    [(90) (list 0 1)]
    [(180) (list -1 0)]
    [(270) (list 0 -1)]))

(struct ship (angle x y))

(define (ship-translate s x y)
  (ship (ship-angle s)
        (+ x (ship-x s))
        (+ y (ship-y s))))

(define (ship-rotate s angle)
  (ship (+ angle (ship-angle s))
        (ship-x s)
        (ship-y s)))

(define (ship-forward s distance)
  (apply ship-translate s (map (λ (k) (* k distance))
                               (angle->vec (ship-angle s)))))

(define (string->action+value str)
  (list (string-ref str 0)
        (string->number (substring str 1))))

(define (ship-execute s action value)
  (case action
    [(#\N) (ship-translate s 0 value)]
    [(#\S) (ship-translate s 0 (- value))]
    [(#\E) (ship-translate s value 0)]
    [(#\W) (ship-translate s (- value) 0)]
    [(#\L) (ship-rotate s value)]
    [(#\R) (ship-rotate s (- value))]
    [(#\F) (ship-forward s value)]))

(struct ship-wp ship (x y))

(define (ship-wp-translate s x y)
  (ship-wp (ship-angle s)
           (ship-x s)
           (ship-y s)
           (+ x (ship-wp-x s))
           (+ y (ship-wp-y s))))

(define (rotate x y angle)
  (case (modulo angle 360)
    [(0) (list x y)]
    [(90) (list (- y) x)]
    [(180) (list (- x) (- y))]
    [(270) (list y (- x))]))

(define (ship-wp-rotate s angle)
  (apply ship-wp
         (ship-angle s)
         (ship-x s)
         (ship-y s)
         (rotate (ship-wp-x s) (ship-wp-y s) angle)))

(define (ship-wp-forward s distance)
  (ship-wp (ship-angle s)
           (+ (ship-x s) (* distance (ship-wp-x s)))
           (+ (ship-y s) (* distance (ship-wp-y s)))
           (ship-wp-x s)
           (ship-wp-y s)))
           
(define (ship-wp-execute s action value)
  (case action
    [(#\N) (ship-wp-translate s 0 value)]
    [(#\S) (ship-wp-translate s 0 (- value))]
    [(#\E) (ship-wp-translate s value 0)]
    [(#\W) (ship-wp-translate s (- value) 0)]
    [(#\L) (ship-wp-rotate s value)]
    [(#\R) (ship-wp-rotate s (- value))]
    [(#\F) (ship-wp-forward s value)]))

(define (run s lines execute)
  (let loop ([s s]
             [lines lines])
    (if (empty? lines)
        s
        (loop (apply execute s (string->action+value (car lines)))
              (cdr lines)))))

(let* ([lines (file->lines "day12.txt")]
       [s1 (run (ship 0 0 0) lines ship-execute)]
       [s2 (run (ship-wp 0 0 0 10 1) lines ship-wp-execute)])
  (values (manhattan-distance (ship-x s1) (ship-y s1))
          (manhattan-distance (ship-x s2) (ship-y s2))))


  

