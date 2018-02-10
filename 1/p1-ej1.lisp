;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; sc-rec (x y)
;;; Calcula la similitud coseno de un vector de forma recursiva
;;;
;;; INPUT: x: vector, representado como una lista
;;; y: vector, representado como una lista
;;;
;;; OUTPUT: similitud coseno entre x e y
;;;
(defun prodEscRec (x y)
    (if (or (null x) (null y)) 
        0
     (+ (* (first x) (first y)) (prodEscRec (cdr x) (cdr y)))
     )
)


(defun sc-rec (x y) 
;;Falta comprobar la division por 0
    (/ (prodEscRec x y) (sqrt (* (prodEscRec x x) (prodEscRec y y)))))


(defun 

(defun prodEscMapcar (x y)
    (if (or (null x) (null y)) 
        0
     (+ (* (first x) (first y)) (prodEscRec (cdr x) (cdr y)))
     )
)
