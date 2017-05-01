;; -*- lexical-binding: t; -*-

(expectations
 (desc "stub setup/teardown")
 (expect 2
         (stub/setup 'foo 2)
         (prog1
             (foo 1 2 3)
           (stub/teardown 'foo)))
 (expect nil
         (stub/setup 'foox 2)
         (foox 1 2 3)
         (stub/teardown 'foox)
         (fboundp 'foox))
 (desc "with-mock interface")
 (expect 9801
         (with-mock
          9801))
 (desc "stub macro")
 (expect nil
         (with-mock
          (stub hogehoges)
          (hogehoges 75)))
 (expect 2
         (with-mock
          (stub fooz => 2)
          (fooz 9999)))
 (expect nil
         (with-mock
          (stub fooz => 2)
          (fooz 3))
         (fboundp 'fooz))
 (expect nil
         (with-mock
          (stub hoge)                   ;omission of return value
          (hoge)))
 (expect 'hoge
         (with-mock
          (stub me => 'hoge)
          (me 1)))
 (expect 34
         (with-mock
          (stub me => (+ 3 31))
          (me 1)))
 ;; ;; TODO defie mock-syntax-error / detect mock-syntax-error in expectations
 ;; (desc "abused stub macro")
 ;; (expect (error mock-syntax-error '("Use `(stub FUNC)' or `(stub FUNC => RETURN-VALUE)'"))
 ;;         (with-mock
 ;;          (stub fooz 7)))
 (expect (error-message "Do not use `stub' outside")
         (let (in-mocking  ; while executing `expect', `in-mocking' is t.
               (text-quoting-style 'grave))
           (stub hahahaha)))
 (desc "mock macro")
 (expect 2
         (with-mock
          (mock (foom 5) => 2)
          (foom 5)))
 (expect 3
         (with-mock
          (mock (foo 5) => 2)
          (mock (bar 7) => 1)
          (+ (foo 5) (bar 7))))
 (expect 3
         (flet ((plus () (+ (foo 5) (bar 7))))
           (with-mock
            (mock (foo 5) => 2)
            (mock (bar 7) => 1)
            (plus))))
 (expect 1
         (with-mock
          (mock (f * 2) => 1)
          (f 1 2)))
 (expect 1
         (with-mock
          (mock (f * (1+ 1)) => (+ 0 1)) ;evaluated
          (f 1 2)))
 (expect nil
         (with-mock
          (mock (f 2))                  ;omission of return value
          (f 2)))
 (expect 'hoge
         (with-mock
          (mock (me 1) => 'hoge)
          (me 1)))
 (expect 34
         (with-mock
          (mock (me 1) => (+ 3 31))
          (me 1)))

 (desc "unfulfilled mock")
 (expect (error mock-error '((foom 5) (foom 6)))
         (with-mock
          (mock (foom 5) => 2)
          (foom 6)))
 (expect (error mock-error '((bar 7) (bar 8)))
         (with-mock
          (mock (foo 5) => 2)
          (mock (bar 7) => 1)
          (+ (foo 5) (bar 8))))
 (expect (error mock-error '(not-called foo))
         (with-mock
          (mock (foo 5) => 2)))
 (expect (error mock-error '(not-called foo))
         (with-mock
          (mock (vi 5) => 2)
          (mock (foo 5) => 2)
          (vi 5)))
 (expect (error mock-error '((f 2) (f 4)))
         (with-mock
          (mock (f 2))                  ;omission of return value
          (f 4)))
 (expect (error-message "error-in-test1")
         (defun test1 () (error "error-in-test1"))
         (with-mock
          (mock (test2))
          (test1)))
 ;; (desc "abused mock macro")
 ;; (expect (error mock-syntax-error '("Use `(mock FUNC-SPEC)' or `(mock FUNC-SPEC => RETURN-VALUE)'"))
 ;;         (with-mock
 ;;          (mock (fooz) 7)))
 (expect (error-message "Do not use `mock' outside")
         (let (in-mocking  ; while executing `expect', `in-mocking' is t.
               (text-quoting-style 'grave))
           (mock (hahahaha))))

 (desc "mock with stub")
 (expect 8
         (with-mock
          (mock (f 1 2) => 3)
          (stub hoge => 5)
          (+ (f 1 2) (hoge 'a))))
 (expect (error mock-error '((f 1 2) (f 3 4)))
         (with-mock
          (mock (f 1 2) => 3)
          (stub hoge => 5)
          (+ (f 3 4) (hoge 'a))))

 (desc "with-stub is an alias of with-mock")
 (expect 'with-mock
         (symbol-function 'with-stub))

 (desc "stublet is an alias of mocklet")
 (expect 'mocklet
         (symbol-function 'stublet))

 (desc "mock-parse-spec")
 (expect '(progn
            (mock (f 1 2) => 3)
            (stub hoge => 5))
         (mock-parse-spec
          '(((f 1 2) => 3)
            (hoge    => 5))))
 (expect '(progn
            (not-called g))
         (mock-parse-spec
          '((g not-called))))

 (desc "mocklet")
 (expect 8
         (mocklet (((f 1 2) => 3)
                   (hoge    => 5))
                  (+ (f 1 2) (hoge 'a))))
 (expect 2
         (mocklet ((foo => 2))
                  (foo 1 2 3)))
 (expect 3
         (defun defined-func (x) 3)
         (prog1
             (mocklet ((defined-func => 3))
                      (defined-func 3))
           (fmakunbound 'defined-func)))
 (expect nil
         (mocklet ((f))                  ;omission of return value
                  (f 91)))
 (expect nil
         (mocklet (((f 76)))             ;omission of return value
                  (f 76)))
 (expect 5
         (mocklet ((a => 3)
                   (b => 2))
                  1                             ;multiple exprs
                  (+ (a 999) (b 7))))

 (desc "stub for defined function")
 (expect "xxx"
         (defun blah (x) (* x 2))
         (prog1
             (let ((orig (symbol-function 'blah)))
               (mocklet ((blah => "xxx"))
                        (blah "xx")))
           (fmakunbound 'blah)))
 (expect t
         (defun blah (x) (* x 2))
         (prog1
             (let ((orig (symbol-function 'blah)))
               (mocklet ((blah => "xx"))
                        (blah "xx"))
               (equal orig (symbol-function 'blah)))
           (fmakunbound 'blah)))

 (desc "stub for adviced function")
 (expect "xxx"
         (mock-suppress-redefinition-message ;silence redefinition warning
          (lambda ()
            (defun fugaga (x) (* x 2))
            (defadvice fugaga (around test activate)
              (setq ad-return-value (concat "[" ad-return-value "]")))
            (prog1
                (let ((orig (symbol-function 'fugaga)))
                  (mocklet ((fugaga => "xxx"))
                           (fugaga "aaaaa")))
              (fmakunbound 'fugaga)))))
 (expect t
         (mock-suppress-redefinition-message
          (lambda ()
            (defun fugaga (x) (* x 2))
            (defadvice fugaga (around test activate)
              (setq ad-return-value (concat "[" ad-return-value "]")))
            (prog1
                (let ((orig (symbol-function 'fugaga)))
                  (mocklet ((fugaga => "xx"))
                           (fugaga "aaaaa"))
                  (equal orig (symbol-function 'fugaga)))
              (fmakunbound 'fugaga)))))

 (desc "mock for adviced function")
 (expect "xx"
         (mock-suppress-redefinition-message
          (lambda ()
            (defun fugaga (x) (* x 2))
            (defadvice fugaga (around test activate)
              (setq ad-return-value (concat "[" ad-return-value "]")))
            (prog1
                (let ((orig (symbol-function 'fugaga)))
                  (mocklet (((fugaga "aaaaa") => "xx"))
                           (fugaga "aaaaa")))
              (fmakunbound 'fugaga)))))
 (expect t
         (mock-suppress-redefinition-message
          (lambda ()
            (defun fugaga (x) (* x 2))
            (defadvice fugaga (around test activate)
              (setq ad-return-value (concat "[" ad-return-value "]")))
            (prog1
                (let ((orig (symbol-function 'fugaga)))
                  (mocklet (((fugaga "aaaaa") => "xx"))
                           (fugaga "aaaaa"))
                  (equal orig (symbol-function 'fugaga)))
              (fmakunbound 'fugaga)))))
 (desc "not-called macro")
 (expect 'ok
         (with-mock
          (not-called foom)
          'ok))
 (desc "mocklet/notcalled")
 (expect 'ok
         (mocklet ((foom not-called))
                  'ok))
 (desc "unfulfilled not-called")
 (expect (error mock-error '(called))
         (with-mock
          (not-called hoge)
          (hoge 1)))
 (desc "abused not-called macro")
 (expect (error-message "Do not use `not-called' outside")
         (let (in-mocking  ; while executing `expect', `in-mocking' is t.
               (text-quoting-style 'grave))
           (not-called hahahaha)))
 (desc "not-called for adviced function")
 (expect "not-called"
         (mock-suppress-redefinition-message ;silence redefinition warning
          (lambda ()
            (defun fugaga (x) (* x 2))
            (defadvice fugaga (around test activate)
              (setq ad-return-value (concat "[" ad-return-value "]")))
            (prog1
                (let ((orig (symbol-function 'fugaga)))
                  (mocklet ((fugaga not-called))
                           "not-called"))
              (fmakunbound 'fugaga)))))
 (expect t
         (mock-suppress-redefinition-message
          (lambda ()
            (defun fugaga (x) (* x 2))
            (defadvice fugaga (around test activate)
              (setq ad-return-value (concat "[" ad-return-value "]")))
            (prog1
                (let ((orig (symbol-function 'fugaga)))
                  (mocklet ((fugaga not-called))
                           "not-called")
                  (equal orig (symbol-function 'fugaga)))
              (fmakunbound 'fugaga)))))
 (desc ":times mock")
 (expect 'ok
         (with-mock
          (mock (foo 1) => 2 :times 2)
          (foo 1)
          (foo 1)
          'ok))
 (expect 'ok
         (with-mock
          (mock (foo *) => 2 :times 2)
          (foo 1)
          (foo 2)
          'ok))
 (expect 'ok
         (with-mock
          (mock (foo 1) :times 2)
          (foo 1)
          (foo 1)
          'ok))
 (expect 'ok
         (with-mock
          (mock (foo *) :times 2)
          (foo 1)
          (foo 2)
          'ok))
 ;; FIXME
 ;; (expect 'ok
 ;;   (with-mock
 ;;     (mock (foo 1) => 2 :times 2)
 ;;     (foo 1)
 ;;     (foo 1)
 ;;     (foo 2)
 ;;     'ok))
 (expect (error mock-error '((foo 1) :expected-times 2 :actual-times 1))
         (with-mock
          (mock (foo 1) :times 2)
          (foo 1)
          'ok))
 (expect (error mock-error '((foo *) :expected-times 2 :actual-times 1))
         (with-mock
          (mock (foo *) :times 2)
          (foo 1)
          'ok))
 (expect (error mock-error '((foo 1) (foo 2)))
         (with-mock
          (mock (foo 1) :times 2)
          (foo 2)
          'ok))
 (expect (error mock-error '(not-called foo))
         (with-mock
          (mock (foo 1) :times 2)
          'ok))
 (expect (error mock-error '((foo 1) :expected-times 2 :actual-times 1))
         (with-mock
          (mock (foo 1) => 2 :times 2)
          (foo 1)
          'ok))
 (expect (error mock-error '((foo *) :expected-times 2 :actual-times 1))
         (with-mock
          (mock (foo *) => 2 :times 2)
          (foo 1)
          'ok))
 (expect (error mock-error '((foo 1) (foo 2)))
         (with-mock
          (mock (foo 1) => 2 :times 2)
          (foo 2)
          'ok))
 (expect (error mock-error '(not-called foo))
         (with-mock
          (mock (foo 1) => 2 :times 2)
          'ok))

 (desc "too few arguments")
 (expect (error mock-error '((foo 1) (foo)))
   (with-mock
     (mock (foo 1))
     (foo)))
 )

(defun el-mock-test--signal ()
  (error "Foo"))


(ert-deftest preserve-stacktrace ()
  "Test that mocking doesn’t mess with the backtrace recorded by
‘ert-run-test’."
  (let ((result (ert-run-test
                 (make-ert-test
                  :body (lambda ()
                          (with-mock (el-mock-test--signal)))))))
    (should (ert-test-failed-p result))
    (should (equal (ert-test-failed-condition result)
                   '(error "Foo")))
    (should (equal (car-safe (ert-test-failed-backtrace result))
                   '(t el-mock-test--signal)))))
