(defun ponderate (position ponderation lado tablero)
    (unless (null ponderation)
        (+ (* (first ponderation)
            (get-fichas tablero lado position))
            (ponderate (+ position 1)
                (rest ponderation)
                lado tablero))))

(defun f-eval-ponderation (estado)
    (+ (ponderate 0 *ponderations* 
            (lado-contrario (estado-tablero estado)) 
            (estado-tablero estado))))

        
        
(defvar *jdr-nmx-ponderation* (make-jugador
                        :nombre   '|tu-cree-que-yo-soi-guapa|
                        :f-juego  #'f-j-nmx
                        :f-eval   #'f-eval-ponderation))
                 
#(defvar *ponderations* list(0, 0, ..., 0)
