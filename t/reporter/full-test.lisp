(in-package #:noloop.cacau-test)

;; (r-test
;;  :test-full-reporter
;;  (lambda (r-done)
;;    (defsuite :suite-1 ()
;;      (let ((x 0))
;;        (defbefore-all "Before-all Suite-1" () (setf x 1))
;;        (deftest "Test-1" () (eql-p x 1))
;;        (deftest "Test-2" ((:async done)) (incf x) (eql-p x 2) (funcall done))
;;        (defsuite :suite-2 ()
;;          (let ((x 0))
;;            (defafter-all "After-all Suite-2" ((:async done-hook)) (setf x 1) (funcall done-hook))
;;            (deftest "Test-1" ((:async done)) (incf x) (eql-p x 1) (funcall done))
;;            (deftest "Test-2" () (eql-p x 1))
;;            (defsuite :suite-3 ()
;;              (let ((x 0))
;;                (defbefore-each "Before-each Suite-3" () (setf x 1))
;;                (deftest "Test-1" () (incf x) (eql-p x 2))
;;                (deftest "Test-2" () (eql-p x 0))))))))
;;    (defsuite :suite-4 ()
;;      (let ((x 0))
;;        (defafter-each "After-each Suite-4" ()  (setf x 0))
;;        (deftest "Test-1" (:skip) (incf x) (eql-p x 1))
;;        (deftest "Test-2" ((:async done)) (eql-p x 0) (funcall done))))
;;    (let ((out (with-output-to-string (*standard-output*)
;;                 (let ((*standard-input* (make-string-input-stream "n")))
;;                   (cacau-run
;;                    :reporter :full
;;                    :colorful nil
;;                    :reporter-options
;;                    '(:tests-list
;;                     (:epilogue
;;                      (:running-suites
;;                       :running-tests
;;                       :only-suites
;;                       :only-tests
;;                       :skip-suites
;;                       :skip-tests
;;                       :total-suites
;;                       :total-tests
;;                       :passing
;;                       :failing
;;                       :errors
;;                       :completed-suites
;;                       :completed-tests))
;;                     :stack))))))
;;      (funcall r-done (equal out "
;; <=> Cacau <=>

;; :SUITE-1
;;  -> Test-1
;;  -> Test-2
;;  :SUITE-2
;;   -> Test-1
;;   -> Test-2
;;  :SUITE-3
;;   -> Test-1
;;   <- Test-2: 1 EQL 0
;; :SUITE-4
;;  -> Test-2

;; Epilogue
;; -------------------------
;; 2 running suites
;; 7 running tests
;; 0 only suites
;; 0 only tests
;; 0 skip suites
;; 1 skip tests
;; 4 total suites
;; 8 total tests
;; 6 passed
;; 1 failed
;; 1 errors
;; 0 completed suites
;; 7 completed tests

;; Errors
;; -------------------------
;; In Test: Test-2
;; Message: 1 EQL 0

;; Read Stack (y/n)? ")))))

;; (r-test
;;  :test-full-reporter-colorful
;;  (lambda (r-done)
;;    (defsuite :suite-1 ()
;;      (let ((x 0))
;;        (defbefore-all "Before-all Suite-1" () (setf x 1))
;;        (deftest "Test-1" () (eql-p x 1))
;;        (deftest "Test-2" ((:async done)) (incf x) (eql-p x 2) (funcall done))
;;        (defsuite :suite-2 ()
;;          (let ((x 0))
;;            (defafter-all "After-all Suite-2" ((:async done-hook)) (setf x 1) (funcall done-hook))
;;            (deftest "Test-1" ((:async done)) (incf x) (eql-p x 1) (funcall done))
;;            (deftest "Test-2" () (eql-p x 1))
;;            (defsuite :suite-3 ()
;;              (let ((x 0))
;;                (defbefore-each "Before-each Suite-3" () (setf x 1))
;;                (deftest "Test-1" () (incf x) (eql-p x 2))
;;                (deftest "Test-2" () (eql-p x 0))))))))
;;    (defsuite :suite-4 ()
;;      (let ((x 0))
;;        ;;(defafter-each "After-each Suite-4" ()  (setf x 0))
;;        (deftest "Test-1" (:skip) (incf x) (eql-p x 1))
;;        (deftest "Test-2" ((:async done)) (eql-p x 1) (funcall done))))
;;    (cacau-run
;;     :reporter :full
;;     :colorful t)
;;    (funcall r-done nil)
;;    ;; (let ((out (with-output-to-string (*standard-output*)
;; ;;                 (let ((*standard-input* (make-string-input-stream "n n")))
;; ;;                   (cacau-run
;; ;;                    :reporter :full
;; ;;                    :colorful t
;; ;;                    ;; :reporter-options
;; ;;                    ;; '(:tests-list
;; ;;                    ;;   (:epilogue
;; ;;                    ;;    (:running-suites
;; ;;                    ;;     :running-tests
;; ;;                    ;;     :only-suites
;; ;;                    ;;     :only-tests
;; ;;                    ;;     :skip-suites
;; ;;                    ;;     :skip-tests
;; ;;                    ;;     :total-suites
;; ;;                    ;;     :total-tests
;; ;;                    ;;     :passing
;; ;;                    ;;     :failing
;; ;;                    ;;     :errors
;; ;;                    ;;     :completed-suites
;; ;;                    ;;     :completed-tests))
;; ;;                    ;;   :stack)
;; ;;                    )))))
;; ;;      ;;(print out)
;; ;;      (funcall r-done (equal out "
;; ;; <=> Cacau <=>

;; ;; :SUITE-1
;; ;;  -> Test-1
;; ;;  -> Test-2
;; ;;  :SUITE-2
;; ;;   -> Test-1
;; ;;   -> Test-2
;; ;;  :SUITE-3
;; ;;   -> Test-1
;; ;;   <- Test-2: 1 EQL 0
;; ;; :SUITE-4
;; ;;  -> Test-2

;; ;; -------------------------
;; ;; 2 running suites
;; ;; 7 running tests
;; ;; 0 only suites
;; ;; 0 only tests
;; ;; 0 skip suites
;; ;; 1 skip tests
;; ;; 4 total suites
;; ;; 8 total tests
;; ;; 6 passed
;; ;; 1 failed
;; ;; 1 errors
;; ;; 0 completed suites
;; ;; 7 completed tests

;; ;; -------------------------

;; ;; In Test: Test-2
;; ;; Message: 1 EQL 0


;; ;; Read Stack (y/n)? ")))
;;    ))

;; (r-test
;;  :test-cl-interface
;;  (lambda (r-done)
;;    (defsuite :suite-1 ()
;;      (let ((x 0))
;;        (defbefore-all "Before-all Suite-1" () (setf x 1))
;;        (deftest "Test-1" () (eql-p x 1))
;;        (deftest "Test-2" ((:async done)) (incf x) (eql-p x 2) (funcall done))
;;        (defsuite :suite-2 ()
;;          (let ((x 0))
;;            (defafter-all "After-all Suite-2" ((:async done-hook)) (setf x 1) (funcall done-hook))
;;            (deftest "Test-1" ((:async done)) (incf x) (eql-p x 1) (funcall done))
;;            (deftest "Test-2" () (eql-p x 1))
;;            (defsuite :suite-3 ()
;;              (let ((x 0))
;;                (defbefore-each "Before-each Suite-3" () (setf x 1))
;;                (deftest "Test-1" () (incf x) (eql-p x 2))
;;                (deftest "Test-2" () (eql-p x 1))))))))
;;    (defsuite :suite-4 ()
;;      (let ((x 0))
;;        (defafter-each "After-each Suite-4" ()  (setf x 0))
;;        (deftest "Test-1" () (incf x) (eql-p x 1))
;;        (deftest "Test-2" ((:async done)) (eql-p x 1) (funcall done))))
;;    (cacau-run
;;     :reporter :off
;;     :end-hook
;;     (lambda (runner)
;;       (let ((passing
;;               (gethash :passing (result runner))))
;;         (inspect (result runner))
;;         (funcall r-done (eql 7 passing)))))))

