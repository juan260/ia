(defpackage :grupo02pareja091RJ2304 ; se declara un paquete lisp que usa common-lisp
	(:use :common-lisp :mancala) ; y mancala, y exporta la función de evaluación
	(:export :heuristica :*alias*)) ; heurística y un alias para el torneo

(in-package grupo02pareja091RJ2304)

(defun heuristica (estado) 
    (f-eval-ponderation-2 estado '((0 0 0 400000) (-10000 0 0 100000)))) ; función de evaluación heurística a implementar

(defvar *alias* '|oso_panda_oooso_panda|) ; alias que aparecerá en el ranking

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
      ;Si podemos efectuar un robo 4to coeficiente * numero de fichas robables
      ((and (< num-fichas (- 6 posicion))
            (eql (get-fichas tablero side (+ posicion num-fichas)) 0))
            
            (* (get-fichas tablero (lado-contrario side) (- 5 (+ posicion num-fichas)))
                (fourth parameters)))
      ; Si numfichas > 6 - posicion, 1er coeficiente
      ((> num-fichas (- 6 posicion))
       (first  parameters))
      ; Si numfichas < 6 - posicion, 2o coeficiente
      ((< num-fichas (- 6 posicion))
       (second parameters))
      ; Si numfichas = 6 - posicion, 3er coeficiente
      (t
       (third parameters)))))
                  
