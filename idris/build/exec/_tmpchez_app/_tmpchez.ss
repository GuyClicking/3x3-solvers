#!/nix/store/f8vhkcfz163aapr9ldlbaxl6sr787chm-chez-scheme-9.5.4/bin/scheme --script

; @generated
(import (chezscheme))
(case (machine-type)
  [(i3le ti3le a6le ta6le) (load-shared-object "libc.so.6")]
  [(i3osx ti3osx a6osx ta6osx) (load-shared-object "libc.dylib")]
  [(i3nt ti3nt a6nt ta6nt) (load-shared-object "msvcrt.dll")                           (load-shared-object "ws2_32.dll")]
  [else (load-shared-object "libc.so")])



(let ()
(define (blodwen-os)
  (case (machine-type)
    [(i3le ti3le a6le ta6le) "unix"]  ; GNU/Linux
    [(i3ob ti3ob a6ob ta6ob) "unix"]  ; OpenBSD
    [(i3fb ti3fb a6fb ta6fb) "unix"]  ; FreeBSD
    [(i3nb ti3nb a6nb ta6nb) "unix"]  ; NetBSD
    [(i3osx ti3osx a6osx ta6osx) "darwin"]
    [(i3nt ti3nt a6nt ta6nt) "windows"]
    [else "unknown"]))

(define blodwen-read-args (lambda (desc)
  (case (vector-ref desc 0)
    ((0) '())
    ((1) (cons (vector-ref desc 2)
               (blodwen-read-args (vector-ref desc 3)))))))
(define b+ (lambda (x y bits) (remainder (+ x y) (ash 1 bits))))
(define b- (lambda (x y bits) (remainder (- x y) (ash 1 bits))))
(define b* (lambda (x y bits) (remainder (* x y) (ash 1 bits))))
(define b/ (lambda (x y bits) (remainder (exact-floor (/ x y)) (ash 1 bits))))

(define integer->bits8 (lambda (x) (modulo x (expt 2 8))))
(define integer->bits16 (lambda (x) (modulo x (expt 2 16))))
(define integer->bits32 (lambda (x) (modulo x (expt 2 32))))
(define integer->bits64 (lambda (x) (modulo x (expt 2 64))))

(define bits16->bits8 (lambda (x) (modulo x (expt 2 8))))
(define bits32->bits8 (lambda (x) (modulo x (expt 2 8))))
(define bits32->bits16 (lambda (x) (modulo x (expt 2 16))))
(define bits64->bits8 (lambda (x) (modulo x (expt 2 8))))
(define bits64->bits16 (lambda (x) (modulo x (expt 2 16))))
(define bits64->bits32 (lambda (x) (modulo x (expt 2 32))))

(define blodwen-bits-shl (lambda (x y bits) (remainder (ash x y) (ash 1 bits))))
(define blodwen-shl (lambda (x y) (ash x y)))
(define blodwen-shr (lambda (x y) (ash x (- y))))
(define blodwen-and (lambda (x y) (logand x y)))
(define blodwen-or (lambda (x y) (logor x y)))
(define blodwen-xor (lambda (x y) (logxor x y)))

(define cast-num
  (lambda (x)
    (if (number? x) x 0)))
(define destroy-prefix
  (lambda (x)
    (cond
      ((equal? x "") "")
      ((equal? (string-ref x 0) #\#) "")
      (else x))))
(define exact-floor
  (lambda (x)
    (inexact->exact (floor x))))
(define cast-string-int
  (lambda (x)
    (exact-floor (cast-num (string->number (destroy-prefix x))))))
(define cast-int-char
  (lambda (x)
    (if (and (>= x 0)
             (<= x #x10ffff))
        (integer->char x)
        0)))
(define cast-string-double
  (lambda (x)
    (cast-num (string->number (destroy-prefix x)))))

(define (from-idris-list xs)
  (if (= (vector-ref xs 0) 0)
    '()
    (cons (vector-ref xs 1) (from-idris-list (vector-ref xs 2)))))
(define (string-pack xs) (apply string (from-idris-list xs)))
(define (to-idris-list-rev acc xs)
  (if (null? xs)
    acc
    (to-idris-list-rev (vector 1 (car xs) acc) (cdr xs))))
(define (string-unpack s) (to-idris-list-rev (vector 0) (reverse (string->list s))))
(define (string-concat xs) (apply string-append (from-idris-list xs)))
(define string-cons (lambda (x y) (string-append (string x) y)))
(define get-tag (lambda (x) (vector-ref x 0)))
(define string-reverse (lambda (x)
  (list->string (reverse (string->list x)))))
(define (string-substr off len s)
    (let* ((l (string-length s))
          (b (max 0 off))
          (x (max 0 len))
          (end (min l (+ b x))))
          (if (> b l)
              ""
              (substring s b end))))

(define (blodwen-string-iterator-new s)
  0)

(define (blodwen-string-iterator-next s ofs)
  (if (>= ofs (string-length s))
      (vector 0)  ; EOF
      (vector 1 (string-ref s ofs) (+ ofs 1))))

(define either-left
  (lambda (x)
    (vector 0 x)))

(define either-right
  (lambda (x)
    (vector 1 x)))

(define blodwen-error-quit
  (lambda (msg)
    (display msg)
    (newline)
    (exit 1)))

(define (blodwen-get-line p)
    (if (port? p)
        (let ((str (get-line p)))
            (if (eof-object? str)
                ""
                str))
        void))

(define (blodwen-get-char p)
    (if (port? p)
        (let ((chr (get-char p)))
            (if (eof-object? chr)
                #\nul
                chr))
        void))

;; Buffers

(define (blodwen-new-buffer size)
  (make-bytevector size 0))

(define (blodwen-buffer-size buf)
  (bytevector-length buf))

(define (blodwen-buffer-setbyte buf loc val)
  (bytevector-u8-set! buf loc val))

(define (blodwen-buffer-getbyte buf loc)
  (bytevector-u8-ref buf loc))

(define (blodwen-buffer-setbits16 buf loc val)
  (bytevector-u16-set! buf loc val (native-endianness)))

(define (blodwen-buffer-getbits16 buf loc)
  (bytevector-u16-ref buf loc (native-endianness)))

(define (blodwen-buffer-setbits32 buf loc val)
  (bytevector-u32-set! buf loc val (native-endianness)))

(define (blodwen-buffer-getbits32 buf loc)
  (bytevector-u32-ref buf loc (native-endianness)))

(define (blodwen-buffer-setbits64 buf loc val)
  (bytevector-u64-set! buf loc val (native-endianness)))

(define (blodwen-buffer-getbits64 buf loc)
  (bytevector-u64-ref buf loc (native-endianness)))

(define (blodwen-buffer-setint32 buf loc val)
  (bytevector-s32-set! buf loc val (native-endianness)))

(define (blodwen-buffer-getint32 buf loc)
  (bytevector-s32-ref buf loc (native-endianness)))

(define (blodwen-buffer-setint buf loc val)
  (bytevector-s64-set! buf loc val (native-endianness)))

(define (blodwen-buffer-getint buf loc)
  (bytevector-s64-ref buf loc (native-endianness)))

(define (blodwen-buffer-setdouble buf loc val)
  (bytevector-ieee-double-set! buf loc val (native-endianness)))

(define (blodwen-buffer-getdouble buf loc)
  (bytevector-ieee-double-ref buf loc (native-endianness)))

(define (blodwen-stringbytelen str)
  (bytevector-length (string->utf8 str)))

(define (blodwen-buffer-setstring buf loc val)
  (let* [(strvec (string->utf8 val))
         (len (bytevector-length strvec))]
    (bytevector-copy! strvec 0 buf loc len)))

(define (blodwen-buffer-getstring buf loc len)
  (let [(newvec (make-bytevector len))]
    (bytevector-copy! buf loc newvec 0 len)
    (utf8->string newvec)))

(define (blodwen-buffer-copydata buf start len dest loc)
  (bytevector-copy! buf start dest loc len))

;; Threads

(define blodwen-thread-data (make-thread-parameter #f))

(define (blodwen-thread p)
    (fork-thread (lambda () (p (vector 0)))))

(define (blodwen-get-thread-data ty)
  (blodwen-thread-data))

(define (blodwen-set-thread-data a)
  (blodwen-thread-data a))

(define (blodwen-mutex) (make-mutex))
(define (blodwen-lock m) (mutex-acquire m))
(define (blodwen-unlock m) (mutex-release m))
(define (blodwen-thisthread) (get-thread-id))

(define (blodwen-condition) (make-condition))
(define (blodwen-condition-wait c m) (condition-wait c m))
(define (blodwen-condition-wait-timeout c m t)
  (let ((sec (div t 1000000))
        (micro (mod t 1000000)))
  (condition-wait c m (make-time 'time-duration (* 1000 micro) sec))))
(define (blodwen-condition-signal c) (condition-signal c))
(define (blodwen-condition-broadcast c) (condition-broadcast c))

(define-record future-internal (result ready mutex signal))
(define (blodwen-make-future work)
  (let ([future (make-future-internal #f #f (make-mutex) (make-condition))])
    (fork-thread (lambda ()
      (let ([result (work)])
        (with-mutex (future-internal-mutex future)
          (set-future-internal-result! future result)
          (set-future-internal-ready! future #t)
          (condition-broadcast (future-internal-signal future))))))
    future))
(define (blodwen-await-future ty future)
  (let ([mutex (future-internal-mutex future)])
    (with-mutex mutex
      (if (not (future-internal-ready future))
          (condition-wait (future-internal-signal future) mutex))
      (future-internal-result future))))

(define (blodwen-sleep s) (sleep (make-time 'time-duration 0 s)))
(define (blodwen-usleep s)
  (let ((sec (div s 1000000))
        (micro (mod s 1000000)))
       (sleep (make-time 'time-duration (* 1000 micro) sec))))

(define (blodwen-time) (time-second (current-time)))
(define (blodwen-clock-time-utc) (current-time 'time-utc))
(define (blodwen-clock-time-monotonic) (current-time 'time-monotonic))
(define (blodwen-clock-time-duration) (current-time 'time-duration))
(define (blodwen-clock-time-process) (current-time 'time-process))
(define (blodwen-clock-time-thread) (current-time 'time-thread))
(define (blodwen-clock-time-gccpu) (current-time 'time-collector-cpu))
(define (blodwen-clock-time-gcreal) (current-time 'time-collector-real))
(define (blodwen-is-time? clk) (if (time? clk) 1 0))
(define (blodwen-clock-second time) (time-second time))
(define (blodwen-clock-nanosecond time) (time-nanosecond time))

(define (blodwen-args)
  (define (blodwen-build-args args)
    (if (null? args)
        (vector 0) ; Prelude.List
        (vector 1 (car args) (blodwen-build-args (cdr args)))))
    (blodwen-build-args (command-line)))

(define (blodwen-hasenv var)
  (if (eq? (getenv var) #f) 0 1))

(define (blodwen-system cmd)
  (system cmd))

;; Randoms
(define random-seed-register 0)
(define (initialize-random-seed-once)
  (if (= (virtual-register random-seed-register) 0)
      (let ([seed (time-nanosecond (current-time))])
        (set-virtual-register! random-seed-register seed)
        (random-seed seed))))

(define (blodwen-random-seed seed)
  (set-virtual-register! random-seed-register seed)
  (random-seed seed))
(define blodwen-random
  (case-lambda
    ;; no argument, pick a real value from [0, 1.0)
    [() (begin
          (initialize-random-seed-once)
          (random 1.0))]
    ;; single argument k, pick an integral value from [0, k)
    [(k)
      (begin
        (initialize-random-seed-once)
        (if (> k 0)
              (random k)
              (assertion-violationf 'blodwen-random "invalid range argument ~a" k)))]))

;; For finalisers

(define blodwen-finaliser (make-guardian))
(define (blodwen-register-object obj proc)
  (let [(x (cons obj proc))]
       (blodwen-finaliser x)
       x))
(define blodwen-run-finalisers
  (lambda ()
    (let run ()
      (let ([x (blodwen-finaliser)])
        (when x
          (((cdr x) (car x)) 'erased)
          (run))))))
(define SystemC-45File-prim__stdout (lambda () ((foreign-procedure #f "idris2_stdout" () void*) )))
(define SystemC-45File-prim__stdin (lambda () ((foreign-procedure #f "idris2_stdin" () void*) )))
(define SystemC-45File-prim__flush (lambda (farg-0 farg-1) ((foreign-procedure #f "fflush" (void*) int) farg-0)))
(define SystemC-45File-prim__eof (lambda (farg-0 farg-1) ((foreign-procedure #f "idris2_eof" (void*) int) farg-0)))
(define PreludeC-45IO-prim__putStr (lambda (farg-0 farg-1) ((foreign-procedure #f "idris2_putStr" (string) void) farg-0) (vector 0 )))
(define PreludeC-45IO-prim__getStr (lambda (farg-0) ((foreign-procedure #f "idris2_getStr" () string) )))
(define prim__add_Integer (lambda (arg-0 arg-1) (+ arg-0 arg-1)))
(define prim__sub_Int (lambda (arg-0 arg-1) (b- arg-0 arg-1 63)))
(define prim__sub_Integer (lambda (arg-0 arg-1) (- arg-0 arg-1)))
(define prim__mul_Integer (lambda (arg-0 arg-1) (* arg-0 arg-1)))
(define prim__lt_Int (lambda (arg-0 arg-1) (or (and (< arg-0 arg-1) 1) 0)))
(define prim__lte_Integer (lambda (arg-0 arg-1) (or (and (<= arg-0 arg-1) 1) 0)))
(define prim__eq_Int (lambda (arg-0 arg-1) (or (and (= arg-0 arg-1) 1) 0)))
(define prim__eq_Char (lambda (arg-0 arg-1) (or (and (char=? arg-0 arg-1) 1) 0)))
(define prim__strLength (lambda (arg-0) (string-length arg-0)))
(define prim__strIndex (lambda (arg-0 arg-1) (string-ref arg-0 arg-1)))
(define prim__strCons (lambda (arg-0 arg-1) (string-cons arg-0 arg-1)))
(define prim__strAppend (lambda (arg-0 arg-1) (string-append arg-0 arg-1)))
(define prim__believe_me (lambda (arg-0 arg-1 arg-2) arg-2))
(define prim__crash (lambda (arg-0 arg-1) (blodwen-error-quit (string-append "ERROR: " arg-1))))
(define prim__cast_IntInteger (lambda (arg-0) arg-0))
(define prim__cast_IntegerInt (lambda (arg-0) arg-0))
(define Main-solveScrambleString (lambda (arg-0) (PreludeC-45TypesC-45Strings-C-43C-43 (Move-moveString (Move-parseStr arg-0)) "\xa;")))
(define Main-main (lambda () (SystemC-45REPL-repl 'erased (vector 0 (vector 0 (vector 0 (lambda (b) (lambda (a) (lambda (func) (lambda (arg-149) (lambda (eta-0) (PreludeC-45IO-map_Functor_IO 'erased 'erased func arg-149 eta-0)))))) (lambda (a) (lambda (arg-482) (lambda (eta-0) arg-482))) (lambda (b) (lambda (a) (lambda (arg-483) (lambda (arg-485) (lambda (eta-0) (let ((act-17 (arg-483 eta-0))) (let ((act-16 (arg-485 eta-0))) (act-17 act-16))))))))) (lambda (b) (lambda (a) (lambda (arg-644) (lambda (arg-645) (lambda (eta-0) (let ((act-24 (arg-644 eta-0))) ((arg-645 act-24) eta-0))))))) (lambda (a) (lambda (arg-647) (lambda (eta-0) (let ((act-51 (arg-647 eta-0))) (act-51 eta-0)))))) (lambda (a) (lambda (arg-7222) arg-7222))) "Scramble: " (lambda (eta-0) (Main-solveScrambleString eta-0)))))
(define SystemC-45REPL-case--caseC-32blockC-32inC-32replWith-2362 (lambda (arg-0 arg-1 arg-2 arg-3 arg-4 arg-5 arg-6 arg-7 arg-8 arg-9 arg-10) (let ((sc0 arg-10)) (case (vector-ref sc0 0) ((1) (let ((e-1 (vector-ref sc0 1))) (let ((sc1 e-1)) (let ((e-5 (vector-ref sc1 1))) (let ((e-6 (vector-ref sc1 2))) (let ((sc2 (let ((sc3 arg-2)) (let ((e-3 (vector-ref sc3 1))) e-3)))) (let ((e-2 (vector-ref sc2 2))) ((((e-2 'erased) 'erased) (PreludeC-45IO-putStr 'erased arg-2 e-5)) (lambda (_-2403) (SystemC-45REPL-replWith 'erased 'erased arg-2 e-6 arg-4 arg-3)))))))))) (else (let ((sc1 (let ((sc2 (let ((sc3 arg-2)) (let ((e-1 (vector-ref sc3 1))) e-1)))) (let ((e-1 (vector-ref sc2 1))) e-1)))) (let ((e-2 (vector-ref sc1 2))) ((e-2 'erased) (vector 0 )))))))))
(define SystemC-45REPL-case--replWith-2283 (lambda (arg-0 arg-1 arg-2 arg-3 arg-4 arg-5 arg-6) (let ((sc0 arg-6)) (cond ((equal? sc0 0) (let ((sc1 (let ((sc2 (let ((sc3 arg-2)) (let ((e-1 (vector-ref sc3 1))) e-1)))) (let ((e-1 (vector-ref sc2 1))) e-1)))) (let ((e-2 (vector-ref sc1 2))) ((e-2 'erased) (vector 0 ))))) (else (let ((sc1 (let ((sc2 arg-2)) (let ((e-1 (vector-ref sc2 1))) e-1)))) (let ((e-2 (vector-ref sc1 2))) ((((e-2 'erased) 'erased) (PreludeC-45IO-putStr 'erased arg-2 arg-4)) (lambda (_-2334) (let ((sc2 (let ((sc3 arg-2)) (let ((e-5 (vector-ref sc3 1))) e-5)))) (let ((e-5 (vector-ref sc2 2))) ((((e-5 'erased) 'erased) (SystemC-45File-fflush 'erased arg-2 (SystemC-45File-stdout))) (lambda (_-2343) (let ((sc3 (let ((sc4 arg-2)) (let ((e-8 (vector-ref sc4 1))) e-8)))) (let ((e-8 (vector-ref sc3 2))) ((((e-8 'erased) 'erased) (PreludeC-45IO-getLine 'erased arg-2)) (lambda (x) (let ((eof 1)) (SystemC-45REPL-case--caseC-32blockC-32inC-32replWith-2362 'erased 'erased arg-2 arg-3 arg-4 arg-5 eof _-2334 _-2343 x ((arg-3 arg-5) x))))))))))))))))))))
(define SystemC-45REPL-replWith (lambda (arg-0 arg-1 arg-2 arg-3 arg-4 arg-5) (let ((sc0 (let ((sc1 arg-2)) (let ((e-1 (vector-ref sc1 1))) e-1)))) (let ((e-2 (vector-ref sc0 2))) ((((e-2 'erased) 'erased) (SystemC-45File-fEOF 'erased arg-2 (SystemC-45File-stdin))) (lambda (eof) (let ((sc1 eof)) (cond ((equal? sc1 0) (let ((sc2 (let ((sc3 (let ((sc4 arg-2)) (let ((e-5 (vector-ref sc4 1))) e-5)))) (let ((e-6 (vector-ref sc3 1))) e-6)))) (let ((e-5 (vector-ref sc2 2))) ((e-5 'erased) (vector 0 ))))) (else (let ((sc2 (let ((sc3 arg-2)) (let ((e-5 (vector-ref sc3 1))) e-5)))) (let ((e-5 (vector-ref sc2 2))) ((((e-5 'erased) 'erased) (PreludeC-45IO-putStr 'erased arg-2 arg-4)) (lambda (_-2334) (let ((sc3 (let ((sc4 arg-2)) (let ((e-8 (vector-ref sc4 1))) e-8)))) (let ((e-8 (vector-ref sc3 2))) ((((e-8 'erased) 'erased) (SystemC-45File-fflush 'erased arg-2 (SystemC-45File-stdout))) (lambda (_-2343) (let ((sc4 (let ((sc5 arg-2)) (let ((e-11 (vector-ref sc5 1))) e-11)))) (let ((e-11 (vector-ref sc4 2))) ((((e-11 'erased) 'erased) (PreludeC-45IO-getLine 'erased arg-2)) (lambda (x) (let ((eof-0 1)) (SystemC-45REPL-case--caseC-32blockC-32inC-32replWith-2362 'erased 'erased arg-2 arg-5 arg-4 arg-3 eof-0 _-2334 _-2343 x ((arg-5 arg-3) x))))))))))))))))))))))))
(define SystemC-45REPL-repl (lambda (arg-0 arg-1 arg-2 arg-3) (SystemC-45REPL-replWith 'erased 'erased arg-1 (vector 0 ) arg-2 (lambda (x) (lambda (s) (vector 1 (vector 0 (arg-3 s) (vector 0 ))))))))
(define SystemC-45File-stdout (lambda () (SystemC-45File-prim__stdout)))
(define SystemC-45File-stdin (lambda () (SystemC-45File-prim__stdin)))
(define SystemC-45File-fflush (lambda (arg-0 arg-1 arg-2) (let ((sc0 (let ((sc1 arg-1)) (let ((e-1 (vector-ref sc1 1))) e-1)))) (let ((e-2 (vector-ref sc0 2))) ((((e-2 'erased) 'erased) (let ((sc1 arg-1)) (let ((e-4 (vector-ref sc1 2))) ((e-4 'erased) (lambda (eta-0) (SystemC-45File-prim__flush arg-2 eta-0)))))) (lambda (_-1309) (let ((sc1 (let ((sc2 (let ((sc3 arg-1)) (let ((e-5 (vector-ref sc3 1))) e-5)))) (let ((e-6 (vector-ref sc2 1))) e-6)))) (let ((e-5 (vector-ref sc1 2))) ((e-5 'erased) (vector 0 ))))))))))
(define SystemC-45File-fEOF (lambda (arg-0 arg-1 arg-2) (let ((sc0 (let ((sc1 arg-1)) (let ((e-1 (vector-ref sc1 1))) e-1)))) (let ((e-2 (vector-ref sc0 2))) ((((e-2 'erased) 'erased) (let ((sc1 arg-1)) (let ((e-4 (vector-ref sc1 2))) ((e-4 'erased) (lambda (eta-0) (SystemC-45File-prim__eof arg-2 eta-0)))))) (lambda (res) (let ((sc1 (let ((sc2 (let ((sc3 arg-1)) (let ((e-5 (vector-ref sc3 1))) e-5)))) (let ((e-6 (vector-ref sc2 1))) e-6)))) (let ((e-5 (vector-ref sc1 2))) ((e-5 'erased) (PreludeC-45EqOrd-C-47C-61_Eq_Int res 0))))))))))
(define PreludeC-45Basics-C-124C-124 (lambda (arg-0 arg-1) (let ((sc0 arg-0)) (cond ((equal? sc0 0) 0) (else (arg-1))))))
(define PreludeC-45Basics-not (lambda (arg-0) (let ((sc0 arg-0)) (cond ((equal? sc0 0) 1) (else 0)))))
(define PreludeC-45Basics-intToBool (lambda (arg-0) (let ((sc0 arg-0)) (cond ((equal? sc0 0) 1)(else 0)))))
(define PreludeC-45Basics-id (lambda (arg-0 arg-1) arg-1))
(define PreludeC-45Basics-C-46 (lambda (arg-0 arg-1 arg-2 arg-3 arg-4 ext-0) (arg-3 (arg-4 ext-0))))
(define Builtin-idris_crash (lambda (arg-0 ext-0) (blodwen-error-quit (string-append "ERROR: " ext-0))))
(define Builtin-believe_me (lambda (arg-0 arg-1 ext-0) ext-0))
(define Builtin-assert_total (lambda (arg-0 arg-1) arg-1))
(define PreludeC-45Types-case--unpackC-44unpackC-39-4483 (lambda (arg-0 arg-1 arg-2 arg-3 arg-4) (let ((sc0 arg-4)) (cond ((equal? sc0 0) arg-1) (else (PreludeC-45Types-n--4306-4471-unpackC-39 arg-0 (PreludeC-45Num-C-45_Neg_Int arg-3 1) arg-2 (vector 1 (string-ref arg-2 arg-3) arg-1)))))))
(define PreludeC-45Types-case--integerToNat-641 (lambda (arg-0 arg-1) (let ((sc0 arg-1)) (cond ((equal? sc0 0) 0) (else (+ 1 (PreludeC-45Types-prim__integerToNat (- arg-0 1))))))))
(define PreludeC-45Types-case--prim__integerToNat-627 (lambda (arg-0 arg-1) (let ((sc0 arg-1)) (cond ((equal? sc0 0) (Builtin-believe_me 'erased 'erased arg-0)) (else 0)))))
(define PreludeC-45Types-n--4306-4471-unpackC-39 (lambda (arg-0 arg-1 arg-2 arg-3) (PreludeC-45Types-case--unpackC-44unpackC-39-4483 arg-0 arg-3 arg-2 arg-1 (PreludeC-45EqOrd-C-60_Ord_Int arg-1 0))))
(define PreludeC-45Types-map_Functor_List (lambda (arg-0 arg-1 arg-2 arg-3) (let ((sc0 arg-3)) (case (vector-ref sc0 0) ((0) (vector 0 )) (else (let ((e-2 (vector-ref sc0 1))) (let ((e-3 (vector-ref sc0 2))) (vector 1 (arg-2 e-2) (PreludeC-45Types-map_Functor_List 'erased 'erased arg-2 e-3)))))))))
(define PreludeC-45Types-fromInteger_Num_Nat (lambda (arg-0) (PreludeC-45Types-prim__integerToNat arg-0)))
(define PreludeC-45Types-__Impl_Functor_List (lambda (ext-0 ext-1 ext-2 ext-3) (PreludeC-45Types-map_Functor_List 'erased 'erased ext-2 ext-3)))
(define PreludeC-45Types-unpack (lambda (arg-0) (PreludeC-45Types-n--4306-4471-unpackC-39 arg-0 (PreludeC-45Num-C-45_Neg_Int (PreludeC-45TypesC-45Strings-length arg-0) 1) arg-0 (vector 0 ))))
(define PreludeC-45Types-strCons (lambda (ext-0 ext-1) (string-cons ext-0 ext-1)))
(define PreludeC-45Types-prim__integerToNat (lambda (arg-0) (PreludeC-45Types-case--prim__integerToNat-627 arg-0 (let ((sc0 (or (and (<= 0 arg-0) 1) 0))) (cond ((equal? sc0 0) 1)(else 0))))))
(define PreludeC-45Types-pack (lambda (arg-0) (let ((sc0 arg-0)) (case (vector-ref sc0 0) ((0) "") (else (let ((e-2 (vector-ref sc0 1))) (let ((e-3 (vector-ref sc0 2))) (PreludeC-45Types-strCons e-2 (PreludeC-45Types-pack e-3)))))))))
(define PreludeC-45Types-natToInteger (lambda (arg-0) (let ((sc0 arg-0)) (cond ((equal? sc0 0) 0)(else (let ((e-0 (- arg-0 1))) (+ 1 e-0)))))))
(define PreludeC-45TypesC-45Strings-length (lambda (arg-0) (PreludeC-45Types-fromInteger_Num_Nat (string-length arg-0))))
(define PreludeC-45Types-isSpace (lambda (arg-0) (PreludeC-45Basics-C-124C-124 (PreludeC-45EqOrd-C-61C-61_Eq_Char arg-0 #\ ) (lambda () (PreludeC-45Basics-C-124C-124 (PreludeC-45EqOrd-C-61C-61_Eq_Char arg-0 (integer->char 9)) (lambda () (PreludeC-45Basics-C-124C-124 (PreludeC-45EqOrd-C-61C-61_Eq_Char arg-0 (integer->char 13)) (lambda () (PreludeC-45Basics-C-124C-124 (PreludeC-45EqOrd-C-61C-61_Eq_Char arg-0 (integer->char 10)) (lambda () (PreludeC-45Basics-C-124C-124 (PreludeC-45EqOrd-C-61C-61_Eq_Char arg-0 (integer->char 12)) (lambda () (PreludeC-45Basics-C-124C-124 (PreludeC-45EqOrd-C-61C-61_Eq_Char arg-0 (integer->char 11)) (lambda () (PreludeC-45EqOrd-C-61C-61_Eq_Char arg-0 (integer->char 160))))))))))))))))
(define PreludeC-45Types-integerToNat (lambda (arg-0) (PreludeC-45Types-case--integerToNat-641 arg-0 (let ((sc0 (or (and (<= arg-0 0) 1) 0))) (cond ((equal? sc0 0) 1)(else 0))))))
(define PreludeC-45TypesC-45Strings-C-43C-43 (lambda (arg-0 arg-1) (string-append arg-0 arg-1)))
(define PreludeC-45TypesC-45List-C-43C-43 (lambda (arg-0 arg-1 arg-2) (let ((sc0 arg-1)) (case (vector-ref sc0 0) ((0) arg-2) (else (let ((e-2 (vector-ref sc0 1))) (let ((e-3 (vector-ref sc0 2))) (vector 1 e-2 (PreludeC-45TypesC-45List-C-43C-43 'erased e-3 arg-2)))))))))
(define PreludeC-45Num-fromInteger_Num_Integer (lambda (ext-0) ext-0))
(define PreludeC-45Num-fromInteger_Num_Int (lambda (ext-0) ext-0))
(define PreludeC-45Num-C-45_Neg_Int (lambda (ext-0 ext-1) (b- ext-0 ext-1 63)))
(define PreludeC-45Num-C-43_Num_Integer (lambda (ext-0 ext-1) (+ ext-0 ext-1)))
(define PreludeC-45EqOrd-__Impl_Eq_Int (lambda () (vector 0 (lambda (arg-2) (lambda (arg-3) (PreludeC-45EqOrd-C-61C-61_Eq_Int arg-2 arg-3))) (lambda (arg-4) (lambda (arg-5) (PreludeC-45EqOrd-C-47C-61_Eq_Int arg-4 arg-5))))))
(define PreludeC-45EqOrd-C-61C-61_Eq_Int (lambda (arg-0 arg-1) (let ((sc0 (or (and (= arg-0 arg-1) 1) 0))) (cond ((equal? sc0 0) 1)(else 0)))))
(define PreludeC-45EqOrd-C-61C-61_Eq_Char (lambda (arg-0 arg-1) (let ((sc0 (or (and (char=? arg-0 arg-1) 1) 0))) (cond ((equal? sc0 0) 1)(else 0)))))
(define PreludeC-45EqOrd-C-60_Ord_Int (lambda (arg-0 arg-1) (let ((sc0 (or (and (< arg-0 arg-1) 1) 0))) (cond ((equal? sc0 0) 1)(else 0)))))
(define PreludeC-45EqOrd-C-47C-61_Eq_Int (lambda (arg-0 arg-1) (PreludeC-45Basics-not (PreludeC-45EqOrd-C-61C-61_Eq_Int arg-0 arg-1))))
(define PreludeC-45EqOrd-C-61C-61 (lambda (arg-0 arg-1) (let ((sc0 arg-1)) (let ((e-1 (vector-ref sc0 1))) (lambda (arg-2) (lambda (arg-3) ((e-1 arg-2) arg-3)))))))
(define PreludeC-45Interfaces-__Monad_C-40ApplicativeC-32mC-41 (lambda (arg-0 arg-1) (let ((sc0 arg-1)) (let ((e-1 (vector-ref sc0 1))) e-1))))
(define PreludeC-45Interfaces-pure (lambda (arg-0 arg-1 arg-2) (let ((sc0 arg-2)) (let ((e-2 (vector-ref sc0 2))) (lambda (arg-3) ((e-2 'erased) arg-3))))))
(define PreludeC-45Interfaces-map (lambda (arg-0 arg-1 arg-2 arg-3 ext-0 ext-1) ((((arg-3 'erased) 'erased) ext-0) ext-1)))
(define PreludeC-45Interfaces-C-62C-62C-61 (lambda (arg-0 arg-1 arg-2 arg-3) (let ((sc0 arg-3)) (let ((e-2 (vector-ref sc0 2))) (lambda (arg-4) (lambda (arg-5) ((((e-2 'erased) 'erased) arg-4) arg-5)))))))
(define PrimIO-case--unsafePerformIO-532 (lambda (arg-0 arg-1 arg-2 arg-3) (PrimIO-unsafeDestroyWorld 'erased 'erased arg-3)))
(define PrimIO-case--caseC-32blockC-32inC-32io_bind-453 (lambda (arg-0 arg-1 arg-2 arg-3 arg-4 arg-5 arg-6 arg-7) (arg-7 arg-6)))
(define PrimIO-case--io_bind-431 (lambda (arg-0 arg-1 arg-2 arg-3 arg-4 arg-5) (PrimIO-case--caseC-32blockC-32inC-32io_bind-453 'erased 'erased 'erased 'erased 'erased arg-5 'erased (arg-3 arg-5))))
(define PrimIO-unsafePerformIO (lambda (arg-0 arg-1) (PrimIO-unsafeCreateWorld 'erased (lambda (w) (PrimIO-case--unsafePerformIO-532 'erased arg-1 'erased (arg-1 w))))))
(define PrimIO-unsafeDestroyWorld (lambda (arg-0 arg-1 arg-2) arg-2))
(define PrimIO-unsafeCreateWorld (lambda (arg-0 arg-1) (arg-1 #f)))
(define PrimIO-io_pure (lambda (arg-0 arg-1 ext-0) arg-1))
(define PrimIO-io_bind (lambda (arg-0 arg-1 arg-2 arg-3 ext-0) (PrimIO-case--io_bind-431 'erased 'erased 'erased arg-3 'erased (arg-2 ext-0))))
(define PrimIO-fromPrim (lambda (arg-0 arg-1) arg-1))
(define PreludeC-45IO-pure_Applicative_IO (lambda (arg-0 arg-1 ext-0) arg-1))
(define PreludeC-45IO-map_Functor_IO (lambda (arg-0 arg-1 arg-2 arg-3 ext-0) (let ((act-3 (arg-3 ext-0))) (arg-2 act-3))))
(define PreludeC-45IO-liftIO_HasIO_C-36io (lambda (arg-0 arg-1 arg-2 arg-3) (let ((sc0 arg-2)) (let ((e-2 (vector-ref sc0 2))) ((e-2 'erased) arg-3)))))
(define PreludeC-45IO-liftIO1_HasLinearIO_IO (lambda (arg-0 arg-1) arg-1))
(define PreludeC-45IO-join_Monad_IO (lambda (arg-0 arg-1 ext-0) (let ((act-2 (arg-1 ext-0))) (act-2 ext-0))))
(define PreludeC-45IO-__Impl_Monad_IO (lambda () (vector 0 (vector 0 (lambda (b) (lambda (a) (lambda (func) (lambda (arg-149) (lambda (eta-0) (PreludeC-45IO-map_Functor_IO 'erased 'erased func arg-149 eta-0)))))) (lambda (a) (lambda (arg-482) (lambda (eta-0) arg-482))) (lambda (b) (lambda (a) (lambda (arg-483) (lambda (arg-485) (lambda (eta-0) (let ((act-17 (arg-483 eta-0))) (let ((act-16 (arg-485 eta-0))) (act-17 act-16))))))))) (lambda (b) (lambda (a) (lambda (arg-644) (lambda (arg-645) (lambda (eta-0) (let ((act-24 (arg-644 eta-0))) ((arg-645 act-24) eta-0))))))) (lambda (a) (lambda (arg-647) (lambda (eta-0) (let ((act-29 (arg-647 eta-0))) (act-29 eta-0))))))))
(define PreludeC-45IO-__Impl_HasLinearIO_IO (lambda () (vector 0 (vector 0 (vector 0 (lambda (b) (lambda (a) (lambda (func) (lambda (arg-149) (lambda (eta-0) (PreludeC-45IO-map_Functor_IO 'erased 'erased func arg-149 eta-0)))))) (lambda (a) (lambda (arg-482) (lambda (eta-0) arg-482))) (lambda (b) (lambda (a) (lambda (arg-483) (lambda (arg-485) (lambda (eta-0) (let ((act-17 (arg-483 eta-0))) (let ((act-16 (arg-485 eta-0))) (act-17 act-16))))))))) (lambda (b) (lambda (a) (lambda (arg-644) (lambda (arg-645) (lambda (eta-0) (let ((act-24 (arg-644 eta-0))) ((arg-645 act-24) eta-0))))))) (lambda (a) (lambda (arg-647) (lambda (eta-0) (let ((act-51 (arg-647 eta-0))) (act-51 eta-0)))))) (lambda (a) (lambda (arg-7251) arg-7251)))))
(define PreludeC-45IO-__Impl_HasIO_C-36io (lambda (arg-0 arg-1) (vector 0 (let ((sc0 arg-1)) (let ((e-1 (vector-ref sc0 1))) e-1)) (lambda (a) (lambda (arg-7222) (let ((sc0 arg-1)) (let ((e-2 (vector-ref sc0 2))) ((e-2 'erased) arg-7222))))))))
(define PreludeC-45IO-__Impl_Functor_IO (lambda (ext-4 ext-1 ext-2 ext-3 ext-0) (PreludeC-45IO-map_Functor_IO 'erased 'erased ext-2 ext-3 ext-0)))
(define PreludeC-45IO-__Impl_Applicative_IO (lambda () (vector 0 (lambda (b) (lambda (a) (lambda (func) (lambda (arg-149) (lambda (eta-0) (PreludeC-45IO-map_Functor_IO 'erased 'erased func arg-149 eta-0)))))) (lambda (a) (lambda (arg-482) (lambda (eta-0) arg-482))) (lambda (b) (lambda (a) (lambda (arg-483) (lambda (arg-485) (lambda (eta-0) (let ((act-17 (arg-483 eta-0))) (let ((act-16 (arg-485 eta-0))) (act-17 act-16)))))))))))
(define PreludeC-45IO-__HasLinearIO_C-40MonadC-32ioC-41 (lambda (arg-0 arg-1) (let ((sc0 arg-1)) (let ((e-1 (vector-ref sc0 1))) e-1))))
(define PreludeC-45IO-__HasIO_C-40MonadC-32ioC-41 (lambda (arg-0 arg-1) (let ((sc0 arg-1)) (let ((e-1 (vector-ref sc0 1))) e-1))))
(define PreludeC-45IO-C-62C-62C-61_Monad_IO (lambda (arg-0 arg-1 arg-2 arg-3 ext-0) (let ((act-1 (arg-2 ext-0))) ((arg-3 act-1) ext-0))))
(define PreludeC-45IO-C-60C-42C-62_Applicative_IO (lambda (arg-0 arg-1 arg-2 arg-3 ext-0) (let ((act-6 (arg-2 ext-0))) (let ((act-5 (arg-3 ext-0))) (act-6 act-5)))))
(define PreludeC-45IO-putStr (lambda (arg-0 arg-1 arg-2) (let ((sc0 arg-1)) (let ((e-2 (vector-ref sc0 2))) ((e-2 'erased) (lambda (eta-0) (PreludeC-45IO-prim__putStr arg-2 eta-0)))))))
(define PreludeC-45IO-primIO (lambda (arg-0 arg-1 arg-2 arg-3) (let ((sc0 arg-2)) (let ((e-2 (vector-ref sc0 2))) ((e-2 'erased) arg-3)))))
(define PreludeC-45IO-liftIO1 (lambda (arg-0 arg-1 arg-2) (let ((sc0 arg-2)) (let ((e-2 (vector-ref sc0 2))) (lambda (arg-3) ((e-2 'erased) arg-3))))))
(define PreludeC-45IO-liftIO (lambda (arg-0 arg-1 arg-2) (let ((sc0 arg-2)) (let ((e-2 (vector-ref sc0 2))) (lambda (arg-3) ((e-2 'erased) arg-3))))))
(define PreludeC-45IO-getLine (lambda (arg-0 arg-1) (let ((sc0 arg-1)) (let ((e-2 (vector-ref sc0 2))) ((e-2 'erased) (lambda (eta-0) (PreludeC-45IO-prim__getStr eta-0)))))))
(define DataC-45Strings-case--caseC-32blockC-32inC-32wordsC-39-1425 (lambda (arg-0 arg-1 arg-2) (let ((sc0 arg-2)) (let ((e-2 (vector-ref sc0 1))) (let ((e-3 (vector-ref sc0 2))) (vector 1 e-2 (DataC-45Strings-wordsC-39 e-3)))))))
(define DataC-45Strings-case--wordsC-39-1412 (lambda (arg-0 arg-1) (let ((sc0 arg-1)) (case (vector-ref sc0 0) ((0) (vector 0 ))(else (DataC-45Strings-case--caseC-32blockC-32inC-32wordsC-39-1425 arg-0 arg-1 (DataC-45List-break 'erased (lambda (eta-0) (PreludeC-45Types-isSpace eta-0)) arg-1)))))))
(define DataC-45Strings-n--2242-1447-addSpace (lambda (arg-0 arg-1 arg-2) (PreludeC-45TypesC-45List-C-43C-43 'erased arg-1 (vector 1 #\  arg-2))))
(define DataC-45Strings-wordsC-39 (lambda (arg-0) (DataC-45Strings-case--wordsC-39-1412 arg-0 (DataC-45List-dropWhile 'erased (lambda (eta-0) (PreludeC-45Types-isSpace eta-0)) arg-0))))
(define DataC-45Strings-words (lambda (arg-0) (PreludeC-45Types-map_Functor_List 'erased 'erased (lambda (eta-0) (PreludeC-45Types-pack eta-0)) (DataC-45Strings-wordsC-39 (PreludeC-45Types-unpack arg-0)))))
(define DataC-45Strings-unwordsC-39 (lambda (arg-0) (let ((sc0 arg-0)) (case (vector-ref sc0 0) ((0) (vector 0 ))(else (DataC-45Strings-foldr1 'erased (lambda (eta-0) (lambda (eta-1) (DataC-45Strings-n--2242-1447-addSpace arg-0 eta-0 eta-1))) arg-0))))))
(define DataC-45Strings-unwords (lambda (ext-0) (PreludeC-45Types-pack (DataC-45Strings-unwordsC-39 (PreludeC-45Types-map_Functor_List 'erased 'erased (lambda (eta-0) (PreludeC-45Types-unpack eta-0)) ext-0)))))
(define DataC-45Strings-foldr1 (lambda (arg-0 arg-1 arg-2) (let ((sc0 arg-2)) (case (vector-ref sc0 0) ((1) (let ((e-1 (vector-ref sc0 1))) (let ((e-2 (vector-ref sc0 2))) (let ((sc1 e-2)) (case (vector-ref sc1 0) ((0) e-1)(else ((arg-1 e-1) (DataC-45Strings-foldr1 'erased arg-1 e-2))))))))(else (Builtin-idris_crash 'erased "Unhandled input for Data.Strings.foldr1 at Data/Strings.idr:12:1--12:17"))))))
(define DataC-45List-case--caseC-32blockC-32inC-32span-1641 (lambda (arg-0 arg-1 arg-2 arg-3 arg-4) (let ((sc0 arg-4)) (let ((e-2 (vector-ref sc0 1))) (let ((e-3 (vector-ref sc0 2))) (vector 0 (vector 1 arg-3 e-2) e-3))))))
(define DataC-45List-case--span-1621 (lambda (arg-0 arg-1 arg-2 arg-3 arg-4) (let ((sc0 arg-4)) (cond ((equal? sc0 0) (DataC-45List-case--caseC-32blockC-32inC-32span-1641 'erased arg-2 arg-3 arg-1 (DataC-45List-span 'erased arg-3 arg-2))) (else (vector 0 (vector 0 ) (vector 1 arg-1 arg-2)))))))
(define DataC-45List-case--dropWhile-1007 (lambda (arg-0 arg-1 arg-2 arg-3 arg-4) (let ((sc0 arg-4)) (cond ((equal? sc0 0) (DataC-45List-dropWhile 'erased arg-3 arg-2)) (else (vector 1 arg-1 arg-2))))))
(define DataC-45List-span (lambda (arg-0 arg-1 arg-2) (let ((sc0 arg-2)) (case (vector-ref sc0 0) ((0) (vector 0 (vector 0 ) (vector 0 ))) (else (let ((e-2 (vector-ref sc0 1))) (let ((e-3 (vector-ref sc0 2))) (DataC-45List-case--span-1621 'erased e-2 e-3 arg-1 (arg-1 e-2)))))))))
(define DataC-45List-dropWhile (lambda (arg-0 arg-1 arg-2) (let ((sc0 arg-2)) (case (vector-ref sc0 0) ((0) (vector 0 )) (else (let ((e-2 (vector-ref sc0 1))) (let ((e-3 (vector-ref sc0 2))) (DataC-45List-case--dropWhile-1007 'erased e-2 e-3 arg-1 (arg-1 e-2)))))))))
(define DataC-45List-break (lambda (arg-0 arg-1 arg-2) (DataC-45List-span 'erased (lambda (eta-0) (PreludeC-45Basics-not (arg-1 eta-0))) arg-2)))
(define Move-n--2368-2621-strMove (lambda (arg-0 arg-1) (let ((sc0 arg-1)) (cond ((equal? sc0 "R") (vector 0 )) ((equal? sc0 "R2") (vector 6 )) ((equal? sc0 "R'") (vector 12 )) ((equal? sc0 "L") (vector 1 )) ((equal? sc0 "L2") (vector 7 )) ((equal? sc0 "L'") (vector 13 )) ((equal? sc0 "U") (vector 2 )) ((equal? sc0 "U2") (vector 8 )) ((equal? sc0 "U'") (vector 14 )) ((equal? sc0 "D") (vector 3 )) ((equal? sc0 "D2") (vector 9 )) ((equal? sc0 "D'") (vector 15 )) ((equal? sc0 "F") (vector 4 )) ((equal? sc0 "F2") (vector 10 )) ((equal? sc0 "F'") (vector 16 )) ((equal? sc0 "B") (vector 5 )) ((equal? sc0 "B2") (vector 11 )) ((equal? sc0 "B'") (vector 17 ))(else (vector 0 ))))))
(define Move-n--2307-2559-moveStr (lambda (arg-0 arg-1) (let ((sc0 arg-1)) (case (vector-ref sc0 0) ((0) "R") ((6) "R2") ((12) "R'") ((1) "L") ((7) "L2") ((13) "L'") ((2) "U") ((8) "U2") ((14) "U'") ((3) "D") ((9) "D2") ((15) "D'") ((4) "F") ((10) "F2") ((16) "F'") ((5) "B") ((11) "B2") (else "B'")))))
(define Move-parseStr (lambda (arg-0) (PreludeC-45Types-map_Functor_List 'erased 'erased (lambda (eta-0) (Move-n--2368-2621-strMove arg-0 eta-0)) (DataC-45Strings-words arg-0))))
(define Move-moveString (lambda (arg-0) (DataC-45Strings-unwords (PreludeC-45Types-map_Functor_List 'erased 'erased (lambda (eta-0) (Move-n--2307-2559-moveStr arg-0 eta-0)) arg-0))))
(load-shared-object "libidris2_support.so")
(collect-request-handler (lambda () (collect) (blodwen-run-finalisers)))
(PrimIO-unsafePerformIO 'erased (Main-main))(collect 4)
(blodwen-run-finalisers))
