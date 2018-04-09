(defpackage :grupo02pareja009RJDIAMES ; se declara un paquete lisp que usa common-lisp
	(:use :common-lisp :mancala) ; y mancala, y exporta la función de evaluación
	(:export :heuristica :*alias*)) ; heurística y un alias para el torneo

(in-package grupo02pareja009RJDIAMES)

(defun heuristica (estado) …) ; función de evaluación heurística a implementar

(defvar *alias* '|EYOEYO|) ; alias que aparecerá en el ranking

(defun …) ; funciones auxiliares usadas por heurística
