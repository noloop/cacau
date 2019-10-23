(in-package #:noloop.cacau)

(defclass runnable ()
  ((name :initarg :name
         :accessor name)
   (fn :initarg :fn
       :accessor fn)
   (parent :initarg :parent
           :accessor parent)
   (runnable-error :initform nil
                   :accessor runnable-error)
   (eventbus :initarg :eventbus
             :accessor eventbus)
   (timer :initform (make-timer)
          :accessor timer)
   (timeout :initarg :timeout
            :initform -1
            :accessor timeout)))

(defgeneric run-runnable (obj &optional fn)
  (:documentation "Something must be run, such as a test suite that calls run-runnable from each tests, or running a hook."))

(defgeneric after-run (obj)
  (:documentation "Something must be run after run-runnable."))

(defmethod done-runnable ((obj runnable))
  (lambda (&optional arg)
    "The done function accepts an optional argument, which can be either one error or function (useful for catch assertion-error)."
    (cond ((typep arg 'error) (setf (runnable-error obj) arg))
          ((typep arg 'function) (try-fn obj arg)))
    (after-run obj)))

(defmethod setf-assertion-error ((obj runnable) c)
  (let ((error-hash (make-hash-table)))
    (setf-hash error-hash 
               `((:actual ,(assertion-error-actual c))
                 (:expected ,(assertion-error-expected c))
                 (:message ,(assertion-error-message c))
                 (:result ,(assertion-error-result c))
                 (:stack ,(assertion-error-stack c))))
    (setf (runnable-error obj) error-hash)))

(defmethod setf-error ((obj runnable) error-msg)
  (let ((error-hash (make-hash-table)))
    (setf-hash error-hash 
               `((:actual nil)
                 (:expected nil)
                 (:message ,error-msg)
                 (:result nil)
                 (:stack ,(get-stack-trace))))
    (setf (runnable-error obj) error-hash)))

(defmethod try-fn ((obj runnable) try &key after-error-fn)
  (handler-case (funcall try)
    (assertion-error (c)
      (setf-assertion-error obj c)
      (when after-error-fn
        (funcall after-error-fn)))
    (error (c)
      (setf-error obj (format nil "~a" c))
      (when after-error-fn
        (funcall after-error-fn)))))

(defmethod inherit-timeout ((obj runnable))
  (unless (eq :suite-root (name obj))
    (when (and (= (timeout obj) -1)
               (/= (timeout (parent obj)) -1))
      (setf (timeout obj) (timeout (parent obj)))
      (start-timeout obj))))

(defmethod start-timeout ((obj runnable))
  (when (/= (timeout obj) -1)
    (setf (limit-ms (timer obj)) (timeout obj))
    (start-timer (timer obj))))

(defmethod timeout-extrapolated-p ((obj runnable))
  (let* ((result (extrapolated-p (timer obj))))
    (when result
      (setf-error
       obj
       (concatenate
        'string
        "Timeout Error: Time("
        (write-to-string (limit-ms (timer obj)))
        ") extrapolated!")))
    result))

