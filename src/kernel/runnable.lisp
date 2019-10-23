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

(defmethod try-fn ((obj runnable) try &key after-error-fn)
  (handler-case (funcall try)
    (assertion-error (c)
      (let ((error-hash (make-hash-table)))
        (setf-hash error-hash 
                   `((:actual ,(assertion-error-actual c))
                     (:expected ,(assertion-error-expected c))
                     (:message ,(assertion-error-message c))
                     (:result ,(assertion-error-result c))
                     (:stack ,(assertion-error-stack c))))
        (setf (runnable-error obj) error-hash))
      (when after-error-fn
        (funcall after-error-fn)))
    (error (c)
      (setf-error obj (format nil "~a" c))
      (when after-error-fn
        (funcall after-error-fn)))))

(defun inherit-timeout (obj)
  (unless (eq :suite-root (name obj))
    (when (and (= (timeout obj) -1)
               (/= (timeout (parent obj)) -1))
      ;; (format t "~%name: ~a - timeout: ~a~%" (name obj) (timeout obj))
      ;; (format t "~%timeout parent: ~a~%" (timeout (parent obj)))
      (setf (timeout obj) (timeout (parent obj)))
      (start-timeout obj))))

(defun start-timeout (obj)
  (when (/= (timeout obj) -1)
    (setf (limit-ms (timer obj)) (timeout obj))
    (start-timer (timer obj))))

(defun timeout-extrapolated-p (obj)
  (let* ((result (extrapolated-p (timer obj))))
    ;; (format t "~%name: ~a~%limit-ms: ~a~%start-ms: ~a~%end-ms: ~a~%duration-ms: ~a~%"
    ;;         (name obj)
    ;;         (limit-ms (timer obj))
    ;;         (start-ms (timer obj))
    ;;         (end-ms (timer obj))
    ;;         (duration-ms (timer obj)))
    ;; (format t "~%result-time: ~a~%" result)
    ;; (format t "~%name: ~a~%" (name obj))
    (when result
      (setf-error
       obj
       (concatenate
        'string
        "Timeout Error: Time("
        (write-to-string (limit-ms (timer obj)))
        ") extrapolated!")))
    result))

(defun setf-error (obj error-msg)
  (let ((error-hash (make-hash-table)))
    (setf-hash error-hash 
               `((:actual nil)
                 (:expected nil)
                 (:message ,error-msg)
                 (:result nil)
                 (:stack ,(get-stack-trace))))
    (setf (runnable-error obj) error-hash)))

