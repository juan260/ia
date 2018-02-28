;;;;;;;;;;;;;;;;;;;;;;; EJERCICIO 1.1 ;;;;;;;;;;;;;;;;;;

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
    
    
    
;;;;;;;;;;;;;;;;;;;;;;; EJERCICIO 1.2 ;;;;;;;;;;;;;;;;;;

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


;;;;;;;;;;;;;;;;;;;;;;; EJERCICIO 1.3 ;;;;;;;;;;;;;;;;;;

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




;;;;;;;;;;;;;;;;;;;;;;; EJERCICIO 2.1 ;;;;;;;;;;;;;;;;;;

;; Finds a root of f between the points a and b using bisection.
;;
;; If f(a)f(b)>=0 there is no guarantee that there will be a root in the
;; interval, and the function will return NIL.
;; INPUT:
;; f: function of a single real parameter with real values whose root we want to find
;; a: lower extremum of the interval in which we search for the root
;; b: b>a upper extremum of the interval in which we search for the root
;; tol: tolerance for the stopping criterion: if b-a < tol the function returns
;; (a+b)/2 as a solution.
;; OUTPUT: Root of the function

(defun bisect (f a b tol)
    (let ((medio (/ (+ a b) 2)))
        (cond ((< 0 (* (funcall f a) (funcall f b))) NIL )
              ((= 0 (funcall f a)) a)
              ((= 0 (funcall f b)) b)
              ((> tol (- b a)) medio)
              ((>= 0 (* (funcall f a) (funcall f medio))) (bisect f a medio tol))
              ((>= 0 (* (funcall f b) (funcall f medio))) (bisect f medio b tol)))))
              

;;;;;;;;;;;;;;;;;;;;;;; EJERCICIO 2.2 ;;;;;;;;;;;;;;;;;;

;; Funcion auxiliar
;; Igual que la funcion allroot, pero devuelve una lista que contiene las raices
;; intercaladas con NILs
;;
;;
;; INPUT:
;; f: function of a single real parameter with real values whose root
;; we want to find
;; lst: ordered list of real values (lst[i] < lst[i+1])
;; tol: tolerance for the stopping criterion: if b-a < tol the function
;; returns (a+b)/2 as a solution.
;;
;; Whenever sgn(f(lst[i])) != sgn(f(lst[i+1])) this function looks for a
;; root in the corresponding interval.
;;
;; OUTPUT:
;; A list o real values containing the roots of the function in the
;; given sub-intervals

(defun nils-n-root (f lst tol)
	(unless (null (rest lst)) 
		(cons (bisect f (first lst) (first (rest lst)) tol) (nils-n-root f (rest lst) tol ))))

;; Finds all the roots that are located between consecutive values of a list
;; of values
;;
;; INPUT:
;; f: function of a single real parameter with real values whose root
;; we want to find
;; lst: ordered list of real values (lst[i] < lst[i+1])
;; tol: tolerance for the stopping criterion: if b-a < tol the function
;; returns (a+b)/2 as a solution.
;;
;; Whenever sgn(f(lst[i])) != sgn(f(lst[i+1])) this function looks for a
;; root in the corresponding interval.
;;
;; OUTPUT:
;; A list o real values containing the roots of the function in the
;; given sub-intervals
		
(defun allroot (f lst tol)
	(remove nil (nils-n-root f lst tol)))

;;;;;;;;;;;;;;;;;;;;;;; EJERCICIO 2.3 ;;;;;;;;;;;;;;;;;;

;; Funcion auxiliar
;; Igual que la funcion allind, pero devuelve una lista que contiene las raices
;; intercaladas con NILs
;; 
;; INPUT:
;; f: function of a single real parameter with real values whose root we want to find
;; a: lower extremum of the interval in which we search for the root
;; b: b>a upper extremum of the interval in which we search for the root
;; N: Exponent of the number of intervals in which [a,b] is to be divided:
;; [a,b] is divided into 2^N intervals
;; tol: tolerance for the stopping criterion: if b-a < tol the function
;; returns (a+b)/2 as a solution.
;;
;; The interval (a,b) is divided in intervals (x[i], x[i+i]) with
;; x[i]= a + i*dlt; a root is sought in each interval, and all the roots
;; thus found are assembled into a list that is returned.
;;
;; OUTPUT: List with all the found roots.

(defun  introot (f incr fin actual tol)
	(unless (<= fin actual)
		(cons (bisect f actual (+ actual incr) tol) 
			  (introot f incr fin (+ actual incr) tol))))
			  

;; Divides an interval up to a specified length and find all the roots of
;; the function f in the intervals thus obtained.
;; INPUT:
;; f: function of a single real parameter with real values whose root we want to find
;; a: lower extremum of the interval in which we search for the root
;; b: b>a upper extremum of the interval in which we search for the root
;; N: Exponent of the number of intervals in which [a,b] is to be divided:
;; [a,b] is divided into 2^N intervals
;; tol: tolerance for the stopping criterion: if b-a < tol the function
;; returns (a+b)/2 as a solution.
;;
;; The interval (a,b) is divided in intervals (x[i], x[i+i]) with
;; x[i]= a + i*dlt; a root is sought in each interval, and all the roots
;; thus found are assembled into a list that is returned.
;;
;; OUTPUT: List with all the found roots.

(defun allind (f a b N tol)
	(remove nil (introot f (/ (- b a) (expt 2 N)) b a tol)))


;;;;;;;;;;;;;;;;;;;;;;; EJERCICIO 3.1 ;;;;;;;;;;;;;;;;;;

;; Combina un elto dado con todos los eltos de una lista
;;
;; INPUT:
;; elt: elemento a combinar con la lista
;; lst: llista quue sera combinada con el elemnto
;;
;; OUTPUT: lista que contenga la combinacion

(defun combine-elt-lst (elt lst)
	(unless (or (null lst) (null elt))
		(cons (list elt (first lst))
			  (combine-elt-lst elt (rest lst)) )))

;;;;;;;;;;;;;;;;;;;;;;; EJERCICIO 3.2 ;;;;;;;;;;;;;;;;;;

;; Funcion que devuelve el producto cartesiano de dos listas
;;
;; INPUT:
;; lst1, lst2 : listas a combinar
;;
;; OUTPUT: lista que contenga la combinacion

(defun combine-lst-lst (lst1 lst2)
	(unless (or (null lst1) (null lst2))
		(append (combine-elt-lst (first lst1) lst2)
			  (combine-lst-lst (rest lst1) lst2))))
			  
;;;;;;;;;;;;;;;;;;;;;;; EJERCICIO 3.3 ;;;;;;;;;;;;;;;;;;

;; Recibe una lista y devuelve una lista de listas cada
;; una de las cuales contiene uno de los elementos de la lista original
;;
;; INPUT:
;; lst : lista a cortar
;;
;; OUTPUT: lista de listas cada una de las cuales tiene un elemento


(defun cortar (lst)
	(unless  (null lst)
		(append (list (list(car lst))) (cortar (cdr lst)))))


;; Devuelve una lista resultado de añadir al principio de todas
;; las listas contenidas en lst el elemnto elt
;;
;; INPUT:
;; elt : elemento a añadira todas las listas
;; lst : lista de listas a las que añadir el elemento
;;
;; OUTPUT: lista que contenga todas las combinaciones	

(defun append-elt-lst (elt lst)
	(if (null lst) (list (list elt))
		(if (null (cdr lst))
			(list (append (list elt) (first lst)))
			(cons (append (list elt) (first lst))
			  (append-elt-lst elt (rest lst)) ))))



;; Recibe una lista A y una lista de listas B y añade cada elemento
;; de A a cada una de las listas de B de todas las maneras posibles
;; un elemento de cada lista
;;
;; INPUT:
;; lst : lista de la que tomar elementos
;; lsts: lista de listas a las que añadir los elementos de lst
;;
;; OUTPUT: lista que contenga todas las combinaciones


(defun combine-list-lsts (lst lsts)
	(unless  (or (null lst) (null lsts))
		(append (append-elt-lst (car lst) lsts) (combine-list-lsts (cdr lst) lsts))))
	
	
;; Función que calcula todas las posibles disposiciones de elementos
;; pertenecientes a N listas de forma que en cada disposición aparezca únicamente
;; un elemento de cada lista
;;
;; INPUT:
;; lstolsts : listas a combinar
;;
;; OUTPUT: lista que contenga todas las combinaciones
			
(defun combine-list-of-lsts (lstolsts)
	(print lstolsts)
	(if (null (cdr lstolsts)) 
		(cortar (car lstolsts))
		(if (null (cddr lstolsts)) 
			;; Las combina
			(combine-lst-lst (car lstolsts) (cadr lstolsts))
			;; Si no, la combina con el resultado de la recursión
			(combine-list-lsts (car lstolsts) (combine-list-of-lsts (cdr lstolsts))))))
	
	
	
	




