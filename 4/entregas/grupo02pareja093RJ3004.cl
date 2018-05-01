(defpackage :grupo02pareja093RJ3004 ; se declara un paquete lisp que usa common-lisp
	(:use :common-lisp :mancala) ; y mancala, y exporta la función de evaluación
	(:export :heuristica :*alias*)) ; heurística y un alias para el torneo

(in-package grupo02pareja093RJ3004)

(defun heuristica (estado) 
    (f-eval-ponderation estado '((40 60 80 50 60 50) (30 34 40 80 70 70)))) ; función de evaluación heurística a implementar

(defvar *alias* '|tres_sardina|) ; alias que aparecerá en el ranking

(defun ponderate (position ponderation lado tablero)
    (if (null ponderation)
        0
        (+ (* (first ponderation)
            (get-fichas tablero lado position))
            (ponderate (+ position 1)
                (rest ponderation)
                lado tablero))))

(defun f-eval-ponderation (estado ponderations parameters)
    (+ (ponderate 0 (first ponderations)
            (lado-contrario (estado-lado-sgte-jugador estado)) 
            (estado-tablero estado))
       (ponderate 0 (second ponderations)
            (estado-lado-sgte-jugador estado)
            (estado-tablero estado))))

