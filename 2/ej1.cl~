;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;    Problem definition
;;
(defstruct problem
    states              ; List of states
    initial-state       ; Initial state
    f-goal-test         ; reference to a function that determines whether 
                        ; a state fulfills the goal 
    f-h                 ; reference to a function that evaluates to the 
                        ; value of the heuristic of a state
    operators)          ; list of operators (references to functions) 
                        ;to generate actions, which, in their turn, are 
                        ; used to generate succesors
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;    Node in the search algorithm
;;
(defstruct node 
    state      ; state label
    parent     ; parent node
    action     ; action that generated the current node from its parent
    (depth 0)  ; depth in the search tree
    (g 0)      ; cost of the path from the initial state to this node
    (h 0)      ; value of the heuristic
    (f 0))     ; g + h
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;    Actions 
;;
(defstruct action
    name    ; Name of the operator that generated the action
    origin  ; State on which the action is applied
    final   ; State that results from the application of the action
    cost )  ; Cost of the action
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;    Search strategies 
;;
(defstruct strategy
    name            ; Name of the search strategy
    node-compare-p) ; boolean comparison
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun f-h-galaxy (state sensors)

