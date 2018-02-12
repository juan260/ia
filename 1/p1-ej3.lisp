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

;; Función que calcula todas las posibles disposiciones de elementos
;; pertenecientes a N listas de forma que en cada disposición aparezca únicamente
;; un elemento de cada lista
;;
;; INPUT:
;; lstolsts : listas a combinar
;;
;; OUTPUT: lista que contenga todas las combinaciones


(defun cortar (lst)
	(unless  (null lst)
		(append (list (list(car lst))) (cortar (cdr lst)))))
	

(defun append-elt-lst (elt lst)
	(if (null lst) (list (list elt))
		(if (null (cdr lst))
			(list (append (list elt) (first lst)))
			(cons (append (list elt) (first lst))
			  (append-elt-lst elt (rest lst)) ))))


(defun combine-list-lsts (lst lsts)
	(unless  (or (null lst) (null lsts))
		(append (append-elt-lst (car lst) lsts) (combine-list-lsts (cdr lst) lsts))))
	
			
(defun combine-list-of-lsts (lstolsts)
	(print lstolsts)
	(if (null (cdr lstolsts)) 
		(cortar (car lstolsts))
		(if (null (cddr lstolsts)) 
			;; Las combina
			(combine-lst-lst (car lstolsts) (cadr lstolsts))
			;; Si no, la combina con el resultado de la recursión
			(combine-list-lsts (car lstolsts) (combine-list-of-lsts (cdr lstolsts))))))
	
	
	

