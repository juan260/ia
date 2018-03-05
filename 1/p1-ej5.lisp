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


(defun shortest-path (start end net)
	(bfs end (list (list start)) net))
	
	
;;;;;;;;;;;;;;;; Ejercicio 5.8 ;;;;;;;;;;;;;;;;;;;;
;; La función es pŕacticamente idéntica a la del ejercicio
;; 5.3, con la salvedad de que al añadir nuevos nodos a la cola
;; llama a la funcion new-paths-no-repetition que antes de añadir un 
;; camino nuevo, comprueba que no tiene nodos repetidos.
;; De esta manera nunca hay caminos que formen un bucle infinito.
;;

;;;;
;; Funcion auxiliar que mira si la lista recibida como
;; primer argumento contiene el elemento recibido como segundo
;; argumento
;;;;
(defun list-contains (lst elt)
	(unless (null lst)
		(or (eql (first lst) elt)
			(list-contains (rest lst) elt))))


;;;;
;; Funcion auxiliar que dado un camino seguido hasta ahora,
;; el nodo actual, y el grafo, devuelve una lista de los
;; posibles siguientes caminos a seguir desde el nodo
;; actual, siempre y cuando estos no esten repetidos.
;;;;
(defun new-paths-no-repetition (path node net)
		(mapcan #'(lambda(n)
						;; Comprobamos que el camino seguido
						;; hasta ahora no contiene el siguiente nodo
						;; para evitar caminos con nodos repetidos
					(and (not (list-contains path n)) 
						(list (cons n path))))
			  		(rest (assoc node net))))
	
	
;;;;
;; Funcion de busqueda en anchura sin caminos con 
;; elementos repetidos.
;;;;
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
				    
;;;;
;;	Funcion mejorada de la busqueda de mejor camino entre dos nodos
;; mediante bfs-improved.
;;;;
(defun shortest-path-improved (start end net)
	(bfs-improved end (list (list start)) net))
	
