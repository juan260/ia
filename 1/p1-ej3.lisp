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

(defun combine-list-of-lsts (lstolsts)
	(if (atom (first lstolsts)) 
		(if (null (rest (rest lstolsts)))
			;; Caso (a (+ -)) -> combina a con (+ -)
			(combine-elt-lst (first lstolsts) (rest lstolsts) )
			;; Caso (a (+ -) (1 2)) -> combina a con el result de combinar ((+ -)(1 2))
			(combine-elt-lst (first lstolsts) 
							 (combine-list-of-lsts (rest lstolsts))
			)
		)
		;; Caso ((a b c) (+ -) (1 2)) -> recursion pura
		(append (combine-list-of-lsts (list (first (first lstolsts)) (rest lstolsts)))
				(combine-list-of-lsts (list (rest (first lstolsts)) (rest lstolsts)))
		)
	)
)

((A ((+ -) (1 2))) (B (((+ -) (1 2)))) (C ((((+ -) (1 2))))))

;; Este falla si una de las listas es un elemento

(defun combine-list-of-lsts (lstolsts)
	(if (atom (first lstolsts)) 
		(if (null (rest (rest lstolsts)))
			;; Caso (a (+ -)) -> combina a con (+ -)
			(combine-elt-lst (first lstolsts) (rest lstolsts) )
			;; Caso (a (+ -) (1 2)) -> combina a con el result de combinar ((+ -)(1 2))
			(combine-elt-lst (first lstolsts) 
							 (combine-list-of-lsts (rest lstolsts))
			)
		)
		;; Caso ((a b c) (+ -) (1 2)) -> recursion pura
		(append (combine-elt-lst (first (first lstolsts)) (rest lstolsts))
				(combine-list-of-lsts (list (rest (first lstolsts)) (rest lstolsts)))
		)
	)
)

((A (+ -)) (A (1 2)) (B ((+ -) (1 2))) (C (((+ -) (1 2)))))


(defun add-prefix (prefix list)
	(if (null list) NIL
		(cons (cons prefix (car list)) (add-prefix prefix (cdr list)))))
		
(defun combine-list-of-lsts (lstolsts)
		;;(print lstolsts)
		;; Fin de la recursion
		(if (null (car lstolsts)) 
			NIL
			;;Lista de un elemento
			(if (null (cadar lstolsts)) 
				(if (null (cdr lstolsts)) (car lstolsts)
					(add-prefix (caar lstolsts)
						(combine-list-of-lsts (cdr lstolsts))))
				;;Else
				(combine-list-of-lsts (cons (cdar lstolsts) (cdr lstolsts)))
					)))
					
					
					
(defun combine-list-of-lsts (lstolsts)
	;;(print lstolsts)
	;; Si es la penúltima lista
	(if (null (cddr lstolsts)) 
		;; Las combina
		(combine-lst-lst (car lstolsts) (cadr lstolsts))
		;; Si no, la combina con el resultado de la recursión
		(combine-lst-lst (car lstolsts) (combine-list-of-lists (cdr lstolsts)))))
	
	
	

