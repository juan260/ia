
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
	(unless (null lstolsts) 
			(if (null (caar lstolsts)) NIL
			(combine-list-lsts (car lstolsts) (combine-list-of-lsts (cdr lstolsts))))))























		;;(cons (append-elt-lst list (car lsts)) (combine-list-lsts list (cdr lsts)))))	




	;;(unless (null list)	
	;;(append (list (car list)) (cortar (cdr list)))))

