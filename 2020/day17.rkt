#lang racket

(require racket/struct)

(define LINES (file->lines "day17.txt"))

(struct space (pt1 pt2 vec) #:transparent)

(define (point-add pt1 pt2)
  (map + pt1 pt2))

(define (point-sub pt1 pt2)
  (map - pt1 pt2))

(define (point-shift pt d)
  (point-add pt (make-list (length pt) d)))

(define (surrounding-points pt)
  (map (curry point-add pt)
       (remf (curry equal? (make-list (length pt) 0))
             (apply cartesian-product
                    (for/list ([i (in-range (length pt))])
                      (list -1 0 1))))))

(define (idx-jumps pt)
  (for/fold ([vs '(1)]
             #:result (reverse (cdr vs)))
            ([x (in-list pt)])
    (cons (* x (car vs)) vs)))

(define (idx widths pt)
  (apply + (map * pt (idx-jumps widths))))

(define (space-vec-pos spc pt)
  (let ([pt-norm (point-sub pt (space-pt1 spc))]
        [widths (point-sub (space-pt2 spc) (space-pt1 spc))])
    (idx widths pt-norm)))

(define (point-inside? lower upper pt)
  (for/and ([is-below (in-list (map <= lower pt))]
            [is-above (in-list (map < pt upper))])
    (and is-below is-above)))
  
(define (space-ref spc pt)
  (if (point-inside? (space-pt1 spc) (space-pt2 spc) pt)
      (vector-ref (space-vec spc) (space-vec-pos spc pt))
      0))

(define (space-set! spc pt val)
  (vector-set! (space-vec spc) (space-vec-pos spc pt) val))

(define (make-space pt1 pt2)
  (space pt1 pt2 (make-vector (apply * (point-sub pt2 pt1)))))

(define (space-surrounding-vals spc pt)
  (map (curry space-ref spc) (surrounding-points pt)))

(define (char->val ch)
  (if (char=? ch #\#) 1 0))

(define (lines->space lines n-dim)
  (let* ([x-width (string-length (car lines))]
         [y-width (length lines)]
         [pt1 (make-list n-dim 0)]
         [pt2 (append (list x-width y-width) (make-list (- n-dim 2) 1))]
         [spc (make-space pt1 pt2)])
    (for ([line (in-list lines)]
          [y (in-range (length lines))])
      (for ([ch (in-list (string->list line))]
            [x (in-range (string-length line))])
        (space-set! spc (append (list x y) (make-list (- n-dim 2) 0)) (char->val ch))))
    spc))

(define (next-val curr n-active)
  (case (list curr n-active)
    ['(1 2) 1]
    ['(1 3) 1]
    ['(0 3) 1]
    [else 0]))

(define (next-point spc pt)
  (let* ([curr (space-ref spc pt)]
         [vals (space-surrounding-vals spc pt)]
         [n-active (apply + vals)])
    (next-val curr n-active)))

(define (points-within pt1 pt2)
  (apply cartesian-product (map range pt1 pt2)))

(define (next-space spc)
  (let* ([pt1 (point-shift (space-pt1 spc) -1)]
         [pt2 (point-shift (space-pt2 spc) 1)]
         [new-spc (make-space pt1 pt2)])
    (for ([pt (in-list (points-within pt1 pt2))])
      (space-set! new-spc pt (next-point spc pt)))
    new-spc))

(define (n-active spc)
  (for/sum ([v (in-vector (space-vec spc))]) v))
 
(define (iterate-space spc n-cycles)
  (if (= 0 n-cycles)
      spc
      (iterate-space (next-space spc) (sub1 n-cycles))))

(n-active (iterate-space (lines->space LINES 3) 6))
(n-active (iterate-space (lines->space LINES 4) 6))