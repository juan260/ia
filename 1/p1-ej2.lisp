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
              

;;;;;;;;;;;;;;;;;;;;;;; EJERCICIO 2.2 ;;;;;;;;;;;;;;;;;;

 
;; Usamos esta funcion auxiliar, que se comporta como bisect pero
;; devuelve las raíces en una lista, para evitar tener que llamar dos veces
;; a la función bisect con cada iteración de mapcan. 

(defun bisect-aux (f a b tol)
  (unless (or (null a) (null b))
    (let ((medio (/ (+ a b) 2)))
        (cond ((< 0 (* (funcall f a) (funcall f b))) NIL )
              ((= 0 (funcall f a)) (list a))
              ((= 0 (funcall f b)) (list b))
              ((> tol (- b a)) (list medio))
              ((>= 0 (* (funcall f a) (funcall f medio))) (bisect f a medio tol))
              ((>= 0 (* (funcall f b) (funcall f medio))) (bisect f medio b tol))))))
               
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

;;;;;;;;;;;;;;;;;;;;;;; EJERCICIO 2.3 ;;;;;;;;;;;;;;;;;;

;; Funcion auxiliar
;; Igual que la funcion allind, pero devuelve una lista que contiene las raices
;; intercaladas con NILs
;; 
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

(defun  introot (f incr fin actual tol)
    (unless (<= fin actual)
        (cons (bisect f actual (+ actual incr) tol) 
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
    (remove nil (introot f (/ (- b a) (expt 2 N)) b a tol)))



