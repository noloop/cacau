(defpackage #:noloop.cacau-test
  (:use #:common-lisp
        #:assert-p
        #:cacau)
  (:nicknames #:cacau-test))
(in-package #:noloop.cacau-test)

;;; How to use:
;;; (r-test :test-1 #'(lambda (done) (funcall done (= 1 3))))
;;; (r-test :test-2 #'(lambda (done) (funcall done (= 2 2))))
;;; (r-test :test-3 #'(lambda (done) (funcall done)))
;;; (r-run)
(let ((plan '()))

  (defun r-test (name fn)
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
            (funcall test-fn #'recursive-done))))))

  (defun next-results-class (plan-tests)
    (let ((results '())
          (plan-length (length plan-tests)))
      (lambda (test-result)
        (push test-result results)
        (when (= (length results) plan-length)
          (format t "Runner Result: ~a"
                  (every #'(lambda (el)
                             (eq t el))
                         results))))))

  (defun r-run ()
    (let ((next-test (next-test-class plan))
          (next-results (next-results-class plan)))
      
      (defun recursive-done (&optional (test nil test-supplied-p))
        (let ((test-result nil))
          (if test-supplied-p
              (setf test-result test)
              (setf test-result t))
          (format t "~a~%" test-result)
          (funcall next-test)
          (funcall next-results test-result)))

      (handler-case (funcall next-test)
        (error (c)
          (setf plan '())
          (error c)))
      (setf plan '()))))

