;;;;;;;;;;;;;;;;;;;;;;; EJERCICIO 2.1 ;;;;;;;;;;;;;;;;;;

;; Finds a root of f between the points a and b using bisection.
;;
;; If f(a)f(b)>=0 there is no guarantee that there will be a root in the
;; interval, and the function will return NIL.
;; INPUT:
;; f: function of a single real parameter with real values whose root we want to find
;; a: lower extremum of the interval in which we search for the root
;; b: b>a upper extremum of the interval in which we search for the root
;; tol: tolerance for the stopping criterion: if b-a < tol the function returns
;; (a+b)/2 as a solution.
;; OUTPUT: Root of the function
    
(defun bisect (f a b tol)
    (let ((medio (/ (+ a b) 2)))
        (cond ((< 0 (* (funcall f a) (funcall f b))) NIL )
              ((= 0 (funcall f a)) a)
              ((= 0 (funcall f b)) b)
              ((> tol (- b a)) medio)
              ((>= 0 (* (funcall f a) (funcall f medio))) (bisect f a medio tol))
              ((>= 0 (* (funcall f b) (funcall f medio))) (bisect f medio b tol)))))
              

 (bisect #'(lambda(x) (sin (* 6.26 x))) 0.1 0.7 0.001)
;; 0.5016602
(bisect #'(lambda(x) (sin (* 6.26 x))) 0.0 0.7 0.001)
;; 0.0
(bisect #'(lambda(x) (sin (* 6.26 x))) 1.1 1.5 0.001)
;; NIL
(bisect #'(lambda(x) (sin (* 6.26 x))) 1.1 0.6 0.0000001)
;; 0.85
(bisect #'(lambda(x) (sin (* 6.26 x))) 1.1 0.7 0.0000001)
;; 0.9
(bisect #'(lambda(x) (sin (* 6.26 x))) 1.1 0.75 0.000000001)
;; 0.925


;;;;;;;;;;;;;;;;;;;;;;; EJERCICIO 2.2 ;;;;;;;;;;;;;;;;;;
 
;; Usamos esta funcion auxiliar, que se comporta como bisect pero
;; devuelve las raices en una lista, para evitar tener que llamar dos veces
;; a la funcion bisect con cada iteracion de mapcan. 

(defun bisect-aux (f a b tol)
  (unless (or (null a) (null b))
    (let ((medio (/ (+ a b) 2)))
        (cond ((< 0 (* (funcall f a) (funcall f b))) NIL )
              ((= 0 (funcall f a)) (list a))
              ((= 0 (funcall f b)) (list b))
              ((> tol (- b a)) (list medio))
              ((>= 0 (* (funcall f a) (funcall f medio))) (bisect-aux f a medio tol))
              ((>= 0 (* (funcall f b) (funcall f medio))) (bisect-aux f medio b tol))))))
               
;; Finds all the roots that are located between consecutive values of a list
;; of values
;;
;; INPUT:
;; f: function of a single real parameter with real values whose root
;; we want to find
;; lst: ordered list of real values (lst[i] < lst[i+1])
;; tol: tolerance for the stopping criterion: if b-a < tol the function
;; returns (a+b)/2 as a solution.
;;
;; Whenever sgn(f(lst[i])) != sgn(f(lst[i+1])) this function looks for a
;; root in the corresponding interval.
;;
;; OUTPUT:
;; A list o real values containing the roots of the function in the
;; given sub-intervals
        
(defun allroot (f lst tol)
  (unless (null (rest lst))
    (mapcan #'(lambda(x y) (bisect-aux f x y tol))
            lst
            (rest lst)))) 

(allroot #'(lambda(x) (sin (* 6.28 x))) '(0.25 0.75 1.25 1.75 2.25) 0.0001)
;; (0.50027466 1.0005188 1.5007629 2.001007)
(allroot #'(lambda(x) (sin (* 6.28 x))) '(0.25 0.9 0.75 1.25 1.75 2.25) 0.0001)
;; (0.5002166 1.0005188 1.5007629 2.001007)

;;;;;;;;;;;;;;;;;;;;;;; EJERCICIO 2.3 ;;;;;;;;;;;;;;;;;;

;; Funcion auxiliar
;; Busca raices en intervalos de tamanio incr en (actual, fin)
;; 

(defun  introot (f incr fin actual tol)
    (unless (<= fin actual)
        (union (bisect-aux f actual (+ actual incr) tol) 
              (introot f incr fin (+ actual incr) tol))))
              

;; Divides an interval up to a specified length and find all the roots of
;; the function f in the intervals thus obtained.
;; INPUT:
;; f: function of a single real parameter with real values whose root we want to find
;; a: lower extremum of the interval in which we search for the root
;; b: b>a upper extremum of the interval in which we search for the root
;; N: Exponent of the number of intervals in which [a,b] is to be divided:
;; [a,b] is divided into 2^N intervals
;; tol: tolerance for the stopping criterion: if b-a < tol the function
;; returns (a+b)/2 as a solution.
;;
;; The interval (a,b) is divided in intervals (x[i], x[i+i]) with
;; x[i]= a + i*dlt; a root is sought in each interval, and all the roots
;; thus found are assembled into a list that is returned.
;;
;; OUTPUT: List with all the found roots.

(defun allind (f a b N tol)
    (introot f (/ (- b a) (expt 2 N)) b a tol))


;; EXAMPLES
(allind #'(lambda(x) (sin (* 6.28 x))) 0.1 2.25 1 0.0001)
;; NIL
(allind #'(lambda(x) (sin (* 6.28 x))) 0.1 2.25 2 0.0001)
;; (0.50027096 1.000503 1.5007349 2.0010324)

