/*  EJERCICIO 1*/

/*
* Cierto elemento X pertenece a una lista cuyo primer elto es X
* si ese primer elto NO es una lista
*/
pertenece_m(X, [X|_]) :- X\=[_|_].
/*
* Cierto elto X pertenece a una lista cuyo primer elto es una lista L
* si X pertenece a L
*/
pertenece_m(X, [[Y|Zs]|_]) :- pertenece_m(X, [Y|Zs]).
/* 
* Cierto elto X pertenece a una lista si pertenece a la lista formada
* por todos los elementos menos el primero
*/
pertenece_m(X, [_|Rs]) :- pertenece_m(X, Rs).

/*
 ?- pertenece_m(X, [2,[1,3],[1,[4,5]]]).
 X = 2 ;
 X = 1 ;
 X = 3 ;
 X = 1 ;
 X = 4 ;
 X = 5 ;
 false.
*/

/*  EJERCICIO 2*/
concatena([], L, L).
concatena([X|L1], L2, [X|L3]) :-
    concatena(L1, L2, L3).

/*
* Si L es la lista vacia, entonces L es el inverso de la lista vacia
*/

invierte([], L) :- 
    L=[].
/*
* Dada cierta lista A: si L es la concatenacion del inverso del resto 
* de A con el primer elemento de A, entonces L es el inverso de A
*/
invierte([X|Y], L) :- 
    invierte(Y, Inv),
    concatena(Inv , [X], L).

/*
?- invierte([1, 2], L).
L = [2, 1].

?- invierte([], L).
L = [].

?- invierte([1, 2], L).
L = [2, 1].
*/ 

/* Ejercicio 3 */
/* Si no hay lista en la que insertar,  la lista contendra
*  unicamente el propio elemento a insertar
*/
insert(X, [], X).
/* Si el elemento a insertar es menor
* que el primer elemento de la lista, hemos encontrado su lugar
* y devolvemos true si el ultimo elemento de la lista es el
* resultado de concatenar el elemento y el resto de la lista */
insert([C-A], [D-B|R1], X) :- 
    A=<B, concatena([C-A], 
    [D-B|R1], X).
/* Si el elemento a insertar es mayor que el primer
* elemento de la lista seguimos buscando y devolvemos true
* si el ultimo argumento es el resultado de concatenar
* el primer elemento de la lista con el resultado de
* continuar la recursion con el resto de la lista, es decir,
* con el resto de la lista con el elemento insertado */
insert([C-A], [D-B|R1], [D-B|X]) :- 
    A>B ,
    insert([C-A], R1, X).

/*  EJERCICIO 4.1 */

/*
* El numero de veces que aparece cualquier elemento en la lista vacia
* es 0
*/

elem_count(_, [], 0).
/*
* Un elto X aparece n veces en una lista L cuyo primer elto es X si 
* aparece 1 vez mas que en el resto de L
*/
elem_count(X, [X|Rs], Xn) :-
    elem_count(X, Rs, Num), 
    Xn is Num + 1.
/*
* Un elto X aparece n veces en una lista L cuyo primer elto no es X (si lo
* fuera, se hubiera usado la regla anterior) si aparece n veces en el
* resto de L
*/
elem_count(X, [Y|Rs], Xn) :- 
    X\=Y, 
    elem_count(X, Rs, Xn).

/*
?- elem_count(b,[b,a,b,a,b],Xn).
Xn = 3 ;
false.
?- elem_count(a,[b,a,b,a,b],Xn).
Xn = 2 ;
false.
*/

/*  EJERCICIO 4.2*/
list_count([], [_|_], []).
list_count([X|Y], L, [X-N|Z]):-
    elem_count(X, L, N),
    list_count(Y, L, Z).
/*
?- list_count([b],[b,a,b,a,b],Xn).
Xn = [b-3] ;
false.

?- list_count([b,a],[b,a,b,a,b],Xn).
Xn = [b-3, a-2] ;
false.

?- list_count([b,a,c],[b,a,b,a,b],Xn).
Xn = [b-3, a-2, c-0] ;
false.
*/

/* Ejercicio 5 */
/* La version ordenada de una lista vacia es la propia lista */
sort_list([], []).
/* Si la lista solo tiene un elemento ya esta ordenada */
sort_list([C-A], [C-A]).
/* La version ordenada de una lista con dos elementos o mas
* es la resultante de insertar (mediante la funcion insert del
* ejercicio 3) el primer elemento de la misma
* en el lugar correspondiente del resto ordenado de la lista. 
* (continuando con la recursion)
*/
sort_list([C-A|[D-B|R1]], X) :- 
          sort_list([D-B|R1], L), 
          insert([C-A], L, X).

/* Ejercicio 6 */
/* El arbol asociado a una lista con dos o mas elementos
*  sera el que tenga como
* campo 'info' un 1, como hijo izquierdo el resultado
* de generar un arbol solo con el elemento actual
* y como hijo derecho el resultado de continuar
* la recursion con el resto de elementos de la lista */
build_tree([A-B|R1], tree(1, Y, X)) :- 
    build_tree(R1, X), 
    build_tree([A-B], Y).
/* El arbol asociado a una lista de un unico elemento
* es el que lleva como campo 'info' el propio elemento
* y como hijos izquierdo y derecho nil */
build_tree([A-_], tree(A, nil, nil)).

/* Ejercio 7.1 */
/* El elemento codificado de X en el arbol 
* tree(X, nil, nil) es una lista vacia, ya que no
* tenemos que tomar ni hijo izquierdo ni hijo derecho 
* (caso base de la recursion) */
encode_elem(X, [], tree(X, nil, nil)).
/* El elemento X codificado en el arbol, si no esta en el
* hijo izquierdo, sera un 1 seguido del resultado de
* continuar la recursion por el hijo derecho */
encode_elem(X, [1|R1], tree(1, _, RTree)) :- 
    encode_elem(X, R1, RTree).
/* El elemento X codificado en un arbol de la forma
* tree(1, tree(X, nil, nil)), es decir, que su hijo
* izquierdo es un arbol cuyo campo 'info' es X
* es una lista que solo contiene un [0] */
encode_elem(X, [0], tree(1, tree(X, nil, nil), _)).

/* Ejercicio 7.2 */
/* El resultado de codificar una lista vacia
* es una lista vacia sin importar el arbol */
encode_list([], [], _).
/* El resultado de codificar una lista no vacia
* es una lista que contiene como primer elemento
* la codificacion del primer elemento de la lista 
* recibida como argumento
* y como resto de elementos el resultado de continuar
* la recursion por el resto de la lista recibida 
* como argumento */
encode_list([X|R], [EncX|Recursion], L) :-
    	encode_elem(X, EncX, L), 
    	encode_list(R, Recursion, L).

/* EJERCICIO 8*/

dictionary([a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z]).


/*
* Para que Lresult sea [X|Y] (= L) codificada, necesitamos que
*   1. Lresult sea el resultado de codificar L con un arbol Ltree, y
*   2. Que Ltree este construido a partir de una lista Linv que ordene de 
* mayor a menor frecuencia las letras del diccionario que se encuentren en L. 
*
* Esta ultima condicion se traduce en que 
*   1. Linv sea la inversion de una lista Lsort,
*   2. Donde Lsort contiene ordenadas de menor a mayor frecuencia las letras
* del diccionario Dict segun aparecen en L
*/
encode([X|Y], Lresult) :-
    dictionary(Dict),
    list_count(Dict, [X|Y], Lcount),
    sort_list(Lcount, Lsort),
    invierte(Lsort, Linv),
    build_tree(Linv, Ltree),
    encode_list([X|Y], Lresult, Ltree).
/*
encode([i,a],X).
X = [[0], [1, 0]] ;
false.

?- encode([i,2,a],X).
false.

?- encode([i,n,t,e,l,i,g,e,n,c,i,a,a,r,t,i,f,i,c,i,a,l],X).
X = [[0], [1, 1, 1, 0], [1, 1, 0], [1, 1, 1, 1, 1, 0], [1, 1, 1, 1, 0], [0], [1, 1, 1, 1, 1, 1, 1, 1, 0], [1, 1, 1, 1, 1, 0], [1, 1, 1, 0], [1, 1, 1, 1, 1, 1, 0], [0], [1, 0], [1, 0], [1, 1, 1, 1, 1, 1, 1, 0], [1, 1, 0], [0], [1, 1, 1, 1, 1, 1, 1, 1, 1, 0], [0], [1, 1, 1, 1, 1, 1, 0], [0], [1, 0], [1, 1, 1, 1, 0]] ;
false
*/
