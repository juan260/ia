(defpackage :grupo02pareja092RJ2504 ; se declara un paquete lisp que usa common-lisp
	(:use :common-lisp :mancala) ; y mancala, y exporta la función de evaluación
	(:export :heuristica :*alias*)) ; heurística y un alias para el torneo

(in-package grupo02pareja092RJ2504)

(defun heuristica (estado) 
    (f-eval-ponderation estado '((125 100 75 0 0 0)(50 25 150 0 0 0)))) ; función de evaluación heurística a implementar

(defvar *alias* '|por_la_selva_tropical|) ; alias que aparecerá en el ranking

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
		    -1000
		    1000)
		 0)))

