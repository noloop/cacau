(in-package #:noloop.cacau)

(defun common-create-before-all (name fn &key async-p (timeout -1))
  (create-before-all (current-suite (cacau-runner)) name fn :async-p async-p :timeout timeout))

(defun common-create-after-all (name fn &key async-p (timeout -1))
  (create-after-all (current-suite (cacau-runner)) name fn :async-p async-p :timeout timeout))

(defun common-create-before-each (name fn &key async-p (timeout -1))
  (create-before-each (current-suite (cacau-runner)) name fn :async-p async-p :timeout timeout))

(defun common-create-after-each (name fn &key async-p (timeout -1))
  (create-after-each (current-suite (cacau-runner)) name fn :async-p async-p :timeout timeout))

(defun common-create-suite (name fn &key (only-p nil) (skip-p nil) (timeout -1))
  (let ((suite (create-suite (cacau-runner) name
                             :only-p only-p
                             :skip-p skip-p
                             :timeout timeout)))
    (let ((old-current-suite (current-suite (cacau-runner))))
      (add-child (current-suite (cacau-runner)) suite)
      (setf (current-suite (cacau-runner)) suite)
      (funcall fn)
      (setf (current-suite (cacau-runner)) old-current-suite))
    suite))

(defun common-create-suite-with-parent (name &key only-p skip-p (timeout -1) (parent :suite-root))
  (let ((suite (create-suite (cacau-runner) name
                             :only-p only-p
                             :skip-p skip-p
                             :timeout timeout)))
    (setf parent
          (if (equal parent :suite-root)
              (suite-root (cacau-runner))
              (child-by-name (suite-root (cacau-runner)) parent)))
    (add-child parent suite)
    (setf (current-suite (cacau-runner)) suite)
    suite))

(defun common-create-test (name fn &key async-p only-p skip-p (timeout -1))
  (let ((test (create-test (cacau-runner) name fn
			   :async-p async-p
                           :only-p only-p
                           :skip-p skip-p
                           :timeout timeout)))
    (add-child (current-suite (cacau-runner)) test)
    test))

(defmacro cond-options (options &body body)
  `(let ((only-p nil)
         (skip-p nil)
         (async-p nil)
         (async-done nil)
         (timeout -1)
         (parent :suite-root))
     (dolist (i ,options)
       (cond ((equal :only i)
              (setf only-p t))
             ((equal :skip i)
              (setf skip-p t))
             ((listp i)
              (cond ((equal :timeout (first i))
                     (setf timeout (second i)))
                    ((equal :async (first i))
                     (progn (setf async-p t)
                            (setf async-done (second i))))
                    ((equal :parent (first i))
                     (setf parent (second i)))))))
     ,@body))
