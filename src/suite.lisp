(in-package #:noloop.cacau)

(defclass suite-class (runnable)
  ((before-all :initform nil
               :accessor before-all)
   (after-all :initform nil
              :accessor after-all)
   (before-each :initform nil
                :accessor before-each)
   (after-each :initform nil
               :accessor after-each)
   (parents-before-each :initform (make-list-iterator)
                        :accessor parents-before-each)
   (parents-after-each :initform (make-list-iterator)
                       :accessor parents-after-each)
   (children :initform (make-list-iterator)
             :accessor children)
   (children-onlys :initform (make-list-iterator)
                   :accessor children-onlys)
   (only-p :initform nil
           :accessor only-p)
   (skip-p :initform nil
           :accessor skip-p)))

(defun make-suite (&key name parent)
  (make-instance 'suite-class
                 :name name
                 :parent parent))

(defmethod create-before-all ((suite suite-class) &rest args)
  (setf (before-all suite) (make-hook args)))

(defmethod create-after-all ((suite suite-class) &rest args)
  (setf (after-all suite) (make-hook args)))

(defmethod create-before-each ((suite suite-class) &rest args)
  (setf (before-each suite) (make-hook args)))

(defmethod add-child ((suite suite-class) child)
  (setf (parent child) suite)
  (add (children suite) child))

(defmethod run-runnable ((suite suite-class) &optional fn)
  (declare (ignore fn))
  (collect-before-each-recursive suite (parents-before-each suite))
  ;;(inspect suite)
  (start-iterator-reverse (children suite))
  (if (before-all suite)
      (run-runnable (before-all suite)
                    (lambda ()
                      (init-suite suite)))
      (init-suite suite)))

(defmethod init-suite ((suite suite-class))
  (format t "~%init-suite: ~a~%" (name suite))
  (let ((a (current-item (children suite))))
    (handler-case (run-runnable a)
     (division-by-zero (c)
       (print c)))))

(defmethod collect-before-each-recursive ((suite suite-class) parents-each)
  (when (before-each suite)
    (add parents-each (before-each suite)))
  (unless (eq :suite-root (name suite))
    (collect-before-each-recursive (parent suite) parents-each)))

(defmethod next-child ((suite suite-class))
  ;; (format t "~% index: ~a - length-itens: ~a~%"
  ;;         (current-index (children suite))
  ;;         (length (itens (children suite))))
  (next (children suite))
  ;;(inspect suite) -> suite-root
  ;;(format t "~%done-p: ~a~%" (done-p (children suite)))
  (if (done-p (children suite))
      (progn (format t "~%suite-end: ~a~%" (name suite))
             (emit (eventbus suite) :suite-end suite))
      (progn (format t "~%run-runnable-suite: ~a~%" (name suite))
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

