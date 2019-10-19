(in-package #:noloop.cacau)

(defclass timer-class ()
  ((limit-ms :initform -1
             :initarg :limit-ms
             :accessor limit-ms)
   (start-ms :initform 0
             :initarg :start-ms
             :accessor start-ms)
   (end-ms :initform 0
           :accessor end-ms)
   (duration-ms :initform 0
                :accessor duration-ms)))

(defun make-timer ()
  (make-instance 'timer-class))

(defmethod start-timer ((obj timer-class))
  (setf (start-ms obj) (get-internal-real-time)))

(defmethod end-timer ((obj timer-class))
  (setf (end-ms obj) (get-internal-real-time))
  (let ((duration (- (end-ms obj)
                     (start-ms obj))))
    (setf (duration-ms obj)
          (/ (if (<= duration 0) 1 duration)
             internal-time-units-per-second))))

(defmethod extrapolated-p ((obj timer-class))
  (let ((limit (limit-ms obj)))
    (if (= limit -1)
        nil
        (progn (end-timer obj)
               (> (duration-ms obj) limit)))))

