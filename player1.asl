//Player 1

/* Initial beliefs and rules */
igual(X,Y,X,Y).	

igualColor(X,Y,C,C):-datos(X,Y,C).

datos(X,Y,Color,Tipo,Prop):- tablero(celda(X,Y,Prop),ficha(Color,Tipo)).

fichaEspecial(X,Y):-datos(X,Y,_,Tipo,_) & (Tipo = ct | Tipo = co | Tipo = gs | Tipo = ip).

esObstaculo(X,Y):-tablero(celda(X,Y,_),ficha(-1,_)).


//Agrupaciones de 3
grupo3FilA(X,Y,C,A,B) :- // #_#
	size(N) & X-1 >= 0 & X+1 < N & datos(X-1,Y,C) & datos(X,Y,_) & datos(X+1,Y,C) &
	not igual(X-1,Y,A,B) & not igual(X+1,Y,A,B).
	
grupo3FilB(X,Y,C,A,B) :- // _##
	size(N) & X+2 < N & datos(X+1,Y,C) & datos(X,Y,_) & datos(X+2,Y,C) &
	not igual(X+1,Y,A,B) & not igual(X+2,Y,A,B).
	
grupo3FilC(X,Y,C,A,B) :- // ##_
	size(N) & X-2 >= 0 & datos(X-1,Y,C) & datos(X,Y,_) & datos(X-2,Y,C) &
	not igual(X-1,Y,A,B) & not igual(X-2,Y,A,B).
	
grupo3ColA(X,Y,C,A,B) :- // #_# (ficha desde medio)
	size(N) & Y-1 >= 0 & Y+1 < N & datos(X,Y-1,C) & datos(X,Y,_) & datos(X,Y+1,C) &
	not igual(X,Y-1,A,B) & not igual(X,Y+1,A,B).
	
grupo3ColB(X,Y,C,A,B) :- // _## (ficha desde medio)
	size(N) & Y+2 < N & datos(X,Y+1,C) & datos(X,Y,_) & datos(X,Y+2,C) &
	not igual(X,Y+1,A,B) & not igual(X,Y+2,A,B).
	
grupo3ColC(X,Y,C,A,B) :- // #_# (ficha desde medio)
	size(N) & Y-2 >= 0 & datos(X,Y-1,C) & datos(X,Y,_) & datos(X,Y-2,C) &
	not igual(X,Y-1,A,B) & not igual(X,Y-2,A,B).
	
	
//Con ficha especial

grupo3FilAEspecial(X,Y,C,A,B) :- // #_#
	size(N) & X-1 >= 0 & X+1 < N & datos(X-1,Y,C) & datos(X,Y,_) & datos(X+1,Y,C) &
	not igual(X-1,Y,A,B) & not igual(X+1,Y,A,B)  & not igual(X,Y+1,A,B) & (fichaEspecial(X-1,Y) | fichaEspecial(X+1,Y) | fichaEspecial(A,B)).
	
grupo3FilBEspecial(X,Y,C,A,B) :- // _##
	size(N) & X+2 < N & datos(X+1,Y,C) & datos(X,Y,_) & datos(X+2,Y,C) &
	not igual(X+1,Y,A,B) & not igual(X+2,Y,A,B) & (fichaEspecial(X+1,Y) | fichaEspecial(X+2,Y) | fichaEspecial(A,B)).
	
grupo3FilCEspecial(X,Y,C,A,B) :- // ##_
	size(N) & X-2 >= 0 & datos(X-1,Y,C) & datos(X,Y,_) & datos(X-2,Y,C) &
	not igual(X-1,Y,A,B) & not igual(X-2,Y,A,B) & (fichaEspecial(X-1,Y) | fichaEspecial(X-2,Y) | fichaEspecial(A,B)).
	
	
grupo3ColAEspecial(X,Y,C,A,B) :- // #_# (ficha desde medio)
	size(N) & Y-1 >= 0 & Y+1 < N & datos(X,Y-1,C) & datos(X,Y,_) & datos(X,Y+1,C) &
	not igual(X,Y-1,A,B) & not igual(X,Y+1,A,B) & (fichaEspecial(X,Y-1) | fichaEspecial(X,Y+1) | fichaEspecial(A,B)).
	
grupo3ColBEspecial(X,Y,C,A,B) :- // _## (ficha desde medio)
	size(N) & Y+2 < N & datos(X,Y+1,C) & datos(X,Y,_) & datos(X,Y+2,C) &
	not igual(X,Y+1,A,B) & not igual(X,Y+2,A,B) & (fichaEspecial(X,Y+1) | fichaEspecial(X,Y+2) | fichaEspecial(A,B)).
	
grupo3ColCEspecial(X,Y,C,A,B) :- // #_# (ficha desde medio)
	size(N) & Y-2 >= 0 & datos(X,Y-1,C) & datos(X,Y,_) & datos(X,Y-2,C) &
	not igual(X,Y-1,A,B) & not igual(X,Y-2,A,B) & (fichaEspecial(X,Y-1) | fichaEspecial(X,Y-2) | fichaEspecial(A,B)).
	
		
//Agrupaciones de 4

grupo4FilA(X,Y,C,A,B) :- // #_##
	size(N) & X-1 >= 0 & X+2 < N & datos(X-1,Y,C) & datos(X,Y,_) & datos(X+1,Y,C) & datos(X+2,Y,C) &
	not igual(X-1,Y,A,B) & not igual(X+1,Y,A,B) & not igual(X+2,Y,A,B).
	
grupo4FilB(X,Y,C,A,B) :- // ##_#
	size(N) & X-2 >= 0 & X+1 < N & datos(X-1,Y,C) & datos(X-2,Y,C) & datos(X,Y,_) & datos(X+1,Y,C) &
	not igual(X-1,Y,A,B) & not igual(X-2,Y,A,B) & not igual(X+1,Y,A,B).	
	
grupo4ColA(X,Y,C,A,B) :- // #_## (Vertical)
	size(N) & Y-1 >= 0 & Y+2 < N & datos(X,Y-1,C) & datos(X,Y,_) & datos(X,Y+1,C) & datos(X,Y+2,C) &
	not igual(X,Y-1,A,B) & not igual(X,Y+1,A,B) & not igual(X,Y+2,A,B).
	
grupo4ColB(X,Y,C,A,B) :- // ##_# (Vertical)
	size(N) & Y-2 >= 0 & Y+1 < N & datos(X,Y-1,C) & datos(X,Y-2,C) & datos(X,Y,_) & datos(X,Y+1,C) &
	not igual(X,Y-1,A,B) & not igual(X,Y-2,A,B) & not igual(X,Y+1,A,B).
	
	
//Con ficha especial

grupo4FilAEspecial(X,Y,C,A,B) :- // #_##
	size(N) & X-1 >= 0 & X+2 < N & datos(X-1,Y,C) & datos(X,Y,_) & datos(X+1,Y,C) & datos(X+2,Y,C) &
	not igual(X-1,Y,A,B) & not igual(X+1,Y,A,B) & not igual(X+2,Y,A,B) &
	(fichaEspecial(X-1,Y) | fichaEspecial(X+1,Y) | fichaEspecial(X+2,Y) | fichaEspecial(A,B)).
	
grupo4FilBEspecial(X,Y,C,A,B) :- // ##_#
	size(N) & X-2 >= 0 & X+1 < N & datos(X-1,Y,C) & datos(X-2,Y,C) & datos(X,Y,_) & datos(X+1,Y,C) &
	not igual(X-1,Y,A,B) & not igual(X-2,Y,A,B) & not igual(X+1,Y,A,B) &
	(fichaEspecial(X-1,Y) | fichaEspecial(X-1,Y) | fichaEspecial(X+1,Y) | fichaEspecial(A,B)).	
	
grupo4ColAEspecial(X,Y,C,A,B) :- // #_## (Vertical)
	size(N) & Y-1 >= 0 & Y+2 < N & datos(X,Y-1,C) & datos(X,Y,_) & datos(X,Y+1,C) & datos(X,Y+2,C) &
	not igual(X,Y-1,A,B) & not igual(X,Y+1,A,B) & not igual(X,Y+2,A,B) &
	(fichaEspecial(X,Y-1) | fichaEspecial(X,Y+1) | fichaEspecial(X,Y+2) | fichaEspecial(A,B)).
	
grupo4ColBEspecial(X,Y,C,A,B) :- // ##_# (Vertical)
	size(N) & Y-2 >= 0 & Y+1 < N & datos(X,Y-1,C) & datos(X,Y-2,C) & datos(X,Y,_) & datos(X,Y+1,C) &
	not igual(X,Y-1,A,B) & not igual(X,Y-2,A,B) & not igual(X,Y+1,A,B) &
	(fichaEspecial(X,Y-1) | fichaEspecial(X,Y-2) | fichaEspecial(X,Y+1) | fichaEspecial(A,B)).
	
	
//Cuadrado	

grupo4SquareA(X,Y,C,A,B) :- // hueco arriba-izquierda
	size(N) & X+1 < N & Y+1 < N & datos(X,Y,_) & datos(X+1,Y,C) & datos(X,Y+1,C) & datos(X+1,Y+1,C) &
	not igual(X+1,Y,A,B) & not igual(X,Y+1,A,B) & not igual(X+1,Y+1,A,B).
	
grupo4SquareB(X,Y,C,A,B) :- // hueco arriba-derecha
	size(N) & X-1 >= 0 & Y+1 < N & datos(X,Y,_) & datos(X-1,Y,C) & datos(X,Y+1,C) & datos(X-1,Y+1,C) &
	not igual(X-1,Y,A,B) & not igual(X,Y+1,A,B) & not igual(X-1,Y+1,A,B).
	
grupo4SquareC(X,Y,C,A,B) :- // hueco abajo-izquierda
	size(N) & X+1 < N & Y-1 >= 0 & datos(X,Y,_) & datos(X+1,Y,C) & datos(X,Y-1,C) & datos(X+1,Y-1,C) &
	not igual(X+1,Y,A,B) & not igual(X,Y-1,A,B) & not igual(X+1,Y-1,A,B).
	
grupo4SquareD(X,Y,C,A,B) :- // hueco abajo-derecha
	size(N) & X-1 >= 0 & Y+1 < N & datos(X,Y,_) & datos(X-1,Y,C) & datos(X,Y-1,C) & datos(X-1,Y-1,C) &
	not igual(X-1,Y,A,B) & not igual(X,Y-1,A,B) & not igual(X-1,Y-1,A,B).	
	
	
//Con Ficha Especial

grupo4SquareAEspecial(X,Y,C,A,B) :- // hueco arriba-izquierda
	size(N) & X+1 < N & Y+1 < N & datos(X,Y,_) & datos(X+1,Y,C) & datos(X,Y+1,C) & datos(X+1,Y+1,C) &
	not igual(X+1,Y,A,B) & not igual(X,Y+1,A,B) & not igual(X+1,Y+1,A,B) &
	(fichaEspecial(X+1,Y) | fichaEspecial(X,Y+1) | fichaEspecial(X+1,Y+1) | fichaEspecial(A,B)).
	
grupo4SquareBEspecial(X,Y,C,A,B) :- // hueco arriba-derecha
	size(N) & X-1 >= 0 & Y+1 < N & datos(X,Y,_) & datos(X-1,Y,C) & datos(X,Y+1,C) & datos(X-1,Y+1,C) &
	not igual(X-1,Y,A,B) & not igual(X,Y+1,A,B) & not igual(X-1,Y+1,A,B) &
	(fichaEspecial(X-1,Y) | fichaEspecial(X,Y+1) | fichaEspecial(X-1,Y+1) | fichaEspecial(A,B)).
	
grupo4SquareCEspecial(X,Y,C,A,B) :- // hueco abajo-izquierda
	size(N) & X+1 < N & Y-1 >= 0 & datos(X,Y,_) & datos(X+1,Y,C) & datos(X,Y-1,C) & datos(X+1,Y-1,C) &
	not igual(X+1,Y,A,B) & not igual(X,Y-1,A,B) & not igual(X+1,Y-1,A,B) &
	(fichaEspecial(X+1,Y) | fichaEspecial(X,Y-1) | fichaEspecial(X+1,Y-1) | fichaEspecial(A,B)).
	
grupo4SquareDEspecial(X,Y,C,A,B) :- // hueco abajo-derecha
	size(N) & X-1 >= 0 & Y+1 < N & datos(X,Y,_) & datos(X-1,Y,C) & datos(X,Y-1,C) & datos(X-1,Y-1,C) &
	not igual(X-1,Y,A,B) & not igual(X,Y-1,A,B) & not igual(X-1,Y-1,A,B) &
	(fichaEspecial(X-1,Y) | fichaEspecial(X,Y-1) | fichaEspecial(X-1,Y-1) | fichaEspecial(A,B)).
	
	
//Agrupación de 5

grupo5Fil(X,Y,C,A,B) :- size(N) & X+2 < N & X-2 >= 0 & datos(X+1,Y,C) & datos(X+2,Y,C) & datos(X,Y,_) & datos(X-1,Y,C) & datos(X-2,Y,C) &
	not igual(X+1,Y,A,B) & not igual(X+2,Y,A,B) & not igual(X-1,Y,A,B) & not igual(X-2,Y,A,B).
	
//(Medio vertical)
grupo5Col(X,Y,C,A,B) :- size(N) & Y+2 < N & Y-2 >= 0 & datos(X,Y+1,C) & datos(X,Y+2,C) & datos(X,Y,_) & datos(X,Y-1,C) & datos(X,Y-2,C) &
	not igual(X,Y+1,A,B) & not igual(X,Y+2,A,B) & not igual(X,Y-1,A,B) & not igual(X,Y-2,A,B).
	
//Con especial
grupo5FilEspecial(X,Y,C,A,B) :- size(N) & X+2 < N & X-2 >= 0 & datos(X+1,Y,C) & datos(X+2,Y,C) & datos(X,Y,_) & datos(X-1,Y,C) & datos(X-2,Y,C) &
	not igual(X+1,Y,A,B) & not igual(X+2,Y,A,B) & not igual(X-1,Y,A,B) & not igual(X-2,Y,A,B) &
	(fichaEspecial(X+1,Y) | fichaEspecial(X+2,Y) | fichaEspecial(X-1,Y) | fichaEspecial(X-2,Y) | fichaEspecial(A,B)).
	
grupo5ColEspecial(X,Y,C,A,B) :- size(N) & Y+2 < N & Y-2 >= 0 & datos(X,Y+1,C) & datos(X,Y+2,C) & datos(X,Y,_) & datos(X,Y-1,C) & datos(X,Y-2,C) &
	not igual(X,Y+1,A,B) & not igual(X,Y+2,A,B) & not igual(X,Y-1,A,B) & not igual(X,Y-2,A,B) &
	(fichaEspecial(X,Y+1) | fichaEspecial(X,Y+2) | fichaEspecial(X,Y-1) | fichaEspecial(X,Y-2) | fichaEspecial(A,B)).
	
//Agrupación 5 en T
grupo5TN(X,Y,C,A,B) :- size(N) & X-1 >=0 & X+1 < N & Y+2 < N & datos(X-1,Y,C) & datos(X,Y,_) & datos(X+1,Y,C) & datos(X,Y+1,C) & datos(X,Y+2,C) &
	not igual(X-1,Y,A,B) & not igual(X+1,Y,A,B) & not igual(X,Y+1,A,B) & not igual(X,Y+2,A,B).
	
grupo5TI(X,Y,C,A,B) :- size(N) & X-1 >=0 & X+1 < N & Y-2 < N & datos(X-1,Y,C) & datos(X,Y,_) & datos(X+1,Y,C) & datos(X,Y-1,C) & datos(X,Y-2,C) &
	not igual(X-1,Y,A,B) & not igual(X+1,Y,A,B) & not igual(X,Y-1,A,B) & not igual(X,Y-2,A,B).
	
grupo5TR(X,Y,C,A,B) :- size(N) & X-2 >=0 & Y+1 < N & Y-1 >=0 & datos(X-1,Y,C) & datos(X-2,Y,C) & datos(X,Y,_) & datos(X,Y+1,C) & datos(X,Y-1,C) &
	not igual(X-1,Y,A,B) & not igual(X-2,Y,A,B) & not igual(X,Y+1,A,B) & not igual(X,Y-1,A,B).
	
grupo5TL(X,Y,C,A,B) :- size(N) & X+1 < N & Y+1 < N & Y-1 >=0 & datos(X+1,Y,C) & datos(X+2,Y,C) & datos(X,Y,_) & datos(X,Y+1,C) & datos(X,Y-1,C) &
	not igual(X+1,Y,A,B) & not igual(X+2,Y,A,B) & not igual(X,Y+1,A,B) & not igual(X,Y-1,A,B).
	

grupo5TNEspecial(X,Y,C,A,B) :- size(N) & X-1 >=0 & X+1 < N & Y+2 < N & datos(X-1,Y,C) & datos(X,Y,_) & datos(X+1,Y,C) & datos(X,Y+1,C) & datos(X,Y+2,C) &
	not igual(X-1,Y,A,B) & not igual(X+1,Y,A,B) & not igual(X,Y+1,A,B) & not igual(X,Y+2,A,B) &
	(fichaEspecial(X-1,Y) | fichaEspecial(X+1,Y) | fichaEspecial(X,Y+1) | fichaEspecial(X,Y+2) | fichaEspecial(A,B)).
	
grupo5TIEspecial(X,Y,C,A,B) :- size(N) & X-1 >=0 & X+1 < N & Y-2 < N & datos(X-1,Y,C) & datos(X,Y,_) & datos(X+1,Y,C) & datos(X,Y-1,C) & datos(X,Y-2,C) &
	not igual(X-1,Y,A,B) & not igual(X+1,Y,A,B) & not igual(X,Y-1,A,B) & not igual(X,Y-2,A,B) &
	(fichaEspecial(X-1,Y) | fichaEspecial(X+1,Y) | fichaEspecial(X,Y-1) | fichaEspecial(X,Y-2) | fichaEspecial(A,B)).
	
grupo5TREspecial(X,Y,C,A,B) :- size(N) & X-2 >=0 & Y+1 < N & Y-1 >=0 & datos(X-1,Y,C) & datos(X-2,Y,C) & datos(X,Y,_) & datos(X,Y+1,C) & datos(X,Y-1,C) &
	not igual(X-1,Y,A,B) & not igual(X-2,Y,A,B) & not igual(X,Y+1,A,B) & not igual(X,Y-1,A,B) &
	(fichaEspecial(X-1,Y) | fichaEspecial(X-2,Y) | fichaEspecial(X,Y+1) | fichaEspecial(X,Y-1) | fichaEspecial(A,B)).
	
grupo5TLEspecial(X,Y,C,A,B) :- size(N) & X+1 < N & Y+1 < N & Y-1 >=0 & datos(X+1,Y,C) & datos(X+2,Y,C) & datos(X,Y,_) & datos(X,Y+1,C) & datos(X,Y-1,C) &
	not igual(X+1,Y,A,B) & not igual(X+2,Y,A,B) & not igual(X,Y+1,A,B) & not igual(X,Y-1,A,B) &
	(fichaEspecial(X+1,Y) | fichaEspecial(X+2,Y) | fichaEspecial(X,Y+1) | fichaEspecial(X,Y-1) | fichaEspecial(A,B)).

//Para elegir la agrupacion prioritaria
grupo3(X,Y,C,A,B):- grupo3FilA(X,Y,C,A,B) | grupo3FilB(X,Y,C,A,B) | grupo3FilC(X,Y,C,A,B) | grupo3ColA(X,Y,C,A,B) | grupo3ColB(X,Y,C,A,B) | grupo3ColC(X,Y,C,A,B).	

grupo4(X,Y,C,A,B):- grupo4FilA(X,Y,C,A,B) | grupo4FilB(X,Y,C,A,B) | grupo4ColA(X,Y,C,A,B) | grupo4ColB(X,Y,C,A,B).

grupoCuadrado(X,Y,C,A,B):- grupo4SquareA(X,Y,C,A,B) | grupo4SquareB(X,Y,C,A,B) | grupo4SquareC(X,Y,C,A,B) | grupo4SquareD(X,Y,C,A,B).

grupoT(X,Y,C,A,B):- grupo5TN(X,Y,C,A,B) | grupo5TI(X,Y,C,A,B) | grupo5TR(X,Y,C,A,B) | grupo5TL(X,Y,C,A,B).

grupo5(X,Y,C,A,B):- grupo5Fil(X,Y,C,A,B) | grupo5Col(X,Y,C,A,B).

//Con especial
grupo3Especial(X,Y,C,A,B):- grupo3FilAEspecial(X,Y,C,A,B) | grupo3FilBEspecial(X,Y,C,A,B) | grupo3FilCEspecial(X,Y,C,A,B) | grupo3ColAEspecial(X,Y,C,A,B) | grupo3ColBEspecial(X,Y,C,A,B) | grupo3ColCEspecial(X,Y,C,A,B).

grupo4Especial(X,Y,C,A,B):- grupo4FilAEspecial(X,Y,C,A,B) | grupo4FilBEspecial(X,Y,C,A,B) | grupo4ColAEspecial(X,Y,C,A,B) | grupo4ColBEspecial(X,Y,C,A,B).

grupoCuadradoEspecial(X,Y,C,A,B):- grupo4SquareAEspecial(X,Y,C,A,B) | grupo4SquareBEspecial(X,Y,C,A,B) | grupo4SquareCEspecial(X,Y,C,A,B) | grupo4SquareDEspecial(X,Y,C,A,B).

grupoTEspecial(X,Y,C,A,B):- grupo5TNEspecial(X,Y,C,A,B) | grupo5TIEspecial(X,Y,C,A,B) | grupo5TREspecial(X,Y,C,A,B) | grupo5TLEspecial(X,Y,C,A,B).

grupo5EspecialEspecial(X,Y,C,A,B):- grupo5FilEspecial(X,Y,C,A,B) | grupo5ColEspecial(X,Y,C,A,B).



datos(X,Y,Color):- tablero(celda(X,Y,_),ficha(Color,_)).

direccion(0,"up").
direccion(1,"down").
direccion(2,"right").
direccion(3,"left").


randomMov(Mov):-
	size(Size) &
	.random(R1) & .random(R2) & .random(R3) & 
	direccion(4 * math.floor(R1), Dir) &
	Mov = moverDesdeEnDireccion(pos(math.floor(R2*Size) ,math.floor(R3 * Size)),Dir).

movPrueba(Mov) :- Mov = moverDesdeEnDireccion(pos(1,0),"left").
	
/* Initial goals */


/* Plans */

+buscarMejorJugada:size(N) <-
	-buscarMejorJugada;
	
	+borrarBusqueda;
	-borrarBusqueda;
	for(.range(X,0,N-1)){
		for(.range(Y,0,N-1)){
			if(datos(X,Y,C)){
				if(grupo5Especial(X,Y-1,C,X,Y) & not igualColor(X,Y-1,C,C) & not esObstaculo(X,Y-1)){-+grupo5Especial(X,Y,"up")};
				if(grupo5Especial(X,Y+1,C,X,Y) & not igualColor(X,Y+1,C,C) & not esObstaculo(X,Y+1)){-+grupo5Especial(X,Y,"down")};
				if(grupo5Especial(X-1,Y,C,X,Y) & not igualColor(X-1,Y,C,C) & not esObstaculo(X-1,Y)){-+grupo5Especial(X,Y,"left")};
				if(grupo5Especial(X+1,Y,C,X,Y) & not igualColor(X+1,Y,C,C) & not esObstaculo(X+1,Y)){-+grupo5Especial(X,Y,"right")};
				
				if(grupoTEspecial(X,Y-1,C,X,Y) & not igualColor(X,Y-1,C,C) & not esObstaculo(X,Y-1)){-+grupoTEspecial(X,Y,"up")};
				if(grupoTEspecial(X,Y+1,C,X,Y) & not igualColor(X,Y+1,C,C) & not esObstaculo(X,Y+1)){-+grupoTEspecial(X,Y,"down")};
				if(grupoTEspecial(X-1,Y,C,X,Y) & not igualColor(X-1,Y,C,C) & not esObstaculo(X-1,Y)){-+grupoTEspecial(X,Y,"left")};
				if(grupoTEspecial(X+1,Y,C,X,Y) & not igualColor(X+1,Y,C,C) & not esObstaculo(X+1,Y)){-+grupoTEspecial(X,Y,"right")};
				
				if(grupo4Especial(X,Y-1,C,X,Y) & not igualColor(X,Y-1,C,C) & not esObstaculo(X,Y-1)){-+grupo4Especial(X,Y,"up")};
				if(grupo4Especial(X,Y+1,C,X,Y) & not igualColor(X,Y+1,C,C) & not esObstaculo(X,Y+1)){-+grupo4Especial(X,Y,"down")};
				if(grupo4Especial(X-1,Y,C,X,Y) & not igualColor(X-1,Y,C,C) & not esObstaculo(X-1,Y)){-+grupo4Especial(X,Y,"left")};
				if(grupo4Especial(X+1,Y,C,X,Y) & not igualColor(X+1,Y,C,C) & not esObstaculo(X+1,Y)){-+grupo4Especial(X,Y,"right")};
				
				if(grupoCuadradoEspecial(X,Y-1,C,X,Y) & not igualColor(X,Y-1,C,C) & not esObstaculo(X,Y-1)){-+grupoCuadradoEspecial(X,Y,"up")};
				if(grupoCuadradoEspecial(X,Y+1,C,X,Y) & not igualColor(X,Y+1,C,C) & not esObstaculo(X,Y+1)){-+grupoCuadradoEspecial(X,Y,"down")};
				if(grupoCuadradoEspecial(X-1,Y,C,X,Y) & not igualColor(X-1,Y,C,C) & not esObstaculo(X-1,Y)){-+grupoCuadradoEspecial(X,Y,"left")};
				if(grupoCuadradoEspecial(X+1,Y,C,X,Y) & not igualColor(X+1,Y,C,C) & not esObstaculo(X+1,Y)){-+grupoCuadradoEspecial(X,Y,"right")};
				
				if(grupo3Especial(X,Y-1,C,X,Y) & not igualColor(X,Y-1,C,C) & not esObstaculo(X,Y-1)){-+grupo3Especial(X,Y,"up")};
				if(grupo3Especial(X,Y+1,C,X,Y) & not igualColor(X,Y+1,C,C) & not esObstaculo(X,Y+1)){-+grupo3Especial(X,Y,"down")};
				if(grupo3Especial(X-1,Y,C,X,Y) & not igualColor(X-1,Y,C,C) & not esObstaculo(X-1,Y)){-+grupo3Especial(X,Y,"left")};
				if(grupo3Especial(X+1,Y,C,X,Y) & not igualColor(X+1,Y,C,C) & not esObstaculo(X+1,Y)){-+grupo3Especial(X,Y,"right")};
							
				if(grupo5(X,Y-1,C,X,Y) & not igualColor(X,Y-1,C,C) & not esObstaculo(X,Y-1)){-+grupo5(X,Y,"up")};
				if(grupo5(X,Y+1,C,X,Y) & not igualColor(X,Y+1,C,C) & not esObstaculo(X,Y+1)){-+grupo5(X,Y,"down")};
				if(grupo5(X-1,Y,C,X,Y) & not igualColor(X-1,Y,C,C) & not esObstaculo(X-1,Y)){-+grupo5(X,Y,"left")};
				if(grupo5(X+1,Y,C,X,Y) & not igualColor(X+1,Y,C,C) & not esObstaculo(X+1,Y)){-+grupo5(X,Y,"right")};
				
				if(grupoT(X,Y-1,C,X,Y) & not igualColor(X,Y-1,C,C) & not esObstaculo(X,Y-1)){-+grupoT(X,Y,"up")};
				if(grupoT(X,Y+1,C,X,Y) & not igualColor(X,Y+1,C,C) & not esObstaculo(X,Y+1)){-+grupoT(X,Y,"down")};
				if(grupoT(X-1,Y,C,X,Y) & not igualColor(X-1,Y,C,C) & not esObstaculo(X-1,Y)){-+grupoT(X,Y,"left")};
				if(grupoT(X+1,Y,C,X,Y) & not igualColor(X+1,Y,C,C) & not esObstaculo(X+1,Y)){-+grupoT(X,Y,"right")};
				
				if(grupo4(X,Y-1,C,X,Y) & not igualColor(X,Y-1,C,C) & not esObstaculo(X,Y-1)){-+grupo4(X,Y,"up")};
				if(grupo4(X,Y+1,C,X,Y) & not igualColor(X,Y+1,C,C) & not esObstaculo(X,Y+1)){-+grupo4(X,Y,"down")};
				if(grupo4(X-1,Y,C,X,Y) & not igualColor(X-1,Y,C,C) & not esObstaculo(X-1,Y)){-+grupo4(X,Y,"left")};
				if(grupo4(X+1,Y,C,X,Y) & not igualColor(X+1,Y,C,C) & not esObstaculo(X+1,Y)){-+grupo4(X,Y,"right")};
				
				if(grupoCuadrado(X,Y-1,C,X,Y) & not igualColor(X,Y-1,C,C) & not esObstaculo(X,Y-1)){-+grupoCuadrado(X,Y,"up")};
				if(grupoCuadrado(X,Y+1,C,X,Y) & not igualColor(X,Y+1,C,C) & not esObstaculo(X,Y+1)){-+grupoCuadrado(X,Y,"down")};
				if(grupoCuadrado(X-1,Y,C,X,Y) & not igualColor(X-1,Y,C,C) & not esObstaculo(X-1,Y)){-+grupoCuadrado(X,Y,"left")};
				if(grupoCuadrado(X+1,Y,C,X,Y) & not igualColor(X+1,Y,C,C) & not esObstaculo(X+1,Y)){-+grupoCuadrado(X,Y,"right")};
				
				if(grupo3(X,Y-1,C,X,Y) & not igualColor(X,Y-1,C,C) & not esObstaculo(X,Y-1)){-+grupo3(X,Y,"up")};
				if(grupo3(X,Y+1,C,X,Y) & not igualColor(X,Y+1,C,C) & not esObstaculo(X,Y+1)){-+grupo3(X,Y,"down")};
				if(grupo3(X-1,Y,C,X,Y) & not igualColor(X-1,Y,C,C) & not esObstaculo(X-1,Y)){-+grupo3(X,Y,"left")};
				if(grupo3(X+1,Y,C,X,Y) & not igualColor(X+1,Y,C,C) & not esObstaculo(X+1,Y)){-+grupo3(X,Y,"right")};
			}
		}
	}.

+borrarBusqueda <-
	-borrarBusqueda;
	.findall(grupo5(A1,B1,D1),grupo5(A1,B1,D1),L1);for ( .member(K1,L1) ) {-K1;};
	.findall(grupoT(A2,B2,D2),grupoT(A2,B2,D2),L2);for ( .member(K2,L2) ) {-K2;};
	.findall(grupo4(A3,B3,D3),grupo4(A3,B3,D3),L3);for ( .member(K3,L3) ) {-K3;};
	.findall(grupoCuadrado(A4,B4,D4),grupoCuadrado(A4,B4,D4),L4);for ( .member(K4,L4) ) {-K4;};
	.findall(grupo3(A5,B5,D5),grupo3(A5,B5,D5),L5);for ( .member(K5,L5) ) {-K5;};
	
	.findall(grupo5Especial(A6,B6,D6),grupo5Especial(A6,B6,D6),L6);for ( .member(K6,L6) ) {-K6;};
	.findall(grupoTEspecial(A7,B7,D7),grupoTEspecial(A7,B7,D7),L7);for ( .member(K7,L7) ) {-K7;};
	.findall(grupo4Especial(A8,B8,D8),grupo4Especial(A8,B8,D8),L8);for ( .member(K8,L8) ) {-K8;};
	.findall(grupoCuadradoEspecial(A9,B9,D9),grupoCuadradoEspecial(A9,B9,D9),L9);for ( .member(K9,L9) ) {-K9;};
	.findall(grupo3Especial(A10,B10,D10),grupo3Especial(A10,B10,D10),L10);for ( .member(K10,L10) ) {-K10;}
	.
+eliminarDatosTablero <-
	-eliminarDatosTablero;
	.findall(tablero(X,Y),tablero(X,Y),Lista);	
	for ( .member(Datos,Lista) ) {
			-Datos[source(judge)];
		 }.
		 
//Comienzo del turno
+puedesMover[source(judge)] <- !realizarMovimiento.


//Realizacion de la jugada
+!realizarMovimiento <-
	//?randomMov(moverDesdeEnDireccion(pos(P1,P2),Dir));					
//	?movPrueba(moverDesdeEnDireccion(pos(P1,P2),Dir));
	+buscarMejorJugada;
	-buscarMejorJugada;
	if(grupo5Especial(A1,B1,D1)){
		.print("Quiero eliminar un grupo de 5 Especial");X=A1;Y=B1;D=D1;
	}else{
		if(grupoTEspecial(A2,B2,D2)){
			.print("Quiero eliminar un grupo de T Especial");X=A2;Y=B2;D=D2;
		}else{
			if(grupo4Especial(A3,B3,D3)){
				.print("Quiero eliminar un grupo de 4 Especial");X=A3;Y=B3;D=D3;
			}else{
				if(grupoCuadradoEspecial(A4,B4,D4)){
					.print("Quiero eliminar un grupo cuadrado Especial");X=A4;Y=B4;D=D4;
				}else{
					if(grupo3Especial(A5,B5,D5)){
						.print("Quiero eliminar un grupo de 3 Especial");X=A5;Y=B5;D=D5;
					}else{
						if(grupo5(A6,B6,D6)){
							.print("Quiero eliminar un grupo de 5");X=A6;Y=B6;D=D6;
						}else{
							if(grupoT(A7,B7,D7)){
								.print("Quiero eliminar un grupo de T");X=A7;Y=B7;D=D7;
							}else{
								if(grupo4(A8,B8,D8)){
									.print("Quiero eliminar un grupo de 4");X=A8;Y=B8;D=D8;
								}else{
									if(grupoCuadrado(A9,B9,D9)){
										.print("Quiero eliminar un grupo cuadrado");X=A9;Y=B9;D=D9;
									}else{
										if(grupo3(A10,B10,D10)){
											.print("Quiero eliminar un grupo de 3");X=A10;Y=B10;D=D10;
										}else{
											.print("Quiero eliminar un grupo Random");?randomMov(moverDesdeEnDireccion(pos(P1,P2),Dir));
											X=P1;Y=P2;D=Dir;
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
	
	.print("Intentando mover desde la posicion (",X,",",Y,") en direccion ",D);
	.wait(20);
	.send(judge,tell,moverDesdeEnDireccion(pos(X,Y),D));
	.send(judge,untell,moverDesdeEnDireccion(pos(X,Y),D)).

//Movimiento realizado correctamente
+valido[source(judge)] <- 
	+eliminarDatosTablero;
	-eliminarDatosTablero;
	.print("Movimiento correcto realizado").


//Movimiento realizado entre dos fichas del mismo color
+tryAgain[source(judge)] <- 
	!realizarMovimiento.

//Movimiento realizado fuera del tablero
+invalido(fueraTablero,N)[source(judge)] : N<=3 <-
	!realizarMovimiento.

+invalido(fueraTablero,N)[source(judge)] : N>3 <-
	.send(judge,tell,pasoTurno);
	.send(judge,untell,pasoTurno).

//Movimiento realizado fuera de turno
+invalido(fueraTurno,N)[source(judge)].

+deleteTableroBB[source(judge)]:true <-
	.abolish(tablero(_,_));.

//Plan por defecto a ejecutar en caso desconocido.
+Default[source(A)]: not A=self  & not tablero(C,F) & not size(N) <- 
	.print("El agente ",A," se comunica conmigo, pero no lo entiendo!").

