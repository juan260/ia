(defvar *ponderations* '((0 0 0 150 125 75)(0 0 0 50 25 100)))


(defun f-j-nmx (estado profundidad-max f-eval)
;;;(negamax-a-b estado profundidad-max f-eval))
  (negamax estado profundidad-max f-eval))

(defvar *jdr-nmx-helado* (make-jugador
                        :nombre   '|tu-cree-que-yo-soi-guapa|
                        :f-juego  #'f-j-nmx
                        :f-eval   #'(lambda (x) (f-eval-ponderation x *ponderations*))))
(evaluador *jdr-nmx-helado* 200)
