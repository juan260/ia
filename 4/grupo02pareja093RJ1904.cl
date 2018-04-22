(defpackage :grupo02pareja091RJ1804 ; se declara un paquete lisp que usa common-lisp
	(:use :common-lisp :mancala) ; y mancala, y exporta la función de evaluación
	(:export :heuristica :*alias*)) ; heurística y un alias para el torneo

(in-package grupo02pareja009RJDIAMES)

(defun heuristica (estado) 
    (f-eval-ponderation estado '(0 0 0 75 25 150) (0 0 0 50 125 100))) ; función de evaluación heurística a implementar

(defvar *alias* '|chocolate_a_la_taza|) ; alias que aparecerá en el ranking

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
            (estado-tablero estado))))
                  
