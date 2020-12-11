#lang racket

(define LINES (file->lines "day4.txt"))

(define (group lines partial groups)
  (if (empty? lines)
      (cons partial groups)
      (if (equal? "" (car lines))
          (group (cdr lines) '() (cons partial groups))
          (group (cdr lines) (cons (car lines) partial) groups))))

(define (to-dict grp)
  (apply hash
         (flatten
          (map (λ (s) (string-split s ":"))
               (flatten
                (map (λ (s) (string-split s " ")) grp))))))

(define PASSPORTS (map to-dict (group LINES '() '())))
(define REQUIRED (set "byr" "iyr" "eyr" "hgt" "hcl" "ecl" "pid"))

(define (valid1? p)
  (subset? REQUIRED
           (list->set (hash-keys p))))

(count valid1? PASSPORTS)

(define (within? n min max)
  (and (>= n min) (<= n max)))

(define (num-field? field digits min max)
  (let ([n (string->number field)])
    (and (number? n)
         (= digits (string-length field))
         (within? (string->number field) min max))))

(define (byr? field) (num-field? field 4 1920 2002))
(define (iyr? field) (num-field? field 4 2010 2020))
(define (eyr? field) (num-field? field 4 2020 2030))

(define (height? field suffix min max)
  (and (string-suffix? field suffix)
       (within? (string->number (string-trim field suffix #:left? #f))
                min max)))

(define (hgt? field)
  (or (height? field "in" 59 76)
      (height? field "cm" 150 193)))

(define (digit? c)
  (and (char>=? c #\0)
       (char<=? c #\9)))

(define (hexchar? c)
  (or (digit? c)
      (and (char>=? c #\a)
           (char<=? c #\f))))
        
(define (hcl? field)
  (and (= 7 (string-length field))
       (char=? #\# (string-ref field 0))
       (= 6 (count values (map hexchar? (string->list (substring field 1)))))))

(define (ecl? field)
  (set-member? (set "amb" "blu" "brn" "gry" "grn" "hzl" "oth") field))

(define (pid? field)
  (= 9 (count values (map digit? (string->list field)))))

(define RULES
  (hash
   "byr" byr?
   "iyr" iyr?
   "eyr" eyr?
   "hgt" hgt?
   "hcl" hcl?
   "ecl" ecl?
   "pid" pid?))

(define (valid2? p)
  (and (valid1? p)
       (for/and ([field-type (set->list REQUIRED)])
         ((hash-ref RULES field-type) (hash-ref p field-type)))))
       
(count valid2? PASSPORTS)

  
       

