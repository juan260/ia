;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; prodEscRec (x y)
;;; Calcula el producto escalar de dos vectores de forma recursiva.
;;; 
;;; INPUT: x: vector, representado como una lista
;;; y: vector, representado como una lista
;;;
;;; OUTPUT: producto escalar
;;;
(defun prodEscRec (x y)
    (if (or (null x) (null y)) 
        0
    	(+ (* (first x) (first y)) (prodEscRec (cdr x) (cdr y)))))


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
(defun sc-rec (x y) 
	;;Falta comprobar la division por 0
    (/ (prodEscRec x y) (sqrt (* (prodEscRec x x) (prodEscRec y y)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; prodEscMapcar (x y)
;;; Calcula el producto escalar de dos vectores usando mapcar
;;; 
;;; INPUT: x: vector, representado como una lista
;;; y: vector, representado como una lista
;;;
;;; OUTPUT: producto escalar
;;;

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
	;; Falta comprobar dvision por 0
    (/ (prodEscMapcar x y) (sqrt (* (prodEscMapcar x x) (prodEscMapcar y y)))))
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; select (conf cat vs)
;;; Selecciona, de entre unos vectores ya ordenados (vs)
;;; los que superan el umbral de similaridad
;;;
;;; INPUT: conf: Nivel de confianza
;;; cat: vector que representa a una categoría, representado como una lista
;;; vs: vector de vectores
;;; OUTPUT: Vectores cuya similitud con respecto a la categoría es superior al
;;; nivel de confianza, ordenados

(defun select (conf cat vs)
	(if (>= (sc-rec (car vs) cat) conf) 
		vs
		(select conf cat (cdr vs))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; sc-conf (cat vs conf)
;;; Devuelve aquellos vectores similares a una categoria
;;; INPUT: cat: vector que representa a una categoría, representado como una lista
;;; vs: vector de vectores
;;; conf: Nivel de confianza
;;; OUTPUT: Vectores cuya similitud con respecto a la categoría es superior al
;;; nivel de confianza, ordenados

 

(defun sc-conf (cat vs conf) 
	(select conf cat (sort (copy-list vs)
		#'(lambda (x y) (< (sc-rec x cat) (sc-rec y cat))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; maxcadr (x y)
;;; Compara los segundos elementos de los vectores, y devuelve el 
;;; que tenga el maximo.
;;;
;;; INPUT: x, y: los vectores a comparar
;;; OUTPUT: vector con el mayor "second"
;;;

(defun maxcadr (x y) 
	(if(> (second x) (second y)) x y))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; classify (cats text func)
;;; Halla la categoría que se ajusta mas al texto text.
;;;
;;; INPUT: cats: vector de categorias
;;; text: texto para el que se quiere averiguar categoria
;;; func: funcion con la que calcular la similaridad
;;; OUTPUT: par formado por la categoria que mas se ajusta
;;; al texto y por el nivel de similaridad categoria-texto
;;;

(defun classify (cats text func)
	(if (null cats) '(-2 0)
		(maxcadr (list (caar cats) (funcall func (cdr text) (cdar cats))) 
				(classify (cdr cats) text func))))
	
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; sc-classifier (cats texts func)
;; Clasifica a los textos en categorías.
;;;
;;; INPUT: cats: vector de vectores, representado como una lista de listas
;;; texts: vector de vectores, representado como una lista de listas
;;; func: función para evaluar la similitud coseno
;;; OUTPUT: Pares identificador de categoría con resultado de similitud coseno
;;;	

(defun sc-classifier (cats texts func)
	(if (null texts) nil 
		(cons (classify cats (car texts) func)	
			(sc-classifier cats (cdr texts) func))))



