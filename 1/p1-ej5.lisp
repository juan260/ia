;;;;;;;;;;;;;;;; Ejercicio 5.3 ;;;;;;;;;;;;;;;;;;;;
;;; Breadth-first-search in graphs
;;;
(defun bfs (end queue net)
	(if (null queue) '() ;; No quedan listas en cola: hemos terminado
		(let* ((path (first queue))
			     (node (first path)))
		   (if (eql node end) 
		   		;; Si hemos llegado al destino: invertimos camino y esa es nuestra solucion
				 (reverse path) 
			    ;; Else, aniadimos a la parte restante de la cola los nuevos caminos 
			    ;; (que tienen a los nodos adyacentes como inicio) y repetimos 			  
			    (bfs end    
				    (append (rest queue)
						  (new-paths path node net))
				    net)))))
;; Para todos los adyacentes a node creo un nuevo camino 
;; uniendo el nodo adyacente con el camino que ya conociamos del padre 
(defun new-paths (path node net)
	(mapcar #'(lambda(n)
				(cons n path))
			  (rest (assoc node net))))
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun shortest-path (start end net)
	(bfs end (list (list start)) net))
	
	
;;;;;;;;;;;;;;;; Ejercicio 5.8 ;;;;;;;;;;;;;;;;;;;;
;; La función es pŕacticamente idéntica a la del ejercicio
;; 5.3, con la salvedad de que al añadir nuevos nodos a la cola
;; llama a la funcion new-paths-no-repetition que antes de añadir un 
;; camino nuevo, comprueba que no tiene nodos repetidos.
;; De esta manera nunca hay caminos que formen un bucle infinito.
;;

(defun filter (func list)
	(unless (null list)
	(if (funcall func (first list))
		(cons (first list) (filter (rest list))))))


(defun list-contains (lst elt)
	(unless (null lst)
		(or (eql (first lst) elt)
			(list-contains (rest lst) elt))))

(defun new-paths-no-repetition (path node net)
		(mapcar #'(lambda(n)
					(cons n path))
			  (filter #'(lambda(n)
			  		(not (list-contains path n)))
			  		(rest (assoc node net)))))
	
	
(defun bfs-improved (end queue net) 
	(if (null queue) '() ;; No quedan listas en cola: hemos terminado
		(let* ((path (first queue))
			     (node (first path)))
		   (if (eql node end) 
		   		;; Si hemos llegado al destino: invertimos camino y esa es nuestra solucion
				 (reverse path) 
			    ;; Else, aniadimos a la parte restante de la cola los nuevos caminos 
			    ;; (que tienen a los nodos adyacentes como inicio) y repetimos 			  
			    (bfs-improved end    
				    (append (rest queue)
						  (new-paths-no-repetition path node net))
				    net)))))
	
(defun shortest-path-improved (start end net)
	(bfs-improved end (list (list start)) net))
	
