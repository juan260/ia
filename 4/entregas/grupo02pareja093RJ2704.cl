(defpackage :grupo02pareja093RJ2704 ; se declara un paquete lisp que usa common-lisp
	(:use :common-lisp :mancala) ; y mancala, y exporta la función de evaluación
	(:export :heuristica :*alias*)) ; heurística y un alias para el torneo

(in-package grupo02pareja093RJ2704)

(defun heuristica (estado) 
    (f-eval-ponderation estado '((26 60 22 28 12 6) (2 52 34 34 8 20)))) ; función de evaluación heurística a implementar

(defvar *alias* '|lala|) ; alias que aparecerá en el ranking

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
		(if 
          (< (suma-fila 
                 (estado-tablero estado) 
                 (estado-lado-sgte-jugador estado))
               (suma-fila
                 (estado-tablero estado) 
                 (lado-contrario (estado-lado-sgte-jugador estado))))
		  -1000
		  1000)
		 0)))
