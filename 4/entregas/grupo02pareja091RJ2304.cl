(defpackage :grupo02pareja091RJ2304 ; se declara un paquete lisp que usa common-lisp
	(:use :common-lisp :mancala) ; y mancala, y exporta la función de evaluación
	(:export :heuristica :*alias*)) ; heurística y un alias para el torneo

(in-package grupo02pareja091RJ2304)

(defun heuristica (estado) 
    (f-eval-ponderation-2 x '((-348	0 350) (212	0 -850)))) ; función de evaluación heurística a implementar

(defvar *alias* '|me_queme_tomando_el_sol|) ; alias que aparecerá en el ranking

(defun f-eval-ponderation-2 (estado parameters)
  (+ 
    (apply
      '+
      (calc-ponderations 
        (estado-tablero estado)
        (first parameters)
        (lado-contrario (estado-lado-sgte-jugador estado))
        0))
    (apply
      '+
      (calc-ponderations 
        (estado-tablero estado)
        (second parameters)
        (estado-lado-sgte-jugador estado)
        0))
    (if
      (juego-terminado-p estado)
      (if 
        (> 
          (suma-fila (estado-tablero estado) 
                     (estado-lado-sgte-jugador estado))
		  (suma-fila (estado-tablero estado) 
                     (lado-contrario (estado-lado-sgte-jugador estado))))
        -10000
        10000)
        0)))

(defun calc-ponderations (tablero parameters side posicion)
  (if 
    (equal posicion 6)          ; Si ya hemos ponderado las 5 posiciones, terminamos lista
    ()
    (cons                       ; Si no, devolvemos un cons de :
      (calc-ponderation         ; La ponderacion correspondiente a ese lado y posicion
        tablero
        parameters
        side 
        posicion)
      (calc-ponderations        ; Y la lista ponderacion correspondiente a demas posiciciones
        tablero
        parameters
        side
        (+ 1 posicion)))))

(defun calc-ponderation (tablero parameters side posicion)
  (let 
    ((num-fichas (get-fichas tablero side posicion)))
    (cond
      ; Si numfichas > 1+posicion, 1er coeficiente
      ((> num-fichas (+ 1 posicion))
       (first  parameters))
      ; Si numfichas < 1+posicion, 2o coeficiente
      ((< num-fichas (+ 1 posicion))
       (second parameters))
      ; Si numfichas = 1+posicion, 3er coeficiente
      (t
       (third parameters)))))
                  
