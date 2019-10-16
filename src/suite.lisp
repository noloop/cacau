(in-package #:noloop.cacau)

(defclass suite-class (runnable)
  ((suite-before-all :initform nil
                     :accessor suite-before-all)
   (suite-after-all :initform nil
                    :accessor suite-after-all)
   (suite-before-each :initform nil
                      :accessor suite-before-each)
   (suite-after-each :initform nil
                     :accessor suite-after-each)
   (parents-before-each :initform (make-list-iterator)
                        :accessor parents-before-each)
   (parents-after-each :initform (make-list-iterator)
                       :accessor parents-after-each)
   (children :initform (make-list-iterator)
             :accessor children)
   (only-p :initarg :only-p
           :initform nil
           :accessor only-p)
   (skip-p :initarg :skip-p
           :initform nil
           :accessor skip-p)))

(defun make-suite (&key name parent only-p skip-p (timeout -1))
  (make-instance 'suite-class
                 :name name
                 :parent parent
                 :only-p only-p
                 :skip-p skip-p
                 :timeout timeout))

(defmethod create-before-all ((suite suite-class) name fn &key (timeout -1))
  (setf (suite-before-all suite) (make-hook :name name
                                            :fn fn
                                            :timeout timeout))
  (setf (parent (suite-before-all suite)) suite)
  (suite-before-all suite))

(defmethod create-after-all ((suite suite-class) name fn &key (timeout -1))
  (setf (suite-after-all suite) (make-hook :name name
                                           :fn fn
                                           :timeout timeout))
  (setf (parent (suite-after-all suite)) suite)
  (suite-after-all suite))

(defmethod create-before-each ((suite suite-class) name fn &key (timeout -1))
  (setf (suite-before-each suite) (make-hook :name name
                                             :fn fn
                                             :timeout timeout))
  (setf (parent (suite-before-each suite)) suite)
  (suite-before-each suite))

(defmethod create-after-each ((suite suite-class) name fn &key (timeout -1))
  (setf (suite-after-each suite) (make-hook :name name
                                            :fn fn
                                            :timeout timeout))
  (setf (parent (suite-after-each suite)) suite)
  (suite-after-each suite))

(defmethod add-child ((suite suite-class) child)
  (setf (parent child) suite)
  (add (children suite) child)
  child)

(defmethod run-runnable ((suite suite-class) &optional fn)
  (declare (ignore fn))
  (collect-before-each-recursive suite (parents-before-each suite))
  (collect-after-each-recursive suite (parents-after-each suite))
  (start-iterator-reverse (parents-after-each suite))
  (start-iterator-reverse (children suite))
  (inherit-timeout suite)
  (start-timeout suite)
  ;; (format t "~%name: ~a~%" (name suite))
  ;; (inspect (suite-before-all suite))
  (if (suite-before-all suite)
      (run-runnable (suite-before-all suite)
                     (lambda ()
                       (init-suite suite)))
      (init-suite suite)))

(defmethod init-suite ((suite suite-class))
  ;;(format t "~%init-suite: ~a - ~a~%" (name suite) (empty-p (children suite)))
  (if (empty-p (children suite))
      (emit (eventbus suite) :suite-end suite)
      (run-runnable (current-item (children suite)))))

(defmethod collect-before-each-recursive ((suite suite-class) parents-each)
  (when (suite-before-each suite)
    (add parents-each (suite-before-each suite)))
  (unless (eq :suite-root (name suite))
    (collect-before-each-recursive (parent suite) parents-each)))

(defmethod collect-after-each-recursive ((suite suite-class) parents-each)
  (when (suite-after-each suite)
    (add parents-each (suite-after-each suite)))
  (unless (eq :suite-root (name suite))
    (collect-after-each-recursive (parent suite) parents-each)))

(defmethod next-child ((suite suite-class))
  (next (children suite))
  ;;(format t "~%done-p: ~a~%" (done-p (children suite)))
  (if (done-p (children suite))
      (progn ;;(format t "~%suite-end: ~a~%" (name suite))
        (emit (eventbus suite) :suite-end suite))
      (progn ;;(format t "~%run-runnable-suite: ~a~%" (name suite))
        (run-runnable (current-item (children suite))))))

(defmethod execute-suites-each ((suite suite-class) parents-each after-hook-fn)
  (if (done-p parents-each)
      (funcall after-hook-fn)
      (if (last-p parents-each)
          (run-runnable (current-item parents-each) after-hook-fn)
          (run-runnable
           (current-item parents-each)
           (lambda ()
             (next parents-each)
             (execute-suites-each suite parents-each after-hook-fn))))))

(defmethod inherit-only-recursive ((suite suite-class))
  (dolist (child (itens (children suite)))
    (when (only-p suite)
      (setf (only-p child) t))
    (when (typep child 'suite-class)
      (inherit-only-recursive child))))

(defmethod remove-not-only-children-recursive ((suite suite-class))
  (setf (itens (children suite))
        (remove-if-not
         #'(lambda (child)
             (when (typep child 'suite-class)
               (remove-not-only-children-recursive child))
             (when (has-only-recursive child)
               (setf (only-p child) t)))
         (itens (children suite)))))

(defun has-only-recursive (obj)
  (cond ((typep obj 'test-class)
         (only-p obj))
        ((typep obj 'suite-class)
         (some #'(lambda (child)
                   (cond ((typep child 'test-class)
                          (only-p child))
                         ((typep child 'suite-class)
                          (if (only-p child)
                              t 
                              (has-only-recursive child)))))
               (itens (children obj))))))

(defmethod remove-skip-children-recursive ((suite suite-class))
  (setf (itens (children suite))
        (remove-if
         #'(lambda (child)
             (when (typep child 'suite-class)
               (remove-skip-children-recursive child))
             (skip-p child))
         (itens (children suite)))))

(defmethod count-tests-recursive (list)
  (cond ((null list) 0)
        ((typep (first list) 'test-class)
         (+ 1 (count-tests-recursive (rest list))))
        ((typep (first list) 'suite-class)
         (+ (count-tests-recursive (itens (children (first list))))
            (count-tests-recursive (rest list))))))

(defmethod count-suites-recursive (list)
  (cond ((null list) 0)
        ((typep (first list) 'test-class)
         (count-suites-recursive (rest list)))
        ((typep (first list) 'suite-class)
         (count-suites-recursive (itens (children (first list))))
         (+ 1 (count-suites-recursive (rest list))))))

