;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;    Lab assignment 2: Search
;;    LAB GROUP: 
;;    Couple:  
;;    Author 1: 
;;    Author 2:
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;    Problem definition
;;
(defstruct problem
  states               ; List of states
  initial-state        ; Initial state
  f-h                  ; reference to a function that evaluates to the 
                       ; value of the heuristic of a state
  f-goal-test          ; reference to a function that determines whether 
                       ; a state fulfils the goal 
  f-search-state-equal ; reference to a predictate that determines whether
                       ; two nodes are equal, in terms of their search state      
  operators)           ; list of operators (references to functions) to 
                       ; generate successors;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;    Node in search tree
;;
(defstruct node 
  state           ; state label
  parent          ; parent node
  action          ; action that generated the current node from its parent
  (depth 0)       ; depth in the search tree
  (g 0)           ; cost of the path from the initial state to this node
  (h 0)           ; value of the heurstic
  (f 0))          ; g + h 
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;    Actions 
;;
(defstruct action
  name              ; Name of the operator that generated the action
  origin            ; State on which the action is applied
  final             ; State that results from the application of the action
  cost )            ; Cost of the action
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;    Search strategies 
;;
(defstruct strategy
  name              ; name of the search strategy
  node-compare-p)   ; boolean comparison
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;    END: Define structures
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;    BEGIN: Define galaxy
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defparameter *planets* '(Avalon Davion Katril Kentares Mallory Proserpina Sirtis))

(defparameter *white-holes* 
    '((Avalon Mallory 6.4) (Avalon Proserpina 8.6) 
      (Kentares  Avalon 3) (Kentares Proserpina 7) (Kentares Katril 10)
      (Proserpina Avalon 8.6) (Proserpina Mallory 15) (Proserpina Davion 5)
      (Proserpina Sirtis 12)
      (Sirtis Proserpina 12) (Sirtis Davion 6)
      (Davion Sirtis 6) (Davion Proserpina 5)
      (Katril Davion 9) (Katril Mallory 10)
      (Mallory Katril 10) (Mallory Proserpina 15)))

(defparameter *worm-holes*  
  '((Avalon Kentares 4) (Avalon Mallory 9)

    (Davion Katril 5) (Davion Sirtis 8) 
    (Katril Sirtis 10) (Katril Mallory 5)
    (Proserpina Sirtis 9) (Proserpina Mallory 11) (Proserpina Kentares 12)))

(defparameter *sensors*
    '((Sirtis 0) (Katril 9) (Proserpina 7) (Davion 5) (Kentares 14)
      (Mallory 12) (Avalon 15)))

(defparameter *planet-origin* 'Mallory)
(defparameter *planets-destination* '(Sirtis))
(defparameter *planets-forbidden*   '(Avalon))
(defparameter *planets-mandatory*   '(Katril Proserpina))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;; BEGIN: Exercise 1 -- Evaluation of the heuristic
;;
;; Returns the value of the heuristics for a given state
;;
;;  Input:
;;    state: the current state (vis. the planet we are on)
;;    sensors: a sensor list, that is a list of pairs
;;                (state cost)
;;             where the first element is the name of a state and the second
;;             a number estimating the cost to reach the goal
;;
;;  Returns:
;;    The cost (a number) or NIL if the state is not in the sensor list
;;
(defun f-h-galaxy (state sensors)
    (unless 
        (null sensors)
        (if (equal (first (first sensors)) state)
            ;; Si el primer elt de la sublista es el state, devuelvo
            ;; el segundo elt de la sublista
            (second (first sensors))
            ;; Si no, sigo buscando en el resto de los sensores
            (f-h-galaxy state (rest sensors)))))

(f-h-galaxy 'Sirtis *sensors*) ;-> 0
(f-h-galaxy 'Avalon *sensors*) ;-> 15
(f-h-galaxy 'Earth  *sensors*) ;-> NIL
(f-h-galaxy 'Proserpina *sensors*) ;-> 7


;;
;; END: Exercise 1 -- Evaluation of the heuristic
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; BEGIN: Exercise 2 -- Navigation operators
;;

;;;;
;; Funcion auxiliar que a partir de un estado y una lista de agujeros genera acciones
;; resutantes de moverse del estado actual al segundo elemento de cada agujero
;; asumiendo que es el destinoy que se puede navegar a el. El argumento type
;; indicara el nombre que se le da a la accion (white hole o black hole)
;;;;
(defun navigate-holes (type state holes)
  (mapcar #'(lambda
              (x)
              (make-action ;; Construye la accion
                :name type ;; cuyo nombre es el tipo de accion 
                           ;; (agujero blanco o de gusano)
                :origin (first x) ;; Su origen es el principio del agujero
                :final (second x) ;; Su destino es el final del agujero
                :cost (third x))) ;; Si coste es el coste del agujero
          holes))
    
;;;;
;; Devuelve una lista de acciones que se pueden realizar desde el estado actual hacia
;; los agujeros blancos de la lista
;;;;
(defun navigate-white-hole (state white-holes)
    (navigate-holes 'navigate-white-hole state ;; Agujero blanco
        (remove state              ;; Creamos una lista con los agujeros blancos
                white-holes     ;; que se pueden recorrer desde el nodo en el que estamos
                :test #'(lambda(x y) 
                (not (eql x (first y)))))))


;;;;
;; Devuelve una lista con las acciones que se pueden realizar al atravesar agujeros
;; negros desde el estado actual. Descarta los panetas prohibidos.
;;;;    
(defun navigate-worm-hole (state worm-holes planets-forbidden)
  (navigate-holes 'navigate-worm-hole state ;; Agujero de gusano
    (mapcan 
      #'(lambda(y)             ;; Creamos una lista con los agujeros 
                               ;; de gusano que se pueden recorrer desde
                               ;; el estado actual
          (cond             
            ((eql (first y) state) ;; Si el primer elemento es el estado 
                                   ;; actual, conservamos el orden
             (if 
               (null (member (second y) ;; Si no pertenece a planets-forbidden
                             planets-forbidden))
               (list y)))
            ((eql (second y) state)    ;; Si es el segundo, invertimos el orden
                                    ;; antes de mandarlo a la funcion navigate-holes
                                    ;; (esto es meramente para simplificar 
                                    ;; navigate-holes)
             (if (null (member (first y) ;; Si no pertenece a planets-forbidden
                               planets-forbidden))
               (list (list state 
                           (first y) 
                           (third y)))))))
      worm-holes)))


(navigate-worm-hole 'Mallory *worm-holes* *planets-forbidden*)  ;-> 
;;;(#S(ACTION :NAME NAVIGATE-WORM-HOLE :ORIGIN MALLORY :FINAL KATRIL :COST 5)
;;; #S(ACTION :NAME NAVIGATE-WORM-HOLE :ORIGIN MALLORY :FINAL PROSERPINA :COST 11))

(navigate-worm-hole 'Mallory *worm-holes* NIL)  ;-> 
;;;(#S(ACTION :NAME NAVIGATE-WORM-HOLE :ORIGIN MALLORY :FINAL AVALON :COST 9)
;;; #S(ACTION :NAME NAVIGATE-WORM-HOLE :ORIGIN MALLORY :FINAL KATRIL :COST 5)
;;; #S(ACTION :NAME NAVIGATE-WORM-HOLE :ORIGIN MALLORY :FINAL PROSERPINA :COST 11))


(navigate-white-hole 'Kentares *white-holes*) ;->
;;;(#S(ACTION :NAME NAVIGATE-WHITE-HOLE :ORIGIN KENTARES :FINAL AVALON :COST 3)
;;; #S(ACTION :NAME NAVIGATE-WHITE-HOLE :ORIGIN KENTARES :FINAL KATRIL :COST 10)
;;; #S(ACTION :NAME NAVIGATE-WHITE-HOLE :ORIGIN KENTARES :FINAL PROSERPINA :COST 7))


(navigate-worm-hole 'Uranus *worm-holes* *planets-forbidden*)  ;-> NIL


;;
;; END: Exercise 2 -- Navigation operators
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; BEGIN: Exercise 3 -- Goal test
;;

;; FUNCION AUXILIAR

(defun all-mandatory-visited (node planets-mandatory)
    (cond
      ((null planets-mandatory) T) ;; Si todos los obligatorios visitados: T
      ((null node) NIL) ;; Si no, si no quedan nodos padre donde buscar: NIL
      ((member (node-state node) planets-mandatory :test #'equal)
       (all-mandatory-visited
         (node-parent node)
         (remove (node-state node) planets-mandatory :test #'equal)))
       ;; Si el nodo esta en la lista, lo retiramos y repetimos con padre y con la nueva lista
       (T (all-mandatory-visited (node-parent node) planets-mandatory)))))
       ;; En otro caso, repetimos con el padre y con la misma lista

;; Con node-01, 02 , 03 y 04 de abajo:
;; (setq mandatory '(Avalon Katril))    
;; (all-mandatory-visited node-03 mandatory ) T
;; (all-mandatory-visited node-02 mandatory ) NIL
;; (all-mandatory-visited node-04 mandatory ) T


(defun f-goal-test-galaxy (node planets-destination planets-mandatory) 
  (and 
    (member (node-state node) planets-destination :test #'equal)
    (all-mandatory-visited node planets-mandatory)))


(defparameter node-01
   (make-node :state 'Avalon) )
(defparameter node-02
   (make-node :state 'Kentares :parent node-01))
(defparameter node-03
   (make-node :state 'Katril :parent node-02))
(defparameter node-04
   (make-node :state 'Kentares :parent node-03))
(f-goal-test-galaxy node-01 '(kentares urano) '(Avalon Katril)); -> NIL
(f-goal-test-galaxy node-02 '(kentares urano) '(Avalon Katril)); -> NIL
(f-goal-test-galaxy node-03 '(kentares urano) '(Avalon Katril)); -> NIL
(f-goal-test-galaxy node-04 '(kentares urano) '(Avalon Katril)); -> T



;;;;;;;; EXERCISE 3 B ;;;;;

;; FUNCION AUXILIAR

;; Devuelve, dado un nodo y una lista de node-states obligatorios, los
;; node-states que quedan por visitar

(defun mandatory-to-visit (node mandatory)
  (cond
    ((null node) mandatory) ;; Si ya no quedan antecesores, mandatory contiene
                            ;; los que faltan por visitar
    ((member (node-state node) mandatory :test #'equal) ;; Si nodo esta en mandatory,
     (mandatory-to-visit                                ;; lo retiramos de la lista 
       (node-parent node)                               ;; y llamamos al padre con 
       (remove (node-state node) mandatory)))           ;; con la nueva lista
    (T (mandatory-to-visit (node-parent node) mandatory)))) 
    ;; Si no, repetimos con el padre y con la misma lista
    
    
;;;;;;; EJEMPLOS ;;;;;;;;;

;; (mandatory-to-visit node-02 '(Avalon)) NIL
;; (mandatory-to-visit node-02 '(Avalon Katril)) (KATRIL)
;; (mandatory-to-visit node-03 '(Avalon Katril)) NIL
;; (mandatory-to-visit node-04 '(Avalon Katril Tetera)) (TETERA)
;; (mandatory-to-visit node-04 '(Taza Avalon Katril Tetera)) (TAZA TETERA)

;; FUNCION AUXILIAR

;; Devuelve true si los planetas obligatorios que quedan por visitar a node-1
;; son los mismos que quedan por visitar a node-2
;; null-XOR nos permite comprobar si 2 conjuntos son iguales

(defun same-mandatory-to-visit (node-1 node-2 planets-mandatory)
  (null
    (set-exclusive-or (mandatory-to-visit node-1 planets-mandatory)
                      (mandatory-to-visit node-2 planets-mandatory))))

;;;;;;; EJEMPLOS ;;;;;;;;;

 (same-mandatory-to-visit node-02 node-02 '(Avalon Katril))  ;; T
 (same-mandatory-to-visit node-02 node-02 '(Avalon)) ;; T
 (same-mandatory-to-visit node-02 node-04 '(Avalon Katril)) ;; NIL
 (same-mandatory-to-visit node-03 node-04 '(Avalon Katril)) ;; T
 (same-mandatory-to-visit node-03 node-04 '()) ;; T

;; FUNCION PRINCIPAL 

;; Mismo estado si mismo planeta y mismos planetas por visitar
(defun f-search-state-equal-galaxy (node-1 node-2 &optional planets-mandatory)
  (and 
    (equal (node-state node-1) (node-state node-2))
    (same-mandatory-to-visit node-1 node-2 planets-mandatory)))

(f-search-state-equal-galaxy node-01 node-01) ;-> T
(f-search-state-equal-galaxy node-01 node-02) ;-> NIL
(f-search-state-equal-galaxy node-02 node-04) ;-> T
(f-search-state-equal-galaxy node-01 node-01 '(Avalon)) ;-> T
(f-search-state-equal-galaxy node-01 node-02 '(Avalon)) ;-> NIL
(f-search-state-equal-galaxy node-02 node-04 '(Avalon)) ;-> T
(f-search-state-equal-galaxy node-01 node-01 '(Avalon Katril)) ;-> T
(f-search-state-equal-galaxy node-01 node-02 '(Avalon Katril)) ;-> NIL
(f-search-state-equal-galaxy node-02 node-04 '(Avalon Katril)) ;-> NIL

;;
;; END: Exercise 3 -- Goal test
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  BEGIN: Exercise 4 -- Define the galaxy structure
;;
;;
(defparameter *galaxy-M35* 
  (make-problem 
   :states               *planets*          
   :initial-state        *planet-origin*
   :f-h                  #'(lambda (state) (f-h-galaxy state *sensors*))
   :f-goal-test          #'(lambda (node)  (f-goal-test-galaxy 
                                             node
                                             *planets-destination*
                                             *planets-mandatory*))
   :f-search-state-equal #'(lambda (node-1 node-2) (f-search-state-equal-galaxy 
                                                     node-1
                                                     node-2
                                                     *planets-mandatory*))
   :operators            (list 
                          #'(lambda (node) (navigate-white-hole
                                             (node-state node)
                                             *white-holes*))
                          #'(lambda (node) (navigate-worm-hole 
                                             (node-state node)
                                             *worm-holes*
                                             *planets-forbidden*)))))
;;
;;  END: Exercise 4 -- Define the galaxy structure
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; BEGIN Exercise 5: Expand node
;;
;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Funcion auxiliar que expande un nodo recibido como primer argumento
;; con el operador recibido como segundo, en el problema recibido 
;; como tercero
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun expand-operator (node operator problem)
    (mapcar #'(lambda (actn) 
            ;; Creamos un nodo con los datos correspondientes
            (make-node 
                :state (action-final actn) :parent node
                :action actn :depth (+ (node-depth node) 1) 
                :g (+ (node-g node) (action-cost actn))
                :h (funcall (problem-f-h problem)
                            (action-final actn))
                :f (+ (+ (node-g node) (action-cost actn)) 
                    (funcall (problem-f-h problem)
                            (action-final actn)))))
        (funcall operator node)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Funcion principal
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun expand-node (node problem)
  (mapcan ;; Llama a expand operator para todos los operadores
    #'(lambda (operator) (expand-operator node operator problem)) 
    (problem-operators problem)))


(defparameter node-00
   (make-node :state 'Proserpina :depth 12 :g 10 :f 20) )

(defparameter lst-nodes-00
  (expand-node node-00 *galaxy-M35*)) 


(print lst-nodes-00)

;;;(#S(NODE :STATE AVALON
;;;         :PARENT #S(NODE :STATE PROSERPINA :PARENT NIL :ACTION NIL :DEPTH 12 :G 10 :H 0 :F 20)
;;;         :ACTION #S(ACTION :NAME NAVIGATE-WHITE-HOLE :ORIGIN PROSERPINA :FINAL AVALON :COST 8.6)
;;;         :DEPTH 13   :G 18.6  :H 15  :F 33.6)
;;; #S(NODE :STATE DAVION
;;;         :PARENT #S(NODE :STATE PROSERPINA :PARENT NIL :ACTION NIL :DEPTH 12 :G 10 :H 0 :F 20)
;;;         :ACTION #S(ACTION :NAME NAVIGATE-WHITE-HOLE :ORIGIN PROSERPINA :FINAL DAVION :COST 5)
;;;         :DEPTH 13   :G 15    :H 5   :F 20)
;;; #S(NODE :STATE MALLORY
;;;         :PARENT #S(NODE :STATE PROSERPINA :PARENT NIL :ACTION NIL :DEPTH 12 :G 10 :H 0 :F 20)
;;;         :ACTION #S(ACTION :NAME NAVIGATE-WHITE-HOLE :ORIGIN PROSERPINA :FINAL MALLORY :COST 15)
;;;         :DEPTH 13   :G 25    :H 12  :F 37)
;;; #S(NODE :STATE SIRTIS
;;;         :PARENT #S(NODE :STATE PROSERPINA :PARENT NIL :ACTION NIL :DEPTH 12 :G 10 :H 0 :F 20)
;;;         :ACTION #S(ACTION :NAME NAVIGATE-WHITE-HOLE :ORIGIN PROSERPINA :FINAL SIRTIS :COST 12)
;;;         :DEPTH 13   :G 22    :H 0   :F 22)
;;; #S(NODE :STATE KENTARES
;;;         :PARENT #S(NODE :STATE PROSERPINA :PARENT NIL :ACTION NIL :DEPTH 12 :G 10 :H 0 :F 20)
;;;         :ACTION #S(ACTION :NAME NAVIGATE-WORM-HOLE :ORIGIN PROSERPINA :FINAL KENTARES :COST 12)
;;;         :DEPTH 13   :G 22    :H 14  :F 36)
;;; #S(NODE :STATE MALLORY
;;;         :PARENT #S(NODE :STATE PROSERPINA :PARENT NIL :ACTION NIL :DEPTH 12 :G 10 :H 0 :F 20)
;;;         :ACTION #S(ACTION :NAME NAVIGATE-WORM-HOLE :ORIGIN PROSERPINA :FINAL MALLORY :COST 11)
;;;         :DEPTH 13   :G 21    :H 12  :F 33)
;;; #S(NODE :STATE SIRTIS
;;;         :PARENT #S(NODE :STATE PROSERPINA :PARENT NIL :ACTION NIL :DEPTH 12 :G 10 :H 0 :F 20)
;;;         :ACTION #S(ACTION :NAME NAVIGATE-WORM-HOLE :ORIGIN PROSERPINA :FINAL SIRTIS :COST 9)
;;;         :DEPTH 13   :G 19    :H 0   :F 19))



;;
;; END Exercise 5: Expand node
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;  BEGIN Exercise 6 -- Node list management
;;;  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Funcion auxiliar que inserta en la lista de nodos recibida como 
;; segundo argumento el nodo recibido omo primero segun la estrategia
;; de ordenacion recibida como tercero.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun insert-node-strategy (node lst-nodes strategy)
    (cond ((null lst-nodes) ;; Si hemos llegado al final de la recursion
        (list node))        ;; (no hay mas nodos) devolvemos una lista
                            ;; que contenga el nodo
                            
        ((funcall (strategy-node-compare-p strategy) ;; Llamamos a la 
                    node                        ;; estrategia de comparacion
                    (first lst-nodes))            ;; entre el nodo y el primer
                                                ;; nodo de la lista
            (cons node lst-nodes))                ;; Si este es su ligar lo metemos
        (t (cons (first lst-nodes)                 ;; Si no, continuamos la recursion
                (insert-node-strategy node (rest lst-nodes) strategy)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Funcion principal
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun insert-nodes-strategy (nodes lst-nodes strategy)
    (if (null nodes) ;; Si no quedan mas nodos
        lst-nodes     ;; devolvemos la lista de nodos
        (insert-node-strategy (first nodes) ;; Si quedan mas lo insertamos
                                            ;; en la lista resultante de
                                            ;; continuar la recursion con el
                                            ;; resto de nodos
            (insert-nodes-strategy (rest nodes) lst-nodes strategy)
            strategy)))


(defun node-g-<= (node-1 node-2)
    (<= (node-g node-1)
        (node-g node-2)))
        
(defparameter *uniform-cost*
    (make-strategy
        :name 'uniform-cost
        :node-compare-p #'node-g-<=))
    


(defparameter node-01
   (make-node :state 'Avalon :depth 0 :g 0 :f 0) )
(defparameter node-02
   (make-node :state 'Kentares :depth 2 :g 50 :f 50) )



(print 
 (insert-nodes-strategy (list node-00 node-01 node-02) 
                        (sort (copy-list lst-nodes-00) #'<= :key #'node-g) 
                        *uniform-cost*));->
;;;(#S(NODE :STATE AVALON 
;;;         :PARENT NIL 
;;;         :ACTION NIL 
;;;         :DEPTH 0    :G 0     :H 0   :F 0)
;;; #S(NODE :STATE PROSERPINA 
;;;         :PARENT NIL 
;;;         :ACTION NIL 
;;;         :DEPTH 12   :G 10    :H 0   :F 20)
;;; #S(NODE :STATE DAVION
;;;         :PARENT #S(NODE :STATE PROSERPINA :PARENT NIL :ACTION NIL :DEPTH 12 :G 10 :H 0 :F 20)
;;;         :ACTION #S(ACTION :NAME NAVIGATE-WHITE-HOLE :ORIGIN PROSERPINA :FINAL DAVION :COST 5)
;;;         :DEPTH 13   :G 15    :H 5   :F 20)
;;; #S(NODE :STATE AVALON
;;;         :PARENT #S(NODE :STATE PROSERPINA :PARENT NIL :ACTION NIL :DEPTH 12 :G 10 :H 0 :F 20)
;;;         :ACTION #S(ACTION :NAME NAVIGATE-WHITE-HOLE :ORIGIN PROSERPINA :FINAL AVALON :COST 8.6)
;;;         :DEPTH 13   :G 18.6  :H 15  :F 33.6)
;;; #S(NODE :STATE SIRTIS
;;;         :PARENT #S(NODE :STATE PROSERPINA :PARENT NIL :ACTION NIL :DEPTH 12 :G 10 :H 0 :F 20)
;;;         :ACTION #S(ACTION :NAME NAVIGATE-WORM-HOLE :ORIGIN PROSERPINA :FINAL SIRTIS :COST 9)
;;;         :DEPTH 13   :G 19    :H 0   :F 19)
;;; #S(NODE :STATE MALLORY
;;;         :PARENT #S(NODE :STATE PROSERPINA :PARENT NIL :ACTION NIL :DEPTH 12 :G 10 :H 0 :F 20)
;;;         :ACTION #S(ACTION :NAME NAVIGATE-WORM-HOLE :ORIGIN PROSERPINA :FINAL MALLORY :COST 11)
;;;         :DEPTH 13   :G 21    :H 12  :F 33)
;;; #S(NODE :STATE KENTARES
;;;         :PARENT #S(NODE :STATE PROSERPINA :PARENT NIL :ACTION NIL :DEPTH 12 :G 10 :H 0 :F 20)
;;;         :ACTION #S(ACTION :NAME NAVIGATE-WORM-HOLE :ORIGIN PROSERPINA :FINAL KENTARES :COST 12)
;;;         :DEPTH 13   :G 22    :H 14  :F 36)
;;; #S(NODE :STATE SIRTIS
;;;         :PARENT #S(NODE :STATE PROSERPINA :PARENT NIL :ACTION NIL :DEPTH 12 :G 10 :H 0 :F 20)
;;;         :ACTION #S(ACTION :NAME NAVIGATE-WHITE-HOLE :ORIGIN PROSERPINA :FINAL SIRTIS :COST 12)
;;;         :DEPTH 13   :G 22    :H 0   :F 22)
;;; #S(NODE :STATE MALLORY
;;;         :PARENT #S(NODE :STATE PROSERPINA :PARENT NIL :ACTION NIL :DEPTH 12 :G 10 :H 0 :F 20)
;;;         :ACTION #S(ACTION :NAME NAVIGATE-WHITE-HOLE :ORIGIN PROSERPINA :FINAL MALLORY :COST 15)
;;;         :DEPTH 13   :G 25    :H 12  :F 37)
;;; #S(NODE :STATE KENTARES 
;;;         :PARENT NIL 
;;;         :ACTION NIL 
;;;         :DEPTH 2    :G 50    :H 0   :F 50))


;;;(insert-nodes-strategy '(4 8 6 2) '(1 3 5 7)
;;;        (make-strategy     :name 'simple
;;;                    :node-compare-p #'<));-> (1 2 3 4 5 6 7)
 


;;
;;    END: Exercize 6 -- Node list management
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; BEGIN: Exercise 7 -- Definition of the A* strategy
;;
;; A strategy is, basically, a comparison function between nodes to tell 
;; us which nodes should be analyzed first. In the A* strategy, the first 
;; node to be analyzed is the one with the smallest value of g+h
;;
;; A* explora nodos en funcion de su coste f = g+h
(defun node-f-<= (node-1 node-2)
  (<= (node-f node-1)
      (node-f node-2)))
      
(defparameter *A-star*
  (make-strategy
    :name 'A-star
    :node-compare-p #'node-f-<=))

;;
;; END: Exercise 7 -- Definition of the A* strategy
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 
;;;    BEGIN Exercise 8: Search algorithm
;;;

(defun graph-search-rec (problem strategy open closed)
  (let* 
    ((frst (first open))
     (test (problem-f-goal-test problem))
     (found (find
              frst
              closed 
              :test #'(lambda (x y) 
                              (funcall
                                (problem-f-search-state-equal problem)
                                x
                                y)))))
    (cond
      ; No quedan nodos donde probar: terminamos
      ((null open) NIL)
      ; Hemos alcanzado objetivo: terminamos
      ((funcall test frst) frst)
      ; Si el nodo no esta en cerrados o si que
      ; esta pero 'mejora' el valor g del cerrado:
      ; exploracion + llamada recursiva
      ((or
         (null found)
         (< (node-g found) (node-g frst)))
       ;Llamada recursiva
       (graph-search-rec
         ;El problema y la estrategia no cambian
         problem
         strategy
         ;A los abiertos hay que retirar el nodo explorado
         ;y aniadir todos los que resultan de explorarlo
         (insert-nodes-strategy 
           (expand-node frst problem)
           (rest open)
           strategy)
         ;Y a los cerrados hay que aniaadir el explorado
         (cons frst closed)))
      ; En otro caso: llamada recursiva sin explorar
      (T
        (graph-search-rec
          problem
          strategy
          (rest open)
          closed)))))

(defun graph-search (problem strategy)
  (graph-search-rec
    problem
    strategy
    (list 
      (make-node :state (problem-initial-state problem)))
    NIL))


;
;  Solve a problem using the A* strategy
;
(defun a-star-search (problem)
  (graph-search 
    problem
    *A-star*))


(graph-search *galaxy-M35* *A-star*);->
;;#S(NODE :STATE SIRTIS
;;   :PARENT
;;   #S(NODE :STATE PROSERPINA
;;      :PARENT
;;      #S(NODE :STATE DAVION
;;         :PARENT
;;         #S(NODE :STATE KATRIL
;;            :PARENT
;;            #S(NODE :STATE MALLORY :PARENT NIL :ACTION NIL :DEPTH 0 :G 0 :H 0
;;               :F 0)
;;            :ACTION
;;            #S(ACTION :NAME NAVIGATE-WORM-HOLE :ORIGIN MALLORY :FINAL KATRIL
;;               :COST 5)
;;            :DEPTH 1 :G 5 :H 9 :F 14)
;;         :ACTION
;;         #S(ACTION :NAME NAVIGATE-WORM-HOLE :ORIGIN KATRIL :FINAL DAVION
;;            :COST 5)
;;         :DEPTH 2 :G 10 :H 5 :F 15)
;;      :ACTION
;;      #S(ACTION :NAME NAVIGATE-WHITE-HOLE :ORIGIN DAVION :FINAL PROSERPINA
;;         :COST 5)
;;      :DEPTH 3 :G 15 :H 7 :F 22)
;;   :ACTION
;;   #S(ACTION :NAME NAVIGATE-WORM-HOLE :ORIGIN PROSERPINA :FINAL SIRTIS :COST 9)
;;   :DEPTH 4 :G 24 :H 0 :F 24)



(a-star-search *galaxy-M35*);->
;;#S(NODE :STATE SIRTIS
;;   :PARENT
;;   #S(NODE :STATE PROSERPINA
;;      :PARENT
;;      #S(NODE :STATE DAVION
;;         :PARENT
;;         #S(NODE :STATE KATRIL
;;            :PARENT
;;            #S(NODE :STATE MALLORY :PARENT NIL :ACTION NIL :DEPTH 0 :G 0 :H 0
;;               :F 0)
;;            :ACTION
;;            #S(ACTION :NAME NAVIGATE-WORM-HOLE :ORIGIN MALLORY :FINAL KATRIL
;;               :COST 5)
;;            :DEPTH 1 :G 5 :H 9 :F 14)
;;         :ACTION
;;         #S(ACTION :NAME NAVIGATE-WORM-HOLE :ORIGIN KATRIL :FINAL DAVION
;;            :COST 5)
;;         :DEPTH 2 :G 10 :H 5 :F 15)
;;      :ACTION
;;      #S(ACTION :NAME NAVIGATE-WHITE-HOLE :ORIGIN DAVION :FINAL PROSERPINA
;;         :COST 5)
;;      :DEPTH 3 :G 15 :H 7 :F 22)
;;   :ACTION
;;   #S(ACTION :NAME NAVIGATE-WORM-HOLE :ORIGIN PROSERPINA :FINAL SIRTIS :COST 9)
;;   :DEPTH 4 :G 24 :H 0 :F 24) 

;;; 
;;;    END Exercise 8: Search algorithm
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 
;;;    BEGIN Exercise 9: Solution path / action sequence
;;;
(defun solution-path (node)
    (unless (null node) ;; A menos que el nodo sea nil
        (if (null (node-parent node)) ;; Si es huerfano
            (list (node-state node)) ;; devolvemos una lista que 
                                     ;; contenga su nombre unicamente
            ;; Si no, devolvemos una lista que contenga primero el
            ;; resultado de continuar la recursion y luego el
            ;; nombre del nodo
            (append (solution-path (node-parent node))
                      (list (node-state node))))))

 

(defun action-sequence (node)
    (unless (null node) ;; Si el nodo es nil devolvemos nil
        (if (null (node-parent node)) ;; Si es huerfano
        (list (node-action node))     ;; devolvemos una lista que
                                      ;; contenga la accion del nodo
        ;; Si no es huerfano, devolvemos una lista que contenga primero
        ;; el resultado de continuar la recursion y luego la accion
        ;; asociada al nodo actual
        (append (action-sequence (node-parent node))
              (list (node-action node))))))




;;; 
;;;    END Exercise 9: Solution path / action sequence
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 
;;;    BEGIN Exercise 10: depth-first / breadth-first
;;;

(defun depth-first-node-compare-p (node-1 node-2)
  (>= (node-depth node-1) (node-depth node-2)))

(defparameter *depth-first*
  (make-strategy
   :name 'depth-first
   :node-compare-p #'depth-first-node-compare-p))



(solution-path (graph-search *galaxy-M35* *depth-first*))

(defun breadth-first-node-compare-p (node-1 node-2)
  (<= (node-depth node-1) (node-depth node-2)))

(defparameter *breadth-first*
  (make-strategy
   :name 'breadth-first
   :node-compare-p #'breadth-first-node-compare-p))



(solution-path (graph-search *galaxy-M35* *breadth-first*))

;;; 
;;;    END Exercise 10: depth-first / breadth-first
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
