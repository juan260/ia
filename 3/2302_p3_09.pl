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

/*  EJERCICIO 4.1*/

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
