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
             :accessor eventbus
             :allocation :class)
   (timer :initform (make-timer)
          :accessor timer)))

(defgeneric run-runnable (obj &optional fn)
  (:documentation "Something must be run, such as a test suite that calls run-runnable from each tests, or running a hook."))

(defun inherit-timeout (obj)
  (unless (eq :suite-root (name obj))
    (when (and (= (limit-ms (timer obj)) -1)
               (/= (limit-ms (timer (parent obj))) -1))
      ;;(format t "~%name: ~a~%" (name obj))
      ;;(format t "~%limite-ms parent: ~a~%" (limit-ms (timer (parent obj))))
      (timeout obj (limit-ms (timer (parent obj)))))))

(defun timeout (obj limit)
  (setf (limit-ms (timer obj)) limit)
  (start-timer (timer obj)))

(defun timout-extrapolated-p (obj)
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
        ") extrapolated!")))))

(defun setf-error (obj error-msg)
  (let ((error-hash (make-hash-table)))
    (setf-hash error-hash 
               `((:actual nil)
                 (:expected nil)
                 (:message ,error-msg)
                 (:result nil)
                 (:stack ,(get-stack-trace))))
    (setf (runnable-error obj) error-hash)))

