(in-package #:noloop.cacau)

(let ((runner nil)
      (current-suite nil))
  
  (defun common-runner () runner)
  
  (defun common-runner-init ()
    (setf runner (make-runner))
    (setf current-suite (suite-root runner)))

  (defun common-create-before-all (name fn &key (timeout -1))
    (create-before-all current-suite name fn :timeout timeout))

  (defun common-create-after-all (name fn &key (timeout -1))
    (create-after-all current-suite name fn :timeout timeout))

  (defun common-create-before-each (name fn &key (timeout -1))
    (create-before-each current-suite name fn :timeout timeout))

  (defun common-create-after-each (name fn &key (timeout -1))
    (create-after-each current-suite name fn :timeout timeout))

  (defun common-create-suite (name fn &key (only-p nil) (skip-p nil) (timeout -1))
    (let ((suite (create-suite runner name
                               :only-p only-p
                               :skip-p skip-p
                               :timeout timeout)))
      (let ((old-current-suite current-suite))
        (add-child current-suite suite)
        (setf current-suite suite)
        (funcall fn)
        (setf current-suite old-current-suite))
      suite))

  (defun common-create-suite-with-parent (name &key (only-p nil) (skip-p nil) (timeout -1) (parent :suite-root))
    (let ((suite (create-suite runner name
                               :only-p only-p
                               :skip-p skip-p
                               :timeout timeout)))
      (setf parent
             (if (equal parent :suite-root)
                 (suite-root runner)
                 (child-by-name (suite-root runner) parent)))
      (add-child parent suite)
      (setf current-suite suite)
      suite))

  (defun common-create-test (name fn &key (only-p nil) (skip-p nil) (timeout -1))
    (let ((test (create-test runner name fn
                             :only-p only-p
                             :skip-p skip-p
                             :timeout timeout)))
      (add-child current-suite test)
      test)))

(defmacro cond-options (options &body body)
  `(let ((only-p nil)
         (skip-p nil)
         (async nil)
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
                     (progn (setf async t)
                            (setf async-done (second i))))
                    ((equal :parent (first i))
                     (setf parent (second i)))))))
     ,@body))
