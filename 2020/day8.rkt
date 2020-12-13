#lang racket

(struct insn (opcode arg) #:transparent)

(define (decode line)
  (match-let ([(list _ a b) (regexp-match "([a-z]+) ([+-][0-9]+)" line)])
    (insn a (string->number b))))

(define INSTRUCTIONS (list->vector (map decode (file->lines "day8.txt"))))

(define (execute instruction acc pos)
  (case (insn-opcode instruction)
    [("nop") (list acc (add1 pos))]
    [("acc") (list (+ acc (insn-arg instruction)) (add1 pos))]
    [("jmp") (list acc (+ pos (insn-arg instruction)))]))

(define (swap instruction)
  (case (insn-opcode instruction)
    [("nop") (insn "jmp" (insn-arg instruction))]
    [("acc") instruction]
    [("jmp") (insn "nop" (insn-arg instruction))]))

(define (run1 acc pos visited)
  (if (set-member? visited pos)
      acc
      (apply run1 (append (execute (vector-ref INSTRUCTIONS pos) acc pos)
                          (list (set-add visited pos))))))

(run1 0 0 (set))

(define (run2 acc pos visited swapped)
  (cond [(= pos (vector-length INSTRUCTIONS)) acc]
        [(set-member? visited pos) #f]
        [else (match-let* ([i (vector-ref INSTRUCTIONS pos)]
                           [(list acc-next pos-next) (execute i acc pos)]
                           [(list acc-next-swap pos-next-swap) (execute (swap i) acc pos)]
                           [visited-next (set-add visited pos)])
                (if swapped
                    (run2 acc-next pos-next visited-next #t)
                    (or (run2 acc-next pos-next visited-next #f)
                        (run2 acc-next-swap pos-next-swap visited-next #t))))]))
                        
(run2 0 0 (set) #f)