(in-package #:noloop.cacau)

(defclass list-iterator ()
  ((itens :initform '()
          :accessor itens)
   (current-index :initform 0
                  :accessor current-index)))

(defun make-list-iterator ()
  (make-instance 'list-iterator))

(defmethod add ((obj list-iterator) item) 
  (push item (itens obj)))

(defmethod start-iterator ((obj list-iterator))
  (setf (current-index obj) 0))

(defmethod start-iterator-reverse ((obj list-iterator))
  (let ((itens-reverse (reverse (itens obj))))
    (setf (current-index obj) 0)
    (setf (itens obj) itens-reverse)))

(defmethod next ((obj list-iterator))
  (incf (current-index obj)))

(defmethod done-p ((obj list-iterator))
  (>= (current-index obj) (length (itens obj))))

(defmethod last-p ((obj list-iterator))
  (= (current-index obj) (- (length (itens obj)) 1)))

(defmethod current-item ((obj list-iterator))
  (when (done-p obj)
    (error "Iterator Out Of Bounds!"))
  (nth (current-index obj) (itens obj)))

(defmethod empty-p ((obj list-iterator))
  (<= (length (itens obj)) 0))

