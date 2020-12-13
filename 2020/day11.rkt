#lang racket

(define (char->tile ch)
  (case ch
    [(#\L) 'empty]
    [(#\.) 'floor]
    [(#\#) 'occupied]
    [else #f]))

(struct grid (grid nrows ncols) #:transparent)

(define (make-grid nrows ncols)
  (grid (make-vector (* nrows ncols)) nrows ncols))

(define (grid-idx g row col)
  (cond [(< row 0) #f]
        [(< col 0) #f]
        [(>= row (grid-nrows g)) #f]
        [(>= col (grid-ncols g)) #f]
        [else (+ (* row (grid-ncols g))
                 col)]))

(define (grid-at g row col)
  (let ([idx (grid-idx g row col)])
    (if idx
        (vector-ref (grid-grid g) idx)
        #f)))

(define (grid-set g row col tile)
  (let ([idx (grid-idx g row col)])
    (if idx
        (vector-set! (grid-grid g) idx tile)
        (error "invalid coordinates"))))

(define (adjacents row col)
  (for*/list ([r (list row (add1 row) (sub1 row))]
              [c (list col (add1 col) (sub1 col))]
              #:unless (and (= r row) (= c col)))
    (list r c)))

(define (grid-adjacents g row col)
  (map (λ (rc) (apply grid-at g rc)) (adjacents row col)))

(define (grid-count-adjacents g row col tile)
  (count (λ (t) (equal? t tile)) (grid-adjacents g row col)))

(define (grid-next-tile g row col)
  (let ([tile (grid-at g row col)]
        [n-occupied (grid-count-adjacents g row col 'occupied)])
    (cond [(and (equal? 'empty tile) (= n-occupied 0)) 'occupied]
          [(and (equal? 'occupied tile) (>= n-occupied 4)) 'empty]
          [else tile])))

(define (grid-first-seat g row col rvec cvec)
  (let loop ([magnitude 1])
    (let* ([r (+ row (* magnitude rvec))]
           [c (+ col (* magnitude cvec))]
           [tile (grid-at g r c)])
      (if (equal? tile 'floor)
          (loop (add1 magnitude))
          tile))))

(define VECS
  (for*/list ([rvec (list -1 0 1)]
              [cvec (list -1 0 1)]
              #:unless (and (= rvec 0) (= cvec 0)))
    (list rvec cvec)))

(define (grid-see-adjacents g row col)
  (map (λ (vec) (apply grid-first-seat g row col vec)) VECS))

(define (grid-count-see-adjacents g row col tile)
  (count (λ (t) (equal? t tile)) (grid-see-adjacents g row col)))

(define (grid-next-tile2 g row col)
  (let ([tile (grid-at g row col)]
        [n-occupied (grid-count-see-adjacents g row col 'occupied)])
    (cond [(and (equal? 'empty tile) (= n-occupied 0)) 'occupied]
          [(and (equal? 'occupied tile) (>= n-occupied 5)) 'empty]
          [else tile])))

(define (grid-next-grid g next-tile)
  (let ([g-next (make-grid (grid-nrows g) (grid-ncols g))])
    (begin (for* ([r (grid-nrows g)]
                  [c (grid-ncols g)])
             (grid-set g-next r c (next-tile g r c)))
           g-next)))

(define (peek-ncols in)
  (string-length (read-line (peeking-input-port in))))

(define (peek-nrows in)
  (let ([p (peeking-input-port in)])
    (let loop ([nrows 0])
      (if (eof-object? (read-line p))
          nrows
          (loop (add1 nrows))))))

(define (file->grid path)
  (call-with-input-file path
    (λ (in)
      (let* ([ncols (peek-ncols in)]
             [nrows (peek-nrows in)]
             [grid-mut (make-vector (* nrows ncols))])
        (let loop ([idx 0]
                   [ch (read-char in)])
          (if (eof-object? ch)
              (grid grid-mut nrows ncols)
              (if (char->tile ch)
                  (begin (vector-set! grid-mut idx (char->tile ch))
                         (loop (add1 idx) (read-char in)))
                  (loop idx (read-char in)))))))))

(define (run g g-prev next-grid)
  (if (equal? g g-prev)
      (vector-count (λ (t) (equal? t 'occupied)) (grid-grid g))
      (run (next-grid g) g next-grid)))

(let ([g (file->grid "day11.txt")]
      [next-grid1 (λ (g) (grid-next-grid g grid-next-tile))]
      [next-grid2 (λ (g) (grid-next-grid g grid-next-tile2))])
  (values (run (next-grid1 g) g next-grid1)
          (run (next-grid2 g) g next-grid2)))



          
          
        
      

      


