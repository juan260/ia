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
    (unless (null lsts)
    (if (null (cdr lst))
        (append-elt-lst (car lst) lsts)
        (append (append-elt-lst (car lst) lsts) (combine-list-lsts (cdr lst) lsts)))))
    
    
;; Función que calcula todas las posibles disposiciones de elementos
;; pertenecientes a N listas de forma que en cada disposición aparezca únicamente
;; un elemento de cada lista
;;
;; INPUT:
;; lstolsts : listas a combinar
;;
;; OUTPUT: lista que contenga todas las combinaciones
            

(defun combine-list-of-lsts (lstolsts)
    
    (if (null lstolsts)
        '(NIL)
        (unless (null (car lstolsts))
        (combine-list-lsts (car lstolsts) (combine-list-of-lsts (cdr lstolsts))))))

