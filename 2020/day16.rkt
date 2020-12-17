#lang racket

(match-define
  (list CONSTRAINT-STRING MY-TICKET-STRING NEARBY-TICKETS-STRING)
  (string-split (file->string "day16.txt") "\n\n"))

(define (line->nums line)
  (map string->number (string-split line ",")))

(define MY-TICKET (line->nums (second (string-split MY-TICKET-STRING "\n"))))
(define NEARBY-TICKETS (map line->nums (cdr (string-split NEARBY-TICKETS-STRING "\n"))))

(struct limit (low high) #:transparent)
(struct constraint (name limits) #:transparent)

(define CONSTRAINTS
  (for/list ([line (in-list (string-split CONSTRAINT-STRING "\n"))])
    (match-define
      (list _ name a b c d)
      (regexp-match #rx"(.+): ([0-9]+)-([0-9]+) or ([0-9]+)-([0-9]+)" line))
    (match-define (list na nb nc nd) (map string->number (list a b c d)))
    (constraint name (list (limit na nb) (limit nc nd)))))

(define (limit-within lim x)
  (and (>= x (limit-low lim))
       (<= x (limit-high lim))))

(define (in-constraint? val c)
  (for/or ([lim (in-list (constraint-limits c))])
    (limit-within lim val)))

(define (field-invalid? fld constraints)
  (for/and ([c (in-list constraints)])
    (not (in-constraint? fld c))))

(define (ticket-invalid-fields constraints ticket)
  (for/list ([fld (in-list ticket)]
             #:when (field-invalid? fld constraints))
    fld))

(apply + (flatten (map (curry ticket-invalid-fields CONSTRAINTS) NEARBY-TICKETS)))

(define (ticket-invalid? constraints ticket)
  (not (empty? (ticket-invalid-fields constraints ticket))))

(define VALID-TICKETS
  (filter (λ (ticket) (not (ticket-invalid? CONSTRAINTS ticket))) NEARBY-TICKETS))

(define (possible-constraints val constraints)
  (filter (curry in-constraint? val) constraints))

(define (prune-possibilities ticket possibilities)
  (for/list ([constraints possibilities]
             [fld ticket])
    (possible-constraints fld constraints)))

(define (repeat item n)
  (for/list ([i (in-range n)])
    item))

(define (leftover-constraints tickets constraints)
  (define n (length (car tickets)))
  (for/fold ([possibilities (repeat constraints n)])
            ([ticket (in-list tickets)])
    (prune-possibilities ticket possibilities)))

(define LEFTOVERS
  (leftover-constraints VALID-TICKETS CONSTRAINTS))

(define IDX-LEN-CONSTRAINTS
  (apply map list (list (range (length LEFTOVERS))
                        (map length LEFTOVERS)
                        (map list->set LEFTOVERS))))
(define SORTED
  (sort IDX-LEN-CONSTRAINTS (λ (a b) (< (second a) (second b)))))

(define IDX-CONSTRAINTS
  (for/list ([x (in-list SORTED)]
             [y (in-list (cons (list -1 -1 (set)) SORTED))])
    (list (first x) (set-first (set-subtract (third x) (third y))))))

(define (constraint-starts-with? c s)
  (string-prefix? (constraint-name c) s))

(define (list-refs lst refs)
  (for/list ([r refs])
    (list-ref lst r)))

(apply * (list-refs MY-TICKET
                    (map first (filter (λ (x) (constraint-starts-with? (second x) "departure"))
                                       IDX-CONSTRAINTS))))
