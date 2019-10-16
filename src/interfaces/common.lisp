(in-package #:noloop.cacau)

(let ((runner nil)
      (suites nil))
  
  (defun common-runner ()
    runner)
  
  (defun common-runner-init ()
    (setf runner (make-runner))
    (setf suites (list (suite-root runner))))

  (defun common-create-before-all (name fn &key (timeout -1))
    (create-before-all (first suites) name fn :timeout timeout))

  (defun common-create-after-all (name fn &key (timeout -1))
    (create-after-all (first suites) name fn :timeout timeout))

  (defun common-create-before-each (name fn &key (timeout -1))
    (create-before-each (first suites) name fn :timeout timeout))

  (defun common-create-after-each (name fn &key (timeout -1))
    (create-after-each (first suites) name fn :timeout timeout))

  (defun common-create-suite (name fn &key (only-p nil) (skip-p nil) (timeout -1))
    (let ((suite (create-suite runner name
                               :only-p only-p
                               :skip-p skip-p
                               :timeout timeout)))
      (add-child (first suites) suite)
      (push suite suites)
      (funcall fn)
      (setf suites (rest suites))
      suite))

  (defun common-create-test (name fn &key (only-p nil) (skip-p nil) (timeout -1))
    (let ((test (create-test runner name fn
                             :only-p only-p
                             :skip-p skip-p
                             :timeout timeout)))
      (add-child (first suites) test)
      test)))

