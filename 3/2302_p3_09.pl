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
concatena([X|L1], L2, [X|L3]) :- concatena(L1, L2, L3).

/*
* Si L es la lista vacia, entonces L es el inverso de la lista vacia
*/
invierte([], L) :- L=[].
/*
* Dada cierta lista A: si L es la concatenacion del inverso del resto 
* de A con el primer elemento de A, entonces L es el inverso de A
*/
invierte([X|Y], L) :- invierte(Y, Inv), concatena(Inv , [X], L).

/*
?- invierte([1, 2], L).
L = [2, 1].

?- invierte([], L).
L = [].

?- invierte([1, 2], L).
L = [2, 1].
*/
1 2 4 5
3
/* Ejercicio 3 */
/* Si no hay lista en la que insertar,  la lista contendra
*  unicamente el propio elemento a insertar */
insert(X, [], X).
/* Si el elemento a insertar es menor
* que el primer elemento de la lista, hemos encontrado su lugar
* y devolvemos true si el ultimo elemento de la lista es el
* resultado de concatenar el elemento y el resto de la lista */
insert([C-A], [D-B|R1], X) :- A=<B, concatena([C-A], [D-B|R1], X).
/* Si el elemento a insertar es mayor que el primer
* elemento de la lista seguimos buscando y devolvemos true
* si el ultimo argumento es el resultado de concatenar
* el primer elemento de la lista con el resultado de
* continuar la recursion con el resto de la lista, es decir,
* con el resto de la lista con el elemento insertado */
insert([C-A], [D-B|R1], [D-B|X]) :- A>B , insert([C-A], R1, X).

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
elem_count(X, [X|Rs], Xn) :- elem_count(X, Rs, Num), Xn is Num + 1.
/*
* Un elto X aparece n veces en una lista L cuyo primer elto no es X (si lo
* fuera, se hubiera usado la regla anterior) si aparece n veces en el
* resto de L
*/
elem_count(X, [Y|Rs], Xn) :- X\=Y, elem_count(X, Rs, Xn).

/*
?- elem_count(b,[b,a,b,a,b],Xn).
Xn = 3 ;
false.

?- elem_count(a,[b,a,b,a,b],Xn).
Xn = 2 ;
false.
*/

/*  EJERCICIO 4.2*/
/*ESTO ESTA MAL. NI SIQUIERA ESTA PROBADO. ES UN INICIO DE IDEA*/
list_count([], [], []).
list_count([X|Y], L, [X-N|Z]):- elem_count(X, L, N), list_count(Y, L, Z).
list_count([X|Y], L, [T-N|Z]):- T\=X, list_count([X|Y], L, Z).


/* Ejercicio 5 */
/* La version ordenada de una lista vacia es la propia lista */
sort_list([], []).
/* Si la lista solo tiene un elemento ya esta ordenada */
sort_list([C-A], [C-A]).
/* La version ordenada de una lista con dos elementos o mas
* es la resultante de insertar (mediante la funcion insert del
* ejercicio 3) el primer elemento de la misma
* en el lugar correspondiente del resto ordenado de la lista. 
* (continuando con la recursion) */
sort_list([C-A|[D-B|R1]], X) :- 
          sort_list([D-B|R1], L), 
          insert([C-A], L, X).

/* Ejercicio 6 */
build_tree([A-B|R1], tree(1, Y, X)) :- build_tree(R1, X), build_tree([A-B], Y).
build_tree([A-_], tree(A, nil, nil)).

/* Ejercio 7.1 */
encode_elem(X1,,)


