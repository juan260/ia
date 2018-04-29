(defpackage :grupo02pareja091RJ2204 ; se declara un paquete lisp que usa common-lisp
	(:use :common-lisp :mancala) ; y mancala, y exporta la función de evaluación
	(:export :heuristica :*alias*)) ; heurística y un alias para el torneo

(in-package grupo02pareja091RJ2204)

(defun heuristica (estado) 
    (f-eval-ponderation estado '((100 2 3 4 5 6) (7 8 9 10 110 10)))) ; función de evaluación heurística a implementar

(defvar *alias* '|me_queme_tomando_el_sol|) ; alias que aparecerá en el ranking

(defun ponderate (position ponderation lado tablero)
    (if (null ponderation)
        0
        (+ (* (first ponderation)
            (get-fichas tablero lado position))
            (ponderate (+ position 1)
                (rest ponderation)
                lado tablero))))

(defun f-eval-ponderation (estado ponderations)
    (+ (ponderate 0 (first ponderations)
            (lado-contrario (estado-lado-sgte-jugador estado)) 
            (estado-tablero estado))
       (ponderate 0 (second ponderations)
            (estado-lado-sgte-jugador estado)
            (estado-tablero estado))
	(if  (juego-terminado-p estado)
		(if (> (suma-fila (estado-tablero estado) (estado-lado-sgte-jugador estado))
			(suma-fila (estado-tablero estado) (lado-contrario (estado-lado-sgte-jugador estado))))
		    -10000
		    10000)
		 0)))
                  
