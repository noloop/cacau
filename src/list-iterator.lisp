(in-package #:noloop.cacau)

(defclass list-iterator ()
  ((itens :initform '()
          :accessor itens)
   (current-index :initform -1
                  :accessor current-index)))

(defun make-list-iterator ()
  (make-instance 'list-iterator))

(defmethod add ((obj list-iterator) item) 
  (push item (itens obj)))

(defmethod next ((obj list-iterator))
  "Increment current-index returning the current item if it exists. If there was extrapolation, then returns nil."
  (incf (current-index obj))
  (unless (done-p obj)
    (nth (current-index obj) (itens obj))))

(defmethod done-p ((obj list-iterator))
  (> (current-index obj) (length (itens obj))))
