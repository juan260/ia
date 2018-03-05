;;Pareja 09

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Definicion de simbolos que representan valores de verdad,
;; conectores y predicados para evaluar si una expresion LISP
;; es un valor de verdad o un conector
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defconstant +bicond+ '<=>)
(defconstant +cond+   '=>)
(defconstant +and+    '^)
(defconstant +or+     'v)
(defconstant +not+    '~)

(defun truth-value-p (x) 
  (or (eql x T) (eql x NIL)))

(defun unary-connector-p (x) 
  (eql x +not+))

(defun binary-connector-p (x) 
  (or (eql x +bicond+) 
      (eql x +cond+)))

(defun n-ary-connector-p (x) 
  (or (eql x +and+) 
      (eql x +or+)))

(defun n-or-binary-connector-p (x)
	(or (binary-connector-p x) (n-ary-connector x)))

(defun connector-p (x) 
  (or (unary-connector-p  x)
      (binary-connector-p x)
      (n-ary-connector-p   x)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EJERCICIO 4.1.1
;; Predicado para determinar si una expresion en LISP
;; es un literal positivo 
;;
;; RECIBE   : expresion 
;; EVALUA A : T si la expresion es un literal positivo, 
;;            NIL en caso contrario. 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun positive-literal-p (x)
	;; Tiene que cumplirse que es un atomo lisp, y que no es ni un 
	;; conector ni un valor deverdad
 	(and (atom x) (not (connector-p x)) (not (truth-value-p x))))
 	
 	

;; EJEMPLOS:
(positive-literal-p 'p)
;; evalua a T
(or (positive-literal-p T)
(positive-literal-p NIL)
(positive-literal-p '~)
(positive-literal-p '=>)
(positive-literal-p '(p))
(positive-literal-p '(~ p))
(positive-literal-p '(~ (v p q))))
;; evaluan a NIL


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EJERCICIO 4.1.2
;; Predicado para determinar si una expresion
;; es un literal negativo 
;;
;; RECIBE   : expresion x 
;; EVALUA A : T si la expresion es un literal negativo, 
;;            NIL en caso contrario. 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
(defun negative-literal-p (x)
    ;; Tiene que ser una lista, compuesta por:
    (if (listp x) (and (eql (car x) +not+)      ;; Un simbolo de negacion
          (positive-literal-p (cadr x))     ;; un literal positivo
                    (null (cddr x)))        ;; y nada mas
     NIL))
		

;; EJEMPLOS:
(negative-literal-p '(~ p))        ; T
(or (negative-literal-p NIL)       ; NIL
(negative-literal-p '~)            ; NIL
(negative-literal-p '=>)           ; NIL
(negative-literal-p '(p))          ; NIL
(negative-literal-p '((~ p)))      ; NIL
(negative-literal-p '(~ T))        ; NIL
(negative-literal-p '(~ NIL))      ; NIL
(negative-literal-p '(~ =>))       ; NIL
(negative-literal-p 'p)            ; NIL
(negative-literal-p '((~ p)))      ; NIL
(negative-literal-p '(~ (v p q)))) ; NIL


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EJERCICIO 4.1.3
;; Predicado para determinar si una expresion es un literal  
;;
;; RECIBE   : expresion x  
;; EVALUA A : T si la expresion es un literal, 
;;            NIL en caso contrario. 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun literal-p (x) 
	;; Tiene que ser un literal positivo o negativo
 	(or (positive-literal-p x) (negative-literal-p x))
  )

;; EJEMPLOS:
(and (literal-p 'p)             
(literal-p '(~ p)))    
;;; evaluan a T
(or (literal-p '(p))
(literal-p '(~ (v p q))))
;;; evaluan a  NIL


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Predicado para determinar si una expresion esta en formato prefijo 
;;
;; RECIBE   : expresion x 
;; EVALUA A : T si x esta en formato prefijo, NIL en caso contrario. 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun wff-prefix-p (x)
  (unless (null x)             ;; NIL no es FBF en formato prefijo (por convencion)
    (or (literal-p x)          ;; Un literal es FBF en formato prefijo
        (and (listp x)         ;; En caso de que no sea un literal debe ser una lista
             (let ((connector (first x))
                   (rest_1    (rest  x)))
               (cond
                ((unary-connector-p connector)  ;; Si el primer elemento es un connector unario
                 (and (null (rest rest_1))      ;; deberia tener la estructura (<conector> FBF)
                      (wff-prefix-p (first rest_1)))) 
                ((binary-connector-p connector) ;; Si el primer elemento es un conector binario
                 (let ((rest_2 (rest rest_1)))  ;; deberia tener la estructura 
                   (and (null (rest rest_2))    ;; (<conector> FBF1 FBF2)
                        (wff-prefix-p (first rest_1))
                        (wff-prefix-p (first rest_2)))))               
                ((n-ary-connector-p connector)  ;; Si el primer elemento es un conector enario
                 (or (null rest_1)              ;; conjuncion o disyuncion vacias
                     (and (wff-prefix-p (first rest_1)) ;; tienen que ser FBF los operandos 
                          (let ((rest_2 (rest rest_1)))
                            (or (null rest_2)           ;; conjuncion o disyuncion con un elemento
                                (wff-prefix-p (cons connector rest_2)))))))	
                (t NIL)))))))                   ;; No es FBF en formato prefijo 
;;
;; EJEMPLOS:
(wff-prefix-p '(v))
(wff-prefix-p '(^))
(wff-prefix-p '(v A))
(wff-prefix-p '(^ (~ B)))
(wff-prefix-p '(v A (~ B)))
(wff-prefix-p '(v (~ B) A ))
(wff-prefix-p '(^ (V P (=> A (^ B (~ C) D))) (^ (<=> P (~ Q)) P) E))
;;; evaluan a T
(wff-prefix-p 'NIL)
(wff-prefix-p '(~))
(wff-prefix-p '(=>))
(wff-prefix-p '(<=>))
(wff-prefix-p '(^ (V P (=> A ( B ^ (~ C) ^ D))) (^ (<=> P (~ Q)) P) E))
;;; evaluan a NIL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EJERCICIO 4.1.4
;; Predicado para determinar si una expresion esta en formato infijo 
;;
;; RECIBE   : expresion x 
;; EVALUA A : T si x esta en formato prefijo, 
;;            NIL en caso contrario. 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun wff-infix-p (x)
	
  (unless (truth-value-p x)	   ;; Por convenio los valores de verdad no 
  							   ;; son expresiones infijo
            
    (or (literal-p x)          ;; Un literal es FBF en formato infijo
        (and (listp x)         ;; En caso de que no sea un literal debe ser una lista
        	
        	(cond 
        										
        		((unary-connector-p (first x))	
        			;; Si el primer elemento es un conector unario (negacion)
        			;; tiene que estar sucedido por un unico elemento, 
        			;; es decir, (cddr x) tiene que ser nil y el segundo
        			;; elemento tiene que ser una expresion infijo o un literal
        			(unless (not (null (cddr x)))
         				(wff-infix-p (second x))))
         				
         			;; Si es un conector n-ario y aparece antes que ningun
         			;; otro literal, tiene que ser el unico elemento de la lista,
         			;; ya que si hubiera un literal en la expresion tendria que ir
         			;; antes del conector al ser expresion infijo.
        		((n-ary-connector-p (first x))
        			
        			(null (cdr x)))
        			
        			;; Si aparece un literal, debe de estar sucedido por un operador
        			;; binario o n-ario, que a su vez deben estar sucedidos por
        			;; una o mas expresiones infijo o literales segun corresponda
        		((literal-p (first x))
        			(or
        				(if (binary-connector-p (second x))
        					(and (null (cdddr x)) (wff-infix-p (third x))))
        				(if (n-ary-connector-p (second x))
        					(or (and (null (fourth x)) (wff-infix-p (third x)))
        						(and (eql (fourth x) (second x)) (wff-infix-p (cddr x)))))))
        		
        		;; Si el primer elemento es una lista debe ser una expresion infijo
        		;; y debe estar sucedida por un conector n-ario o binario como en
        		;; el caso anterior, que a su vez debe estar sucedido por un literal 
        		;; o expresion infijo
        		((listp (first x))
        			(or (and (n-ary-connector-p (caar x)) (null (cdar x)))
        				(and (not (null (cdar x))) (wff-infix-p (car x))
        						(or
        							(if (binary-connector-p (second x))
        								(and (null (cdddr x)) (wff-infix-p (third x))))
        							(if (n-ary-connector-p (second x))
        								(or (and (null (fourth x)) (wff-infix-p (third x)))
        									(and (eql (fourth x) (second x)) (wff-infix-p (cddr x))))))))))))))
        					


;;
;; EJEMPLOS:
;;
(and 
(wff-infix-p 'a) 						; T
(wff-infix-p '(^)) 					; T  ;; por convencion
(wff-infix-p '(v)) 					; T  ;; por convencion
(wff-infix-p '(A ^ (v))) 			      ; T  
(wff-infix-p '( a ^ b ^ (p v q) ^ (~ r) ^ s))  	; T 
(wff-infix-p '(A => B)) 				; T
(wff-infix-p '(A => (B <=> C))) 			; T
(wff-infix-p '( B => (A ^ C ^ D))) 			; T   
(wff-infix-p '( B => (A ^ C))) 			; T 
(wff-infix-p '( B ^ (A ^ C))) 			; T 
(wff-infix-p '((p v (a => (b ^ (~ c) ^ d))) ^ ((p <=> (~ q)) ^ p ) ^ e)))  ; T 
(or (wff-infix-p nil) 					; NIL
(wff-infix-p '(a ^)) 					; NIL
(wff-infix-p '(^ a)) 					; NIL
(wff-infix-p '(a)) 					; NIL
(wff-infix-p '((a))) 				      ; NIL
(wff-infix-p '((a) b))   			      ; NIL
(wff-infix-p '(^ a b q (~ r) s))  		      ; NIL 
(wff-infix-p '( B => A C)) 			      ; NIL   
(wff-infix-p '( => A)) 				      ; NIL   
(wff-infix-p '(A =>)) 				      ; NIL   
(wff-infix-p '(A => B <=> C)) 		      ; NIL
(wff-infix-p '( B => (A ^ C v D))) 		      ; NIL   
(wff-infix-p '( B ^ C v D )) 			      ; NIL 
(wff-infix-p '((p v (a => e (b ^ (~ c) ^ d))) ^ ((p <=> (~ q)) ^ p ) ^ e))); NIL 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Convierte FBF en formato prefijo a FBF en formato infijo
;;
;; RECIBE   : FBF en formato prefijo 
;; EVALUA A : FBF en formato infijo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun prefix-to-infix (wff)
  (when (wff-prefix-p wff)
    (if (literal-p wff)
        wff
      (let ((connector      (first wff))
            (elements-wff (rest wff)))
        (cond
         ((unary-connector-p connector) 
          (list connector (prefix-to-infix (second wff))))
         ((binary-connector-p connector) 
          (list (prefix-to-infix (second wff))
                connector
                (prefix-to-infix (third wff))))
         ((n-ary-connector-p connector) 
          (cond 
           ((null elements-wff)        ;;; conjuncion o disyuncion vacias. 
            wff)                       ;;; por convencion, se acepta como fbf en formato infijo
           ((null (cdr elements-wff))  ;;; conjuncion o disyuncion con un unico elemento
            (prefix-to-infix (car elements-wff)))  
           (t (cons (prefix-to-infix (first elements-wff)) 
                    (mapcan #'(lambda(x) (list connector (prefix-to-infix x))) 
                      (rest elements-wff))))))
         (t NIL)))))) ;; no deberia llegar a este paso nunca

;;
;;  EJEMPLOS:
;;
(prefix-to-infix '(v))          ; (V)
(prefix-to-infix '(^))          ; (^)
(prefix-to-infix '(v a))        ; A
(prefix-to-infix '(^ a))        ; A
(prefix-to-infix '(^ (~ a)))    ; (~ a)
(prefix-to-infix '(v a b))      ; (A v B)
(prefix-to-infix '(v a b c))    ; (A V B V C)
(prefix-to-infix '(^ (V P (=> A (^ B (~ C) D))) (^ (<=> P (~ Q)) P) E))
;;; ((P V (A => (B ^ (~ C) ^ D))) ^ ((P <=> (~ Q)) ^ P) ^ E)
(prefix-to-infix '(^ (v p (=> a (^ b (~ c) d))))) ; (P V (A => (B ^ (~ C) ^ D)))
(prefix-to-infix '(^ (^ (<=> p (~ q)) p ) e))     ; (((P <=> (~ Q)) ^ P) ^ E)  
(prefix-to-infix '( v (~ p) q (~ r) (~ s)))       ; ((~ P) V Q V (~ R) V (~ S))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EJERCICIO 4.1.5
;;
;; Convierte FBF en formato infijo a FBF en formato prefijo
;;  
;; RECIBE   : FBF en formato infijo 
;; EVALUA A : FBF en formato prefijo 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun infix-to-prefix (wff)
  (when (wff-infix-p wff)
    (if (or (literal-p wff) (n-ary-connector-p wff)) ; '(v), '(~ a), 'a
      wff
      (let ((op1 (first wff)) ;op1 puede ser un operando o un ~
            (op2 (second wff));op2 puede ser un connectr o un operando 
            (op3 (third wff)))
        (cond
          ((unary-connector-p op1) ; caso (~wff) -> (~(inf-pre wff))
           (list op1 (infix-to-prefix op2)))
          ((binary-connector-p op2) ; caso (wff1 <=> wff2)  -> (<=> (inf-pre wff1) (inf-pre wff2)) 
           (list op2 (infix-to-prefix op1) (infix-to-prefix op3)))
          ((n-ary-connector-p op2) ; caso (wff1 ^ ... ^ wff n) -> (^ (inf-pre wff1) ... (inf-pre wffn))
           (cons op2 (mapcan #'(lambda(x) (unless (connector-p x) (list (infix-to-prefix x))))  wff)) ))))))
;;
;; EJEMPLOS
;;
(infix-to-prefix nil)      ;; NIL
(infix-to-prefix 'a)       ;; a
(infix-to-prefix '((a)))   ;; NIL
(infix-to-prefix '(a))     ;; NIL
(infix-to-prefix '(((a)))) ;; NIL
(prefix-to-infix (infix-to-prefix '((p v (a => (b ^ (~ c) ^ d))) ^ ((p <=> (~ q)) ^ p) ^ e)) ) 
;;-> ((P V (A => (B ^ (~ C) ^ D))) ^ ((P <=> (~ Q)) ^ P) ^ E)


(infix-to-prefix '((p v (a => (b ^ (~ c) ^ d))) ^  ((p <=> (~ q)) ^ p) ^ e))  
;; (^ (V P (=> A (^ B (~ C) D))) (^ (<=> P (~ Q)) P) E)

(infix-to-prefix '(~ ((~ p) v q v (~ r) v (~ s))))
;; (~ (V (~ P) Q (~ R) (~ S)))


(infix-to-prefix
 (prefix-to-infix
  '(V (~ P) Q (~ R) (~ S))))
;;-> (V (~ P) Q (~ R) (~ S))

(infix-to-prefix
 (prefix-to-infix
  '(~ (V (~ P) Q (~ R) (~ S)))))
;;-> (~ (V (~ P) Q (~ R) (~ S)))


(infix-to-prefix 'a)  ; A
(infix-to-prefix '((p v (a => (b ^ (~ c) ^ d))) ^  ((p <=> (~ q)) ^ p) ^ e))  
;; (^ (V P (=> A (^ B (~ C) D))) (^ (<=> P (~ Q)) P) E)

(infix-to-prefix '(~ ((~ p) v q v (~ r) v (~ s))))
;; (~ (V (~ P) Q (~ R) (~ S)))

(infix-to-prefix  (prefix-to-infix '(^ (v p (=> a (^ b (~ c) d)))))) ; '(v p (=> a (^ b (~ c) d))))
(infix-to-prefix  (prefix-to-infix '(^ (^ (<=> p (~ q)) p ) e))) ; '(^ (^ (<=> p (~ q)) p ) e))  
(infix-to-prefix (prefix-to-infix '( v (~ p) q (~ r) (~ s))))  ; '( v (~ p) q (~ r) (~ s)))
;;;

(infix-to-prefix '(p v (a => (b ^ (~ c) ^ d)))) ; (V P (=> A (^ B (~ C) D)))
(infix-to-prefix '(((P <=> (~ Q)) ^ P) ^ E))  ; (^ (^ (<=> P (~ Q)) P) E)
(infix-to-prefix '((~ P) V Q V (~ R) V (~ S))); (V (~ P) Q (~ R) (~ S))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EJERCICIO 4.1.6
;; Predicado para determinar si una FBF es una clausula  
;;
;; RECIBE   : FBF en formato prefijo 
;; EVALUA A : T si FBF es una clausula, NIL en caso contrario. 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Funcion auxiliar que devuelve true si recibe como
;; argumento una lista de literales o nil
(defun list-of-literals-or-nil (lst)
	(or (null lst)
		(and (literal-p (first lst)) (list-of-literals-or-nil (rest lst)))))

(defun clause-p (wff)
     (and (listp wff)      				;; Recibe una lista               
           (if (eql (first wff) +or+)  	;; cuyo primer elemento es un or
           	;; que va sucedido de una lista de literales o de nada
           	;; por ejemplo (v a b) es una clausula, pero (v) tambien
           		(list-of-literals-or-nil (rest wff))))) 


;;
;; EJEMPLOS:
;;
(and (clause-p '(v))             ; T
(clause-p '(v p))           ; T
(clause-p '(v (~ r)))       ; T
(clause-p '(v p q (~ r) s))) ; T
(or (clause-p NIL)                    ; NIL
(clause-p 'p)                     ; NIL
(clause-p '(~ p))                 ; NIL
(clause-p NIL)                    ; NIL
(clause-p '(p))                   ; NIL
(clause-p '((~ p)))               ; NIL
(clause-p '(^ a b q (~ r) s))     ; NIL
(clause-p '(v (^ a b) q (~ r) s)) ; NIL
(clause-p '(~ (v p q))))           ; NIL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EJERCICIO 1.7
;; Predicado para determinar si una FBF esta en FNC  
;;
;; RECIBE   : FFB en formato prefijo 
;; EVALUA A : T si FBF esta en FNC con conectores, 
;;            NIL en caso contrario. 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Funcion auxiliar que devuelve true en caso de recibir
;; como argumento una lista de clausulas o nil
(defun list-of-clauses-or-nil-p (lst)
	(or (null lst)
		(and (clause-p (first lst)) 
			(list-of-clauses-or-nil-p (rest lst)))))

(defun cnf-p (wff)
  (and (listp wff)					;; Tiene que ser una lista
  		(eql (first wff) +and+)		;; cuyo primer elemento tiene que ser
  									;; un and
  			;; que tiene que estar sucedido de una lista de clausulas
  			;; o de nada (como ocurre en (^), que es una cnf)
  		(list-of-clauses-or-nil-p (rest wff))))
  

;;
;; EJEMPLOS:
;;
(and (cnf-p '(^ (v a  b c) (v q r) (v (~ r) s) (v a b))) ; T
(cnf-p '(^ (v a  b (~ c)) ))                        ; T
(cnf-p '(^ ))                                       ; T
(cnf-p '(^(v )))                                    ; T
(not (or (cnf-p '(~ p))                                      ; NIL
(cnf-p '(^ a b q (~ r) s))                          ; NIL
(cnf-p '(^ (v a b) q (v (~ r) s) a b))              ; NIL
(cnf-p '(v p q (~ r) s))                            ; NIL
(cnf-p '(^ (v a b) q (v (~ r) s) a b))              ; NIL
(cnf-p '(^ p))                                      ; NIL
(cnf-p '(v ))                                       ; NIL
(cnf-p NIL)                                         ; NIL
(cnf-p '((~ p)))                                    ; NIL
(cnf-p '(p))                                        ; NIL
(cnf-p '(^ (p)))                                    ; NIL
(cnf-p '((p)))                                      ; NIL
(cnf-p '(^ a b q (r) s))                            ; NIL
(cnf-p '(^ (v a  (v b c)) (v q r) (v (~ r) s) a b)) ; NIL
(cnf-p '(^ (v a (^ b c)) (^ q r) (v (~ r) s) a b))  ; NIL
(cnf-p '(~ (v p q)))                                ; NIL
(cnf-p '(v p q (r) s)))))                           ; NIL 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EJERCICIO 4.2.1: Incluya comentarios en el codigo adjunto
;;
;; Dada una FBF, evalua a una FBF equivalente 
;; que no contiene el connector <=>
;;
;; RECIBE   : FBF en formato prefijo 
;; EVALUA A : FBF equivalente en formato prefijo 
;;            sin connector <=>
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun eliminate-biconditional (wff)
  (if (or (null wff) (literal-p wff)) ;; Si recibe como argumento nill
      wff							  ;; o un literallo devuelve
      
    (let ((connector (first wff)))				;; Si no, mira si el conector
      (if (eq connector +bicond+)				;; es un bicondicional
          (let ((wff1 (eliminate-biconditional (second wff))) 
                (wff2 (eliminate-biconditional (third  wff))))
                ;; Si lo es, elimina el bicondicional en las dos
                ;; expresiones que rodean al propio bicondicional
                ;; y despues aplica la transformacion. 
            (list +and+ 
                  (list +cond+ wff1 wff2)
                  (list +cond+ wff2 wff1)))
                  ;; Si no es ninguno de los casos anteriores, 
                  ;; el primer elemento debe ser un operador de otro
                  ;; tipo y aplicamos la eliminacion del bicondicional 
                  ;; en todos sus operandos
        (cons connector 
              (mapcar #'eliminate-biconditional (rest wff)))))))

;;
;; EJEMPLOS:
;;
(eliminate-biconditional '(<=> p  (v q s p) ))
;;   (^ (=> P (v Q S P)) (=> (v Q S P) P))
(eliminate-biconditional '(<=>  (<=> p  q) (^ s (~ q))))
;;   (^ (=> (^ (=> P Q) (=> Q P)) (^ S (~ Q)))
;;      (=> (^ S (~ Q)) (^ (=> P Q) (=> Q P))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EJERCICIO 4.2.2
;; Dada una FBF, que contiene conectores => evalua a
;; una FBF equivalente que no contiene el connector =>
;;
;; RECIBE   : wff en formato prefijo sin el connector <=> 
;; EVALUA A : wff equivalente en formato prefijo 
;;            sin el connector =>
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun eliminate-conditional (wff)  
  (if (or (null wff) (literal-p wff))	;; Si el argumento es un literal
      wff								;; o nil devolvemos el argumento
    (let ((connector (first wff)))
    	;; En cualquier otro caso, estamos ante una expresion.
    	;; Comprobamos el conector.
      (if (eq connector +cond+)
          (let ((wff1 (eliminate-conditional (second wff)))
                (wff2 (eliminate-conditional (third  wff))))
                ;; Si es un condiconal, tras aplicar la 
                ;; eliminacion del condicional a los dos operandos,
                ;; procedemos a la transformacion:
                ;; (a => b) -> ((+not+ a) v b)
            (list +or+ 
                  (list +not+ wff1)
                  wff2))
                  
                 ;; Si no, es un operador de otro tipo
                 ;; Aplicamos la eliminacion del condicional
                 ;; a todos los operandos
        (cons connector 
              (mapcar #'eliminate-conditional (rest wff)))))))



;;
;; EJEMPLOS:
;;
(eliminate-conditional '(=> p q))         ;;; (V (~ P) Q)
(eliminate-conditional '(=> p (v q s p)))   ;;; (V (~ P) (V Q S P))
(eliminate-conditional '(=> (=> (~ p) q) (^ s (~ q)))) ;;; (V (~ (V (~ (~ P)) Q)) (^ S (~ Q)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EJERCICIO 4.2.3
;; Dada una FBF, que no contiene los conectores <=>, => 
;; evalua a una FNF equivalente en la que la negacion  
;; aparece unicamente en literales negativos
;;
;; RECIBE   : FBF en formato prefijo sin conector <=>, => 
;; EVALUA A : FBF equivalente en formato prefijo en la que 
;;            la negacion  aparece unicamente en literales 
;;            negativos.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  

;; Funcion auxiliar que aplica las leyes de De Morgan a una expresion
;; que se quiere negar. Por ejemplo:
;; '(+not+ (v a b)) = (morgan '(v a b)) = (^ (+not+ a) (+not b))
;; Ademas esta funcion intentara reducir el alcance de la negacion
;; en todas las subexpresiones que reciba

(defun morgan (wff)
	(if (listp wff) 					;; Si es una lista
		(cond ((eql (first wff) +not+)	;; y es una expresion negada
					;; Se intenta reducir el alcance de la negacion
					;; y se devuelve el resultado
				(reduce-scope-of-negation (second wff)))
				
												
			((n-ary-connector-p (first wff))	;; Si es un operador n-ario
				(cons (exchange-and-or (first wff)) ;; intercambiamos and y or
						(negar-lista (rest wff)))))	;; y negamos todos los 
													;; elementos de la lista
		
		(cons +not+ wff)))  ;; Si no es una expresión, debe ser un literal, 
							;; lo negamos y lo devolvemos


;;;;
;; Funcion auxiliar que niega todos los elementos de la lista
;;;;
(defun negar-lista (wff)
	(unless (null wff)
		(cons (negar (first wff)) (negar-lista (rest wff)))))
		
		
;;;;
;; Funcion auxiliar que niega el elemento que reciba.
;;;;	
(defun negar (elt)
			;; Si es un literal negativo lo convierte a positivo
	(cond ((negative-literal-p elt) (second elt)) 
			;; Si es un literal positivo lo convierte a negativo
			((positive-literal-p elt) (list +not+ elt))
			;; Si es una expresion intentara negarla aplicando las leyes
			;; de De Morgan haciendo un llamada a la funcion morgan
			((listp elt) (morgan elt))))
		
;;;;
;; Funcion auxiliar que recibe una lista de expresiones
;; e intenta reducir el rango de la negacion en todas ellas.
;; Su utilidad se ve mas clara al leer el codigo y comentarios
;; de la funcion principal reduce-scope-of-negation
;;;;
(defun redScopeNeg-n-ary (wff)
	(unless (null wff)
		(cons (reduce-scope-of-negation (first wff))
				(redScopeNeg-n-ary (rest wff)))))  
;;;;
;; Funcion principal  
;;;;
(defun reduce-scope-of-negation (wff)
	(if (literal-p wff)			;; Si recibe un literal
		wff						;; lo devuelve
		(let 	((firstEl (first wff))
				(restEl (rest wff))
				(secondEl (second wff)))
			(cond				;; Si no es un literal 
								;; es una expresion
						
				((eql firstEl +not+)	;; Si es una expresion negada
					(morgan secondEl))	;; aplicamos las leyes de De Morgan
					
					;; Por otro lado, si es un conector n-ario, intento
					;; reducir el rango de la negacion en todos sus
					;; operandos, haciendo uso de redScopeNeg-n-ary
				((n-ary-connector-p firstEl) 
					(if (null secondEl)	
						wff				
						(cons firstEl (redScopeNeg-n-ary restEl))))))))
				
		
;;;;
;; Funcion auxiliar que intercambia and por or y viceversa
;;;;
(defun exchange-and-or (connector)
  (cond
   ((eq connector +and+) +or+)    
   ((eq connector +or+) +and+)
   (t connector)))

;;
;;  EJEMPLOS:
;;
(reduce-scope-of-negation '(~ (v p (~ q) r))) 
;;; (^ (~ P) Q (~ R))
(reduce-scope-of-negation '(~ (^ p (~ q) (v  r s (~ a))))) 
;;;  (V (~ P) Q (^ (~ R) (~ S) A))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EJERCICIO 4.2.4: Comente el codigo adjunto 
;;
;; Dada una FBF, que no contiene los conectores <=>, => en la 
;; que la negacion aparece unicamente en literales negativos
;; evalua a una FBF equivalente en FNC con conectores ^, v  
;;
;; RECIBE   : FBF en formato prefijo sin conector <=>, =>, 
;;            en la que la negacion aparece unicamente 
;;            en literales negativos
;; EVALUA A : FBF equivalente en formato prefijo FNC 
;;            con conectores ^, v
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun combine-elt-lst (elt lst)
  (if (null lst)
      ; Si lst vacia, devuelve '((elt))
      (list (list elt))
    ; Si no: ((elt x1) (elt x2) ... (elt xn)) para los xi en lst   
    (mapcar #'(lambda (x) (cons elt x)) lst)))

; Dada una lista de listas de literales, devuelve una lista con todas las posibles listas que 
; tienen un elemento de cada lista. En las listas internas pone como conector el conector
;externo, y en la lista externa pone como conector el opuesto del conector el externo, 
(defun exchange-NF (nf)
  (if (or (null nf) (literal-p nf)) 
      nf ; Si nf esta vacia o es un literal, no tenemos que hacer nada
    (let ((connector (first nf)))
      ; Si no: cambia el conector externo por el su opuesto,
      (cons (exchange-and-or connector)
            (mapcar #'(lambda (x)
                          ; y todos los internos por el externo,
                          (cons connector x))
                ; en todas las posibles listas q contienen un elto de cada lista    
                (exchange-NF-aux (rest nf)))))))

; Dada una lista de listas, devuelve todas las listas posibles
; resultado de combiar un elemento de cada lista
(defun exchange-NF-aux (nf)
  (if (null nf) 
      NIL
    (let ((lst (first nf)))
      (mapcan #'(lambda (x)
                  ; Combina cada x de la primera lista con todas las listas
                  ; que salen de combinar entre si las demas listas
                  (combine-elt-lst 
                   x 
                   (exchange-NF-aux (rest nf)))) 
        ;; Si 1er elto literal, aplicamos al elto. Si es conector, aplicamos a lo demas.      
        (if (literal-p lst) (list lst) (rest lst))))))

;; Dada una lista de sublistas conectadas entre si por un conector X, 'deshace' todas 
;; sublistas conectadas con X, eliminando el conector y llevando todos los literales de la
;; sublista a la lista principal, i.e. (^ (v cosas) (^ cosas2)) --> (^ (v cosas) cosas2)
(defun simplify (connector lst-wffs )
  (if (literal-p lst-wffs)
      ; Si la lista es un literal, hacemos (literal)
      lst-wffs                    
    (mapcan #'(lambda (x) 
                (cond 
                 ; Si el elto de la sublista es literal, hacemos (literal) 
                 ((literal-p x) (list x))
                 ; Si la sublista esta conectada por el conector que simplificamos,
                 ; aplicamos la simplificacion a todos sus elementos menos al conector
                 ((equal connector (first x))
                  (mapcan 
                      #'(lambda (y) (simplify connector (list y))) 
                    (rest x))) 
                 ; Si el conector no era el buscado, dejamos a la sublista tal cual
                 (t (list x))))               
      ;mapcan concatena todas las listas anteriores      
      lst-wffs)))

(defun cnf (wff)
  (cond
   ((cnf-p wff) wff) ; Si ya es cnf, nada que hacer
   ((literal-p wff) ; Si ya es un literal, (^ (v lit))
    (list +and+ (list +or+ wff)))
   ((let ((connector (first wff))) 
      (cond
       ((equal +and+ connector)
        ; Si es (^ () ()) : aplicamos cnf a todas las sublistas, simplificamos los ^ 
        ; y aniadimos el ^ del principio
        (cons +and+ (simplify +and+ (mapcar #'cnf (rest wff)))))
       ((equal +or+ connector) 
        ; Si es (v () ()) : simplificamos los v, aniadimos el v del ppio y hacemos
        ; el intercambio de los ^ por v 
        (cnf (exchange-NF (cons +or+ (simplify +or+ (rest wff)))))))))))


(cnf 'a)

(cnf '(v (~ a) b c))
(print (cnf '(^ (v (~ a) b c) (~ e) (^ e f (~ g) h) (v m n) (^ r s q) (v u q) (^ x y))))
(print (cnf '(v (^ (~ a) b c) (~ e) (^ e f (~ g) h) (v m n) (^ r s q) (v u q) (^ x y))))
(print (cnf '(^ (v p  (~ q)) a (v k  r  (^ m  n)))))
(print (cnf '(v p  q  (^ r  m)  (^ n  a)  s )))
(exchange-NF '(v p  q  (^ r  m)  (^ n  a)  s ))
(cnf '(^ (v a b (^ y r s) (v k l)) c (~ d) (^ e f (v h i) (^ o p))))
(cnf '(^ (v a b (^ y r s)) c (~ d) (^ e f (v h i) (^ o p))))
(cnf '(^ (^ y r s (^ p q (v c d))) (v a b)))
(print (cnf '(^ (v (~ a) b c) (~ e) r s 
                (v e f (~ g) h) k (v m n) d)))
;;
(cnf '(^ (v p (~ q)) (v k r (^ m  n))))
(print  (cnf '(v (v p q) e f (^ r  m) n (^ a (~ b) c) (^ d s))))
(print (cnf '(^ (^ (~ y) (v r (^ s (~ x)) (^ (~ p) m (v c d))) (v (~ a) (~ b))) g)))
;;
;; EJEMPLOS:
;;
(cnf NIL)              ; NIL
(cnf 'a)               ; (^ (V A))
(cnf '(~ a))           ; (^ (V (~ A)))
(cnf '(V (~ P) (~ P))) ; (^ (V (~ P) (~ P)))
(cnf '(V A))           ; (^ (V A))
(cnf '(^ (v p (~ q)) (v k r (^ m  n))))
;;;   (^ (V P (~ Q)) (V K R M) (V K R N))
(print  (cnf '(v (v p q) e f (^ r  m) n (^ a (~ b) c) (^ d s))))
;;; (^ (V P Q E F R N A D)      (V P Q E F R N A S)
;;;    (V P Q E F R N (~ B) D)  (V P Q E F R N (~ B) S)
;;;    (V P Q E F R N C D)      (V P Q E F R N C S) 
;;;    (V P Q E F M N A D)      (V P Q E F M N A S) 
;;;    (V P Q E F M N (~ B) D)  (V P Q E F M N (~ B) S) 
;;;    (V P Q E F M N C D)      (V P Q E F M N C S))
;;;
(print 
 (cnf '(^ (^ (~ y) (v r (^ s (~ x)) 
                      (^ (~ p) m (v c d)))(v (~ a) (~ b))) g)))
;;;(^ (V (~ Y)) (V R S (~ P)) (V R S M) 
;;;   (V R S C D) (V R (~ X) (~ P)) 
;;;   (V R (~ X) M) (V R (~ X) C D)
;;;   (V (~ A) (~ B)) (V G))  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EJERCICIO 4.2.5:
;;
;; Dada una FBF en  FNC
;; evalua a lista de listas sin conectores
;; que representa una conjuncion de disyunciones de literales
;;
;; RECIBE   : FBF en FNC con conectores ^, v
;; EVALUA A : FBF en FNC (con conectores ^, v eliminaos)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun eliminate-connectors (cnf)
	(unless (null cnf)
	(let ((firstEl (first cnf)))
	(cond ((n-ary-connector-p firstEl)		;; Si el argumento de entrada
											;; es una expresion n-aria 
											;; eliminamos conectoresde todos
											;; sus operandos
				(eliminate-connectors (rest cnf)))
		((listp firstEl)					;; Si es una expresion elimino sus conectores
											;; (este caso es por la recursion)
				(cons (eliminate-connectors firstEl) 
						(eliminate-connectors (rest cnf))))
		(t (cons firstEl (eliminate-connectors (rest cnf))))))))
		
  

(eliminate-connectors 'nil)
(eliminate-connectors (cnf '(^ (v p  (~ q))  (v k  r  (^ m  n)))))
(eliminate-connectors
 (cnf '(^ (v (~ a) b c) (~ e) (^ e f (~ g) h) (v m n) (^ r s q) (v u q) (^ x y))))

(eliminate-connectors (cnf '(v p  q  (^ r  m)  (^ n  q)  s )))
(eliminate-connectors (print (cnf '(^ (v p  (~ q)) (~ a) (v k  r  (^ m  n))))))

(eliminate-connectors '(^))
(eliminate-connectors '(^ (v p (~ q)) (v) (v k r)))
(eliminate-connectors '(^ (v a b)))

;;   EJEMPLOS:
;;

(eliminate-connectors '(^ (v p (~ q)) (v k r)))
;; ((P (~ Q)) (K R))
(eliminate-connectors '(^ (v p (~ q)) (v q (~ a)) (v s e f) (v b)))
;; ((P (~ Q)) (Q (~ A)) (S E F) (B))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EJERCICIO 4.2.6
;; Dada una FBF en formato infijo
;; evalua a lista de listas sin conectores
;; que representa la FNC equivalente
;;
;; RECIBE   : FBF 
;; EVALUA A : FBF en FNC (con conectores ^, v eliminados)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun wff-infix-to-cnf (wff)
  ;Aplicamos las funciones en el orden definido en el enunciado
  (eliminate-connectors 
    (cnf
      (reduce-scope-of-negation
        (eliminate-conditional
          (eliminate-biconditional
            (infix-to-prefix wff)))))))
;  	(eliminate-connectors (cnf (infix-to-prefix wff)))
;  )

;;
;; EJEMPLOS:
;; 
(wff-infix-to-cnf 'a)
(wff-infix-to-cnf '(~ a))
(wff-infix-to-cnf  '( (~ p) v q v (~ r) v (~ s)))
(wff-infix-to-cnf  '((p v (a => (b ^ (~ c) ^ d))) ^ ((p <=> (~ q)) ^ p) ^ e))
;; ((P (~ A) B) (P (~ A) (~ C)) (P (~ A) D) ((~ P) (~ Q)) (Q P) (P) (E))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EJERCICIO 4.3.1
;; eliminacion de literales repetidos una clausula 
;; 
;; RECIBE   : K - clausula (lista de literales, disyuncion implicita)
;; EVALUA A : clausula equivalente sin literales repetidos 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;
;; Funcion auxiliar que comprueba si dos literales son iguales
;;;;
(defun equal-literals (elt1 elt2)
	(or (eql elt1 elt2)
		(and (negative-literal-p elt1) (negative-literal-p elt2)
			(eql (second elt1) (second elt2)))))


;;;;
;; Funcion auxiliar que recibe una lista y un elemento.
;; Busca el elemento en la lista y devuelve t si lo encuentra.
;;;;
(defun search-literal-p (lst elt)
	(unless (null lst)
		(or (equal-literals (first lst) elt) 
			(search-literal-p (rest lst) elt))))

	
(defun eliminate-repeated-literals (k)
	(unless (null k)
  		(if (search-literal-p (rest k) (first k))	;; Busco el primer
  												;; elemento en el resto.
  			(eliminate-repeated-literals (rest k))	;; Si esta continuo la
  												;; recursion sin añadirlo.
  										;; Si no esta repetido, lo añado 
  										;; a la lista que devolvere al final.
  			(cons (first k) (eliminate-repeated-literals (rest k))))))
  

;;
;; EJEMPLO:
;;
(eliminate-repeated-literals '(a b (~ c) (~ a) a c (~ c) c a))
;;;   (B (~ A) (~ C) C A)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EJERCICIO 4.3.2
;; eliminacion de clausulas repetidas en una FNC 
;; 
;; RECIBE   : cnf - FBF en FNC (lista de clausulas, conjuncion implicita)
;; EVALUA A : FNC equivalente sin clausulas repetidas 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;
;; Funcion que elimina un elemento una sola vez de la lista
;; Ejemplo: (elim-elem '(a b a) 'a) -> (B A)
;;

(defun elim-elem (lst elem)
	(unless (null lst)
		(if (equal-literals (first lst) elem)
			(rest lst)
			(cons (first lst) (elim-elem (rest lst) elem)))))

;;
;; Funcion que determina si dos clausulas son iguales,
;; es decir, si tienen los mismos literales repetidos el
;; mismo numero de veces
;;

(defun equal-clauses (cl1 cl2)
	(if (null cl1)		;; Si una es nula (o si hemos llegado
						;; al final de la recursion)
		(null cl2)		;; la otra tambien debe ser nula
						;; (o haber llegado a la vez al final)
		(let ((firstEl (first cl1)))
			(and (search-literal-p cl2 firstEl) ;; Busco el primer elemento
				(equal-clauses (rest cl1) 
				(elim-elem cl2 firstEl))))))	;; Sigo la recursion, pero 
									;; eliminando el elemento encontrado.
											

;;
;; Funcion que busca la clausula cl1 en la lista lst
;; comparandolas con la funcion equal-clauses.
;; Devuelve t si lo encuentra y false si no.
;; Se podría sustituir por una utilizacion de la funcion 
;; ya incluida enlisp llamada 'member'
;;

(defun search-clause-p (cl1 lst)
	(unless (null lst)
		(or (equal-clauses cl1 (first lst))
			(search-clause-p cl1 (rest lst)))))


;;
;; Version recursiva de la funcion principal 
;; que recibe las clausulas con los literales
;; repetidos eliminados
;;

(defun elim-repeated-clauses-rec (cnf)
	(unless (null cnf)
  		(if (search-clause-p (first cnf) (rest cnf))
  	 		(elim-repeated-clauses-rec (rest cnf))
  	 		(cons (first cnf)
  	 			  (elim-repeated-clauses-rec (rest cnf))))))

;;
;; Funcion principal que primero elimina los literales
;; repetidos y luego llama a la versión recursiva de sí misma
;;

(defun elim-repeated-literals-from-clauses (cnf)
	(unless (null cnf)
		(cons (eliminate-repeated-literals (first cnf))
			(elim-repeated-literals-from-clauses (rest cnf)))))
	
(defun eliminate-repeated-clauses (cnf)
	(elim-repeated-clauses-rec (elim-repeated-literals-from-clauses cnf)))
	
;;
;; EJEMPLO:
;;
(eliminate-repeated-clauses '(((~ a) c) (c (~ a)) ((~ a) (~ a) b c b) (a a b) (c (~ a) b  b) (a b)))
;;; ((C (~ A)) (C (~ A) B) (A B))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EJERCICIO 4.3.3
;; Predicado que determina si una clausula subsume otra
;;
;; RECIBE   : K1, K2 clausulas
;; EVALUA a : K1 si K1 subsume a K2
;;            NIL en caso contrario
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun subsume (K1 K2)
  (if (subsetp K1 K2 :test 'equal) 
    K1 
    NIL))
  
;;
;;  EJEMPLOS:
;;
(subsume '(a) '(a b (~ c)))

;; ((A))

(subsume NIL '(a b (~ c)))
;; (NIL)
(subsume '(a b (~ c)) '(a) )
;; NIL
(subsume '( b (~ c)) '(a b (~ c)) )
;; ( b (~ c))
(subsume '(a b (~ c)) '( b (~ c)))
;; NIL
(subsume '(a b (~ c)) '(d  b (~ c)))
;; nil
(subsume '(a b (~ c)) '((~ a) b (~ c) a))
;; (A B (~ C))
(subsume '((~ a) b (~ c) a) '(a b (~ c)) )
;; nil
(subsume '((~ a)) '((~ a) b (~ c)))
;; ((~ A))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EJERCICIO 4.3.4
;; eliminacion de clausulas subsumidas en una FNC 
;; 
;; RECIBE   : K (clausula), cnf (FBF en FNC)
;; EVALUA A : FBF en FNC equivalente a cnf sin clausulas subsumidas 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; If any elt in cnf subsumes x, return NIL. If no one subsumes x, return x
(defun noone-subsumes (x cnf)
  (cond
    ((subsume (first cnf) x)
     NIL) ; si 1st cnf 'contiene y no es igual' a x
    ((null (rest cnf))
     t); si ya no quedan eltos en cnf, y ninguno subsumia a x
    (t (noone-subsumes x (rest cnf))))) ; ver si demas eltos te subsumen

;; Igual que (cons elem list) pero si list = (), devuelve (elem)
(defun my-cons(elem lst)
  (if (null lst)
    (list elem)
    (cons elem lst)))

;; Introduce elem en cnf1 si elem no es subsumido por cnf1 o cnf2.
;; Repite el proceso con el elemento siguiente a  elem; el primero de cnf2
(defun rec-elim-subsum(cnf1 elem cnf2)
  (cond
    
    ((null cnf2) 
     ; Caso base: hay que parar la recursion: devolvemos cnf1 con o sin elem 
     (if (noone-subsumes elem cnf1)
         (my-cons elem cnf1)
         cnf1))
    ((and (noone-subsumes elem cnf1) (noone-subsumes elem cnf2))
     ; Si nadie subsume a elemn, aniadimos elem a cnf1 y repetimos con 1st-cnf2 y rest-cnf2
     (rec-elim-subsum (my-cons elem cnf1) (first cnf2) (rest cnf2)))
    (t
     ; Si alguien subsume a elem, no aniadimos elem a cnf1 y repetimos con 1st-cnf2 y rest-cnf2
     (rec-elim-subsum cnf1 (first cnf2) (rest cnf2)))))

(defun eliminate-subsumed-clauses(cnf)
  (if
    (equal cnf '() )
    cnf
    (rec-elim-subsum () (first cnf) (rest cnf))))
;;
;;  EJEMPLOS:
;;
(eliminate-subsumed-clauses 
 '((a b c) (b c) (a (~ c) b)  ((~ a) b) (a b (~ a)) (c b a)))
;;; ((A (~ C) B) ((~ A) B) (B C)) ;; el orden no es importante
(eliminate-subsumed-clauses
 '((a b c) (b c) (a (~ c) b) (b)  ((~ a) b) (a b (~ a)) (c b a)))
;;; ((B))
(eliminate-subsumed-clauses
 '((a b c) (b c) (a (~ c) b) ((~ a))  ((~ a) b) (a b (~ a)) (c b a)))
;;; ((A (~ C) B) ((~ A)) (B C))


(eliminate-subsumed-clauses '((a)))
;;; ((A))
(eliminate-subsumed-clauses '())
;;; NIL
(eliminate-subsumed-clauses '(()))
;; (NIL)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EJERCICIO 4.3.5
;; Predicado que determina si una clausula es tautologia
;;
;; RECIBE   : K (clausula)
;; EVALUA a : T si K es tautologia
;;            NIL en caso contrario
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tautology-p (K) 
  (cond 
    ((null K) NIL) ;Caso base: no quedan eltos en clausula para comprobar
    ((member (list +not+ (first K)) K :test 'equal) T) ;Si (x (~x)) in K, es tautologia
    (t (tautology-p (rest K)))))



;;
;;  EJEMPLOS:
;;
(tautology-p '((~ B) A C (~ A) D)) ;;; T 
(tautology-p '((~ B) A C D))       ;;; NIL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EJERCICIO 4.3.6
;; eliminacion de clausulas en una FBF en FNC que son tautologia
;;
;; RECIBE   : cnf - FBF en FNC
;; EVALUA A : FBF en FNC equivalente a cnf sin tautologias 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun eliminate-tautologies (cnf)
  ; Concateno listas con todas las clausulas que no son tautology
  (mapcan #'(lambda (x) (unless (tautology-p x) (list x))) cnf))

;;
;;  EJEMPLOS:
;;
(eliminate-tautologies 
 '(((~ b) a) (a (~ a) b c) ( a (~ b)) (s d (~ s) (~ s)) (a)))
;; (((~ B) A) (A (~ B)) (A))

(eliminate-tautologies '((a (~ a) b c)))
;; NIL

(eliminate-tautologies 
 '(((~ b) a) (a (~ a) b c) ( a (~ b)) (s d (~ s) (~ s)) (a) (c) (c d (~d)) () ))
;; (((~ B) A) (A (~ B)) (A) (C) (C D (~D)) NIL)
;; TODO como deberia comportarse ante ()?? 
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EJERCICIO 4.3.7
;; simplifica FBF en FNC 
;;        * elimina literales repetidos en cada una de las clausulas 
;;        * elimina clausulas repetidas
;;        * elimina tautologias
;;        * elimina clausulass subsumidas
;;  
;; RECIBE   : cnf  FBF en FNC
;; EVALUA A : FNC equivalente sin clausulas repetidas, 
;;            sin literales repetidos en las clausulas
;;            y sin clausulas subsumidas
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun simplify-cnf (cnf) 
  (eliminate-subsumed-clauses 
    (eliminate-tautologies 
      (eliminate-repeated-clauses
        (mapcar #'(lambda(x) (eliminate-repeated-literals x) ) cnf)))))

;;
;;  EJEMPLOS:
;;
(simplify-cnf '((a a) (b) (a) ((~ b)) ((~ b)) (a b c a)  (s s d) (b b c a b)))
;; ((B) ((~ B)) (S D) (A)) ;; en cualquier orden



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EJERCICIO 4.4.1
;; Construye el conjunto de clausulas lambda-neutras para una FNC 
;;
;; RECIBE   : cnf    - FBF en FBF simplificada
;;            lambda - literal positivo
;; EVALUA A : cnf_lambda^(0) subconjunto de clausulas de cnf  
;;            que no contienen el literal lambda ni ~lambda   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; Devuelve T if (lambda not in K) AND (~lambda not in K)
(defun not-contains-lambda(lambda K)
	(not (or (member lambda K :test 'equal)
              (member (list +not+ lambda) K :test 'equal))))
              
;; Devuelve el subconjunto de conj que no contienen ni lambda ni ~lambda
(defun aux-extract-neutral (subconj conj lambda)
  (cond
    ((null conj)
     ; Si conj vacio, he terminado. Devuelvo subconj con el filtro
     subconj)
    ((not-contains-lambda lambda (first conj))
     ; Si primera clausula de conj es neutra para lambda, aniado la clausula a subconj y repito
     (aux-extract-neutral (adjoin (first conj) subconj :test 'equal) (rest conj) lambda))
    (t
      ; Si no, no la aniado a subconj y repito
      (aux-extract-neutral subconj (rest conj) lambda))))

(defun extract-neutral-clauses (lambda cnf)
  (aux-extract-neutral () cnf lambda))




;(defun equal-neutral-literal (lit1 lit2)
;	(or (equal-literals lit1 lit2)
;		(equal-literals (list +not+ lit1) lit2)))

;(defun extract-neutral-clauses (lambda cnf)   
;  	(if (member lambda (first cnf) :test 'equal-neutral-literal)
;  		(extract-neutral-clauses lambda (rest cnf))
;  		(cons (first cnf) 
;  			  (extract-neutral-clauses lambda (rest cnf))))) 
  

;;
;;  EJEMPLOS:
;;
(extract-neutral-clauses 'p
                           '((p (~ q) r) (p q) (r (~ s) q) (a b p) (a (~ p) c) ((~ r) s)))
;; (((~ R) S) (R (~ S) Q))
(extract-neutral-clauses 'r NIL)
;; NIL
(extract-neutral-clauses 'r '(NIL))
;; (NIL)
(extract-neutral-clauses 'r
                           '((p (~ q) r) (p q) (r (~ s) q) (a b p) (a (~ p) c) ((~ r) s)))
;; ((A (~ P) C) (A B P) (P Q))
(extract-neutral-clauses 'p
                           '((p (~ q) r) (p q) (r (~ s) p q) (a b p) (a (~ p) c) ((~ r) p s)))
;; NIL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EJERCICIO 4.4.2
;; Construye el conjunto de clausulas lambda-positivas para una FNC
;;
;; RECIBE   : cnf    - FBF en FNC simplificada
;;            lambda - literal positivo
;; EVALUA A : cnf_lambda^(+) subconjunto de clausulas de cnf 
;;            que contienen el literal lambda  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Extrae las clausulas de conj que pasan la funcion 'equal
(defun extract-clauses (subconj conj elto)
  (cond
    ((null conj)
     ; Si no quedan clausulas q mirar en conj, ya he terminado: subconj contiene el filtro
     subconj)
    ((member elto (first conj) :test 'equal)
     ; si 'elto pertenece a la primera clausula de conj, aniado clausula a subconj y repito
     (extract-clauses (adjoin (first conj) subconj :test 'equal) (rest conj) elto))
    (t
      ; si no, no aniado a subconj y repito
      (extract-clauses subconj (rest conj) elto))))


  
(defun extract-positive-clauses (lambda cnf) 
  (extract-clauses () cnf lambda))
; Llamo a extract-clauses para que filtre clausulas de cnf que contengan 'lambda


;;
;;  EJEMPLOS:
;;
(extract-positive-clauses 'p
                             '((p (~ q) r) (p q) (r (~ s) q) (a b p) (a (~ p) c) ((~ r) s)))

;; ((A B P) (P Q) (P (~ Q) R))
(extract-positive-clauses 'r NIL)
;; NIL
(extract-positive-clauses 'r '(NIL))
;; NIL
(extract-positive-clauses 'r
                             '((p (~ q) r) (p q) (r (~ s) q) (a b p) (a (~ p) c) ((~ r) s)))
;; ((R (~ S) Q) (P (~ Q) R))
(extract-positive-clauses 'p
                             '(((~ p) (~ q) r) ((~ p) q) (r (~ s) (~ p) q) (a b (~ p)) ((~ r) (~ p) s)))
;; NIL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EJERCICIO 4.4.3
;; Construye el conjunto de clausulas lambda-negativas para una FNC 
;;
;; RECIBE   : cnf    - FBF en FNC simplificada
;;            lambda - literal positivo 
;; EVALUA A : cnf_lambda^(-) subconjunto de clausulas de cnf  
;;            que contienen el literal ~lambda  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun extract-negative-clauses (lambda cnf) 
  (extract-clauses () cnf (list +not+ lambda))) 
; Llamo a extract-clauses para que filtre clausulas de cnf que contengan '(~ lambda)

;;
;;  EJEMPLOS:
;;
(extract-negative-clauses 'p
                             '((p (~ q) r) (p q) (r (~ s) q) (a b p) (a (~ p) c) ((~ r) s)))
;; ((A (~ P) C))

(extract-negative-clauses 'r NIL)
;; NIL
(extract-negative-clauses 'r '(NIL))
;; NIL
(extract-negative-clauses 'r
                             '((p (~ q) r) (p q) (r (~ s) q) (a b p) (a (~ p) c) ((~ r) s)))
;; (((~ R) S))
(extract-negative-clauses 'p
                             '(( p (~ q) r) ( p q) (r (~ s) p q) (a b p) ((~ r) p s)))
;; NIL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EJERCICIO 4.4.4
;; resolvente de dos clausulas
;;
;; RECIBE   : lambda      - literal positivo
;;            K1, K2      - clausulas simplificadas
;; EVALUA A : res_lambda(K1,K2) 
;;                        - lista que contiene la 
;;                          clausula que resulta de aplicar resolucion 
;;                          sobre K1 y K2, con los literales repetidos 
;;                          eliminados
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;This test evals TRUE if you can resolve on K1 and K2
(defun resolvable (lambda K1 K2)
  (let ((notlambda (list +not+ lambda)))
    (or (and (member lambda K1 :test 'equal)
             (member notlambda K2 :test 'equal))
        (and (member notlambda K1 :test 'equal)
             (member lambda K2 :test 'equal)))))


(defun resolve-on (lambda K1 K2) 
  (unless (not (resolvable lambda K1 K2))
    ; A la union de conjuntos K1 y K2, restamos el conjunto (lambda ~lambda)
    (list
      (set-difference (union K1 K2 :test 'equal)          ; {K1} U {K2} \
                      (list lambda (list +not+ lambda))   ; {(lambda ~lambda)} 
                      :test 'equal))))
;;
;;  EJEMPLOS:
;;
(resolve-on 'p '(a b (~ c) p) '((~ p) b a q r s))
;; (((~ C) B A Q R S))

(resolve-on 'p '(a b (~ c) (~ p)) '( p b a q r s))
;; (((~ C) B A Q R S))

(resolve-on 'p '(p) '((~ p)))
;; (NIL)


(resolve-on 'p NIL '(p b a q r s))
;; NIL

(resolve-on 'p NIL NIL)
;; NIL

(resolve-on 'p '(a b (~ c) (~ p)) '(p b a q r s))
;; (((~ C) B A Q R S))

(resolve-on 'p '(a b (~ c)) '(p b a q r s))
;; NIL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EJERCICIO 4.4.5
;; Construye el conjunto de clausulas RES para una FNC 
;;
;; RECIBE   : lambda - literal positivo
;;            cnf    - FBF en FNC simplificada
;;            
;; EVALUA A : RES_lambda(cnf) con las clauses repetidas eliminadas
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Devuelve una lista con el resultado de aplicar res  sobre K1 y todas las Ki de cnf
(defun resolve(lambda K1 cnf)
  (unless (null cnf)
    (union (resolve-on lambda K1 (first cnf))
           (resolve lambda K1 (rest cnf))
           :test 'equal)))

;; EXAMPLES
(resolve 'a '(a b) '(((~ a) b) (a c) ((~ a) d) ))
;; ((B) (B D))
(resolve 'a '(a b) ())
;; NIL
(resolve 'a () ())
;; NIL

;; Devuelve una lista con el resultad de aplicar res sobre todos los posibles
;; pares de clausulas (K1, K2) con K1 en cnf1 y K2 en cnf2
(defun resolve-pairs (lambda cnf1 cnf2)
  (unless (null cnf1)
    (union (resolve lambda (first cnf1) cnf2)
           (resolve-pairs lambda (rest cnf1) cnf2)
           :test 'equal)))

;; EXAMPLES
(resolve-pairs 'a '((a b) (a e) (a (~ d))) '(((~ a) b) ((~ a) c) ((~ a) d) ))
;; ((B) (B C) (B D) (E B) (E C) (E D) ((~ D) B) ((~ D) C) ((~ D) D))
(resolve-pairs 'a '() '(((~ a) b) ((~ a) c) ((~ a) d) ))
;; NIL
(resolve-pairs 'a '() '())
;; NIL
(resolve-pairs 'a '((a b) (a e) (a (~ d))) '(((~ a) b) ((~ a) c) ((~ a) d) ((~ a) d)))
;; ((B) (B C) (B D) (E B) (E C) (E D) ((~ D) B) ((~ D) C) ((~ D) D)) <- No hay repeiciones

(defun build-RES (lambda cnf)
  (union (extract-neutral-clauses lambda cnf)
         (resolve-pairs lambda 
                        (extract-negative-clauses lambda cnf)
                        (extract-positive-clauses lambda cnf))
         :test 'equal-clauses))

;;
;;  EJEMPLOS:
;;
(build-RES 'p NIL)
;; NIL
(build-RES 'P '((A  (~ P) B) (A P) (A B)))
;; ((B B))
(build-RES 'P '((B  (~ P) A) (A P) (A B)))
;; ((B A))
(build-RES 'p '(NIL))
;; (NIL)
(build-RES 'p '((p) ((~ p))))
;; (NIL)
(build-RES 'q '((p q) ((~ p) q) (a b q) (p (~ q)) ((~ p) (~ q))))
;; (((~ P) A B) ((~ P)) ((~ P) P) (P A B) (P (~ P)) (P))
(build-RES 'p '((p q) (c q) (a b q) (p (~ q)) (p (~ q))))
;; ((A B Q) (C Q))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EJERCICIO 4.5
;; Comprueba si una FNC es SAT calculando RES para todos los
;; atomos en la FNC 
;;
;; RECIBE   : cnf - FBF en FNC simplificada
;; EVALUA A :	T  si cnf es SAT
;;                NIL  si cnf es UNSAT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Acumula en posit todos los literales positivos de la clausula K
(defun rec-positive-in-clause (clause)
  (cond
    ((null clause)
     ;; No quedan literales en clause que mirar. Hemos terminado
     NIL)
    ((positive-literal-p (first clause))
     ;; El 1er lit de clause es positivo: la union del 1er lit y los positivos en rest-clause
     (union (list (first clause))
            (rec-positive-in-clause (rest clause))
            :test 'equal))
    (t
      ;; El 1er lit de clause es negativo los positivos de rest-clause
      (rec-positive-in-clause (rest clause)))))

;; EXAMPLES
(rec-positive-in-clause '(a b (~ c) d (~ e)))
;; (A B D)
(rec-positive-in-clause '((~ a) (~ b)))
;; NIL

;; Devuelve un conjunto todos los literales positivos de cnf
(defun rec-positive-in-cnf (cnf)
  (unless 
    (null cnf)
    (union (rec-positive-in-clause (first cnf))
           (rec-positive-in-cnf (rest cnf))
           :test 'equal)))

;; EXAMPLES
(rec-positive-in-cnf '(   (b (~ a) c)  (e (~ d) f)  (h (~ g) i)   )   )
;; (B C E F H I)
(rec-positive-in-cnf '(NIL)   )
;; NIL
(rec-positive-in-cnf '(   (b (~ a) c)  (e (~ d) f)  (b (~ g) c)   )   )
;; (E F B C)
(rec-positive-in-cnf '(   ((~ a) (~ b))  ((~ c) (~ d))  ((~ f) (~ g))   )   )
;;NIL

;; Devuelve T si cnf es UNSAT.
(defun unsat (cnf)
  (if 
    (member NIL cnf :test 'equal)
    t
    NIL))

(defun rec-RES-SAT (lambdas cnf)
  (cond
    ;; Si cnf vacia -> T
    ((null cnf) T)
    ;; Si cnf UNSAT -> NIL
    ((unsat cnf) NIL)
    ;; Si no hay mas literales sobre los que resolver -> True
    ((null lambdas) T)
    ;; Else: aplicamos res sobre cnf con el primer lambda, repetimos para los demas lambdas
    (t (rec-RES-SAT (rest lambdas)
                    (simplify-cnf  (build-RES (first lambdas)
                                          cnf))))))
(defun  RES-SAT-p (cnf) 
  (rec-RES-SAT (rec-positive-in-cnf cnf) 
               cnf))

;;
;;  EJEMPLOS:
;;
;;
;; SAT Examples
;;
(RES-SAT-p nil)  ;;; T
(RES-SAT-p '((p) ((~ q)))) ;;; T 
(RES-SAT-p
 '((a b d) ((~ p) q) ((~ c) a b) ((~ b) (~ p) d) (c d (~ a)))) ;;; T 
(RES-SAT-p
 '(((~ p) (~ q) (~ r)) (q r) ((~ q) p) ((~ q)) ((~ p) (~ q) r))) ;;;T
;;
;; UNSAT Examples
;;
(RES-SAT-p '(nil))         ;;; NIL
(RES-SAT-p '((S) nil))     ;;; NIL 
(RES-SAT-p '((p) ((~ p)))) ;;; NIL
(RES-SAT-p
 '(((~ p) (~ q) (~ r)) (q r) ((~ q) p) (p) (q) ((~ r)) ((~ p) (~ q) r))) ;;; NIL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EJERCICIO 4.6:
;; Resolucion basada en RES-SAT-p
;;
;; RECIBE   : wff - FBF en formato infijo 
;;            w   - FBF en formato infijo 
;;                               
;; EVALUA A : T   si w es consecuencia logica de wff
;;            NIL en caso de que no sea consecuencia logica.  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun logical-consequence-RES-SAT-p (wff w)
  (not ;; Si la union es UNSAT, devolvemos True
    (RES-SAT-p ;; resolvemos sobre la union de wff y not w
      (union (simplify-cnf 
               (wff-infix-to-cnf wff))
             (simplify-cnf 
               (wff-infix-to-cnf 
                 (list +not+ w)))
             :test 'equal-clauses))))

;;
;;  EJEMPLOS:
;;
(logical-consequence-RES-SAT-p NIL 'a) ;;; NIL
(logical-consequence-RES-SAT-p NIL NIL) ;;; NIL
(logical-consequence-RES-SAT-p '(q ^ (~ q)) 'a) ;;; T 
(logical-consequence-RES-SAT-p '(q ^ (~ q)) '(~ a)) ;;; T 

(logical-consequence-RES-SAT-p '((p => (~ p)) ^ p) 'q)
;; T

(logical-consequence-RES-SAT-p '((p => (~ p)) ^ p) '(~ q))
;; T

(logical-consequence-RES-SAT-p '((p => q) ^ p) 'q)
;; T

(logical-consequence-RES-SAT-p '((p => q) ^ p) '(~q))
;; NIL

(logical-consequence-RES-SAT-p 
 '(((~ p) => q) ^ (p => (a v (~ b))) ^ (p => ((~ a) ^ b)) ^ ( (~ p) => (r  ^ (~ q)))) 
 '(~ a))
;; T

(logical-consequence-RES-SAT-p 
 '(((~ p) => q) ^ (p => (a v (~ b))) ^ (p => ((~ a) ^ b)) ^ ( (~ p) => (r  ^ (~ q)))) 
 'a)
;; T

(logical-consequence-RES-SAT-p 
 '(((~ p) => q) ^ (p => ((~ a) ^ b)) ^ ( (~ p) => (r  ^ (~ q)))) 
 'a)
;; NIL

(logical-consequence-RES-SAT-p 
 '(((~ p) => q) ^ (p => ((~ a) ^ b)) ^ ( (~ p) => (r  ^ (~ q)))) 
 '(~ a))
;; T

(logical-consequence-RES-SAT-p 
 '(((~ p) => q) ^ (p <=> ((~ a) ^ b)) ^ ( (~ p) => (r  ^ (~ q)))) 
 'q)
;; NIL

(logical-consequence-RES-SAT-p 
 '(((~ p) => q) ^ (p <=> ((~ a) ^ b)) ^ ( (~ p) => (r  ^ (~ q)))) 
 '(~ q))
;; NIL

(or 
 (logical-consequence-RES-SAT-p '((p => q) ^ p) '(~q))      ;; NIL
 (logical-consequence-RES-SAT-p 
  '(((~ p) => q) ^ (p => ((~ a) ^ b)) ^ ( (~ p) => (r  ^ (~ q)))) 
  'a) ;; NIL
 (logical-consequence-RES-SAT-p 
  '(((~ p) => q) ^ (p <=> ((~ a) ^ b)) ^ ( (~ p) => (r  ^ (~ q)))) 
  'q) ;; NIL
 (logical-consequence-RES-SAT-p 
  '(((~ p) => q) ^ (p <=> ((~ a) ^ b)) ^ ( (~ p) => (r  ^ (~ q)))) 
  '(~ q)))

