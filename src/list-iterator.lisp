(in-package #:noloop.cacau)

(defclass list-iterator ()
  ((itens :initform '()
          :accessor itens)
   (current-index :initform -1
                  :accessor current-index)))

(defun make-list-iterator ()
  (make-instance 'list-iterator))

(defmethod add ((obj list-iterator) item) 
  ;; (format t "~%add: ~a in ~a~%" (name item) (itens obj))
  (push item (itens obj)))

(defmethod start-iterator ((obj list-iterator))
  (let ((itens-reverse (reverse (itens obj))))
    (setf (current-index obj) -1)
    (setf (itens obj) itens-reverse)))

(defmethod next ((obj list-iterator))
  "Increment current-index returning the current item if it exists. If there was extrapolation, then returns nil."
  (incf (current-index obj))
  (unless (done-p obj)
    (nth (current-index obj) (itens obj))))

(defmethod done-p ((obj list-iterator))
  (>= (current-index obj) (length (itens obj))))

(defmethod last-p ((obj list-iterator))
  (= (current-index obj) (- (length (itens obj)) 1)))

(defmethod current-item ((obj list-iterator))
  (when (done-p obj)
    (error "Iterator Out Of Bounds!"))
  (nth (current-index obj) (itens obj)))
