(defpackage :grupo02pareja092RJ0105 ; se declara un paquete lisp que usa common-lisp
	(:use :common-lisp :mancala) ; y mancala, y exporta la función de evaluación
	(:export :heuristica :*alias*)) ; heurística y un alias para el torneo

(in-package grupo02pareja092RJ0105)

(defun heuristica (estado) 
    (f-eval-ponderation estado '((-92 -44 -44 -100 32 -60) (-116 -60 -8 0 -40 -84)) '((-108 64 20 56) (0 -24 -72 44)))) ; función de evaluación heurística a implementar

(defvar *alias* '|un_circo|) ; alias que aparecerá en el ranking

  
  
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
            (estado-tablero estado))
	(if  (juego-terminado-p estado)
		(if 
          (< (suma-fila 
                 (estado-tablero estado) 
                 (estado-lado-sgte-jugador estado))
               (suma-fila
                 (estado-tablero estado) 
                 (lado-contrario (estado-lado-sgte-jugador estado))))
		  -50000
		  50000)
		 0)
    (f-eval-ponderation-2 estado parameters)
    (- (suma-fila (estado-tablero estado) (estado-lado-sgte-jugador estado))
       (suma-fila (estado-tablero estado) (lado-contrario (estado-lado-sgte-jugador estado))))))







(defun f-eval-ponderation-2 (estado parameters)
  (+ 
    (apply
      '+
      (calc-ponderations 
        (estado-tablero estado)
        (first parameters)
        (estado-lado-sgte-jugador estado)
        0))
    (apply
      '+
      (calc-ponderations 
        (estado-tablero estado)
        (second parameters)
        (lado-contrario (estado-lado-sgte-jugador estado))
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
      ; Si numfichas = 6 - posicion, 3er coeficiente (maxima ganancia/perdida)
      (t
       (third parameters)))))
