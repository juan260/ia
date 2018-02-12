;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; sc-rec (x y)
;;; Calcula la similitud coseno de un vector de forma recursiva
;;;
;;; Se asume que los dos vectores de entrada tienen la misma longitud.
;;; La semejanza coseno entre dos vectores que son listas vacías o que son
;;; (0 0...0) es NIL.
;;; INPUT: x: vector, representado como una lista
;;; y: vector, representado como una lista
;;;
;;; OUTPUT: similitud coseno entre x e y
;;;
(defun prodEscRec (x y)
    (if (or (null x) (null y)) 
        0
    	(+ (* (first x) (first y)) (prodEscRec (cdr x) (cdr y)))))


(defun sc-rec (x y) 
	;;Falta comprobar la division por 0
    (/ (prodEscRec x y) (sqrt (* (prodEscRec x x) (prodEscRec y y)))))


(defun prodEscMapcar (x y)
    (reduce #'+ (mapcar #'* x y)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; sc-mapcar (x y)
;;; Calcula la similitud coseno de un vector usando mapcar
;;;
;;; Se asume que los dos vectores de entrada tienen la misma longitud.
;;; La semejanza coseno entre dos vectores que son listas vacías o que son
;;; (0 0...0) es NIL.
;;; INPUT: x: vector, representado como una lista
;;; y: vector, representado como una lista
;;;
;;; OUTPUT: similitud coseno entre x e y
;;;
(defun sc-mapcar (x y) 
;;TODO: Falta comprobar la division por 0
    (/ (prodEscMapcar x y) (sqrt (* (prodEscMapcar x x) (prodEscMapcar y y)))))
    
    
    

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; sc-conf (cat vs conf)
;;; Devuelve aquellos vectores similares a una categoria
;;; INPUT: cat: vector que representa a una categoría, representado como una lista
;;; vs: vector de vectores
;;; conf: Nivel de confianza
;;; OUTPUT: Vectores cuya similitud con respecto a la categoría es superior al
;;; nivel de confianza, ordenados
(defun select (conf cat vs)
	(if (>= (sc-rec (car vs) cat) conf) 
		vs
		(select conf cat (cdr vs)))) 

(defun sc-conf (cat vs conf) 
	(select conf cat (sort (copy-list vs)
		#'(lambda (x y) (< (sc-rec x cat) (sc-rec y cat))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; sc-classifier (cats texts func)
;; Clasifica a los textos en categorías.
;;;
;;; INPUT: cats: vector de vectores, representado como una lista de listas
;;; texts: vector de vectores, representado como una lista de listas
;;; func: función para evaluar la similitud coseno
;;; OUTPUT: Pares identificador de categoría con resultado de similitud coseno
;;;

(defun maxcadr (x y) 
	(if(> (second x) (second y)) x y))

(defun classify (cats text func)
	(if (null cats) '(-2 0)
		(maxcadr (list (caar cats) (funcall func (cdr text) (cdar cats))) 
				(classify (cdr cats) text func))))
	
	
(defun sc-classifier (cats texts func)
	(if (null texts) nil 
		(cons (classify cats (car texts) func)	
			(sc-classifier cats (cdr texts) func))))


;;;; RENDIMIENTOS:
;;;;[28]> (time (sc-classifier cats texts #'sc-rec))
;;;;Real time: 1.54E-4 sec.
;;;;Run time: 0.0 sec.
;;;;Space: 192 Bytes
;;;;((1 1) (2 0.8017837))

;;;; RENDIMIENTOS
;;;;[29]> (time (sc-classifier cats texts #'sc-mapcar))
;;;;Real time: 1.35E-4 sec.
;;;;Run time: 0.0 sec.
;;;;Space: 768 Bytes
;;;;((1 1) (2 0.8017837))


;;;; RENDIMIENTOS CON LOS DATOS DEL ENUNCIADO

(setf cats '((1 43 23 12) (2 33 54 24)))
(setf texts '((1 3 22 134) (2 43 26 58)))
(time (sc-classifier cats texts #'sc-rec))
(time (sc-classifier cats texts #'sc-mapcar))

;;;;[32]> (time (sc-classifier cats texts #'sc-rec))
;;;;Real time: 1.51E-4 sec.
;;;;Run time: 0.0 sec.
;;;;Space: 160 Bytes
;;;;((2 0.48981872) (1 0.8155509))

;;;;[33]> (time (sc-classifier cats texts #'sc-mapcar))
;;;;Real time: 7.2E-5 sec.
;;;;Run time: 0.0 sec.
;;;;Space: 736 Bytes
;;;;((2 0.48981872) (1 0.8155509))
