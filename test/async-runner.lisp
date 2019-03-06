(defpackage #:noloop.cacau-test
  (:use #:common-lisp)
  (:nicknames #:cacau-test)
  (:import-from #:cacau
                #:make-runner
                #:suite-root
                #:add-child
                #:create-test
                #:once-runner
                #:run-runner))
(in-package #:noloop.cacau-test)

(let ((plan '()))

  (defun a-test (name fn)
    (push (list name fn) plan))

  (defun next-test-class (plan-tests)
    (let ((tests (reverse plan-tests)))
      (lambda ()
        (let* ((test (car tests))
               (test-name (car test))
               (test-fn (cadr test)))
          (when (> (length tests) 0)
            (setf tests (cdr tests))
            (format t "Test ~a: " test-name)
            (funcall test-fn #'async-done))))))

  (defun next-results-class (plan-tests)
    (let ((results '())
          (plan-length (length plan-tests)))
      (lambda (test-result)
        (push test-result results)
        (when (= (length results) plan-length)
          (format t "Runner Result: ~a"
                  (every #'(lambda (el)
                             (equal t el))
                         results))))))
  
  (defun a-run ()
    (let ((next-test (next-test-class plan))
          (next-results (next-results-class plan)))
      
      (defun async-done (test)
        (format t "~a~%" test)
        (funcall next-test)
        (funcall next-results test))

      (funcall next-test)
      (setf plan '()))))

;; (a-test :test-1 #'(lambda (done) (funcall done (= 1 3))))
;; (a-test :test-2 #'(lambda (done) (funcall done (= 2 2))))
;; (a-run)
