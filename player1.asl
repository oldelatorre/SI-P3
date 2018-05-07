/// Agent player1 in project practica.mas2j

/* Initial beliefs and rules */

cont(0).

//Permite obtener una pos X,Y con una Dir para realizar un movimiento correctamente
posicionAleatoria(pos(X,Y),Dir):- 
	size(N)&
	.random(OX,10) &
	.random(OY,10) &
	X = math.round(10*N*OX) mod N &
	Y = math.round(10*N*OY) mod N & 
	valorAleatorio(Valor) & 
	dirAleatoria(Dir,Valor) &
	not fueraTablero(pos(X,Y),Dir)&       
	not mismoColorFicha(pos(X,Y),Dir)
	& not vacio(pos(X,Y),Dir) &
	not obstaculo(pos(X,Y),Dir).

//Permite obtener un Valor aleatorio entre 0 y 3	
valorAleatorio(Valor) :- 
	.random(V,10)
	& Valor = (math.round(10*V) mod 4).

//Permite obtener una Dir dependiendo el valor de la variable Valor , y viceversa
dirAleatoria(Dir,Valor):- 
	(Valor = 0 & Dir = up) | 
	(Valor = 1 & Dir = down) | 
	(Valor = 2 & Dir = left) | 
	(Valor = 3 & Dir = right).	
	
//Comprueba si el movimiento se realiza fuera del tablero	
fueraTablero(pos(X,Y),Dir):-  
	mayorTamano(pos(X,Y),Dir) | 
	menorTamano(pos(X,Y),Dir). 
	
//Comprueba si el movimiento sobresale del tamaño maximo del tablero
mayorTamano(pos(X,Y),Dir):- 
	size(N) & 
	(X >= N | Y >= N | 
	((Dir = down)  & ((Y + 1) >= N)) | 
	((Dir = right) & ((X + 1) >= N))).
	
//Comprueba si el movimiento sobresale del tamaño minimo del tablero  	
menorTamano(pos(X,Y),Dir):- 
	negativo(X)| negativo(Y) | 
	((Dir = up) & (negativo(Y - 1))) | 
	((Dir = left) & (negativo(X - 1))).  
	
//Comprueba si un numero es negativo
negativo(X)[source(self)] :- X < 0. 
	
//Comprueba si el movimiento se realiza un intercambio de dos fichas con el
//mismo color
mismoColorFicha(pos(X,Y),Dir):- 
	 tablero(celda(X,Y,_),ficha(C,_)) &
	((Dir = up & tablero(celda(X,Y-1,_),ficha(C1,_)) & C = C1) |
	(Dir = down & tablero(celda(X,Y+1,_),ficha(C2,_)) & C = C2) |
	(Dir = left & tablero(celda(X-1,Y,_),ficha(C3,_)) & C = C3) |
	(Dir = right & tablero(celda(X+1,Y,_),ficha(C4,_)) & C = C4)) .  
	
	//Añadí estas dos reglas para poder hacer más arriba la comprobacion
vacio(pos(X,Y),Dir):- tablero(celda(X,Y,_),ficha(0,_)) | 
					(Dir = up & tablero(celda(X,Y-1,_),ficha(0,_))) |
					(Dir = down &  tablero(celda(X,Y+1,_),ficha(0,_))) |
					(Dir = left &  tablero(celda(X-1,Y,_),ficha(0,_))) |
					(Dir = right & tablero(celda(X+1,Y,_),ficha(0,_))).
							
obstaculo(pos(X,Y),Dir) :- tablero(celda(X,Y,_),ficha(4,_)) |
								(Dir = up & tablero(celda(X,Y-1,_),ficha(4,_))) |
								(Dir = down & tablero(celda(X,Y+1,_),ficha(4,_))) |
								(Dir = left & tablero(celda(X-1,Y,_),ficha(4,_))) |
								(Dir = right & tablero(celda(X+1,Y,_),ficha(4,_))).
/* Initial goals */
/* Plans */

//Se recibe la orden de mover y se envía la dirección a la que se desea mover
+puedesMover[source(judge)] <-!recorrerTablero;.
	
//Si no se recibe una posición aleatoria nos muestra un mensaje indicando el problema
+puedesMover[source(judge)] : not posicionAleatoria(pos(X,Y),Dir)[source(self)]<-
	.print("No encuento movimiento valido").

//El movimiento enviado fue inválido ya que no era el turno del agente	
+invalido(fueraTurno,Veces)[source(judge)] <-
	
	.print("Vez: ", Veces, " .El movimiento anterior era invalido porque se movió fuera del turno.\n").

//El movimiento enviado fue inválido ya que la posición enviada estaba fuera de los límtes del tablero	
+invalido(fueraTablero,Veces)[source(judge)] <-
	.print("Vez: ", Veces, " .El movimiento anterior era invalido porque se movió la ficha fuera del tablero. Se vuelve a enviar otro\n");
	 .send(judge,untell,moverDesdeEnDireccion(_,_));
	if(Veces == 3){
		.print("He jugado 3 veces fuera del tablero");
		.send(judge,tell,pasoTurno);
		.send(judge,untell,pasoTurno);
	}else{
		
		//Comprueba que el juez siga en el entorno del jugador
		.all_names(J);
		if(.member(judge,J)){
		?posicionAleatoria(pos(X1,Y1),Dir1);
		.print("Quiero mover de ",X1,",",Y1," hacia ",Dir1);
	    .send(judge,tell,moverDesdeEnDireccion(pos(X1,Y1),Dir1));
		}else{
			.print("Se ha perdido la comunicación con el juez\n");
		};
		}.
//Los dos mensajes de invalidonuevo con cada uno de los valores y el mensaje del
//player.
+invalidoNuevo(casillaObstaculo)[source(judge)] <-
		.print("He intentado mover hacia un obstáculo.Vuelvo a enviar un movimiento")
		.all_names(J);
		
		.send(judge,untell,moverDesdeEnDireccion(_,_));
			if(.member(judge,J)){
			 ?posicionAleatoria(pos(X1,Y1),Dir1);
			.print("Quiero mover de ",X1,",",Y1," hacia ",Dir1);
			.send(judge,tell,moverDesdeEnDireccion(pos(X1,Y1),Dir1));
				}else{
		.print("Se ha perdido la comunicación con el juez\n");
		}.
		
+invalidoNuevo(casillaVacia)[source(judge)]<-
		.print("He intentado mover hacia una casilla vacía. Vuelvo a enviar un movimiento");
		.all_names(J);
		
			.send(judge,untell,moverDesdeEnDireccion(_,_));
			if(.member(judge,J)){
				  ?posicionAleatoria(pos(X1,Y1),Dir1);
		          .print("Quiero mover de ",X1,",",Y1," hacia ",Dir1);
	              .send(judge,tell,moverDesdeEnDireccion(pos(X1,Y1),Dir1));
				}else{
		.print("Se ha perdido la comunicación con el juez\n");
		}.
//Si se mueve a una posición con una ficha del mismo color sigue enviando nuevas posiciones  
//hasta que una sea correcta
+tryAgain[source(judge)]<-
	 .send(judge,untell,moverDesdeEnDireccion(_,_));
  	.print("Vuelvo a enviar un movimiento ya que el juez me ha dicho que me he movido de una celda a otra con el mismo color de ficha ",X,", ",Y," a ", Dir,"\n");
	//Comprueba que el juez siga en el entorno del jugador
	.all_names(J);
	if(.member(judge,J)){
		?posicionAleatoria(pos(X1,Y1),Dir1);
		.print("Quiero mover de ",X1,",",Y1," hacia ",Dir1);
	    .send(judge,tell,moverDesdeEnDireccion(pos(X1,Y1),Dir1));
		
	}else{
		.print("Se ha perdido la comunicación con el juez\n");
	}.
	
////////////////////////////////////////////////////////////////////////////////
////////////		BUSCAR COMBINACIONES		////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


+!buscarCombinaciones<-

		!cincoFichasEspecialTDer;
		
		!cincoFichasEspecialTIzq;
		
		!cincoFichasEspecialTIvertida;
		
		!cincoFichasEspecialT;
		!cincoFichasEspecialV1;
		!cincoFichasEspecialV2;
		!cincoFichasEspecialH1;
		!cincoFichasEspecialH2;
		!tresFichasEspecialH8;
		
		!tresFichasEspecialH7;
		
		!tresFichasEspecialH6;
		
		!tresFichasEspecialH5;
		
		!tresFichasEspecialH4;
		
		!tresFichasEspecialH3;
		
		!tresFichasEspecialH2;
		
		!tresFichasEspecialH1;
		
		!tresFichasEspecialV1;
		
		!tresFichasEspecialV2;
		
		!tresFichasEspecialV3;
		
		!tresFichasEspecialV4;
		
		!tresFichasEspecialV5;
		
		!tresFichasEspecialV6;
		
		!tresFichasEspecialV7;
		
		!tresFichasEspecialV8;
		
		!cuatroFichasEspecialV21;
		
		!cuatroFichasEspecialV22;
		
		!cuatroFichasEspecialV11;
		
		!cuatroFichasEspecialV12;
		
		!cuatroFichasEspecialH22;
		
		!cuatroFichasEspecialH21;
		
		!cuatroFichasEspecialH11;
		
		!cuatroFichasEspecialH12;
		
		!cuatroFichasEspecialC42;
		
		!cuatroFichasEspecialC41;
		
		!cuatroFichasEspecialC31;
		
		!cuatroFichasEspecialC32;
		
		!cuatroFichasEspecialC21;
		
		!cuatroFichasEspecialC22;
		
		!cuatroFichasEspecialC12;
		
		!cuatroFichasEspecialC11;
		
		
		
	.

+!recorrerTablero: size(N) <-
	.print("Buscando mov");
	+estructura(-1,-1,rigth,-10);
	

	!buscarCombinaciones;
	
	
	.print("Hechas las comprobaciones de combinaciones");
	!movimiento;
	
	
	!eliminarCreencias;
	.
	
/*Realiza la combinación de mayor puntuación. */	
+!movimiento <-

		?estructura(X,Y, Dir, P);
		if (X == -1 & Y == -1){
			?posicionAleatoria(pos(X1,Y1),Dir1);
			.print("Quiero mover de ",X1,",",Y1," hacia ",Dir1);
			.send(judge,tell,moverDesdeEnDireccion(pos(X1,Y1),Dir1));
		}else {
		.print("Quiero mover de ",X,",",Y," hacia ",Dir);
			.send(judge,tell,moverDesdeEnDireccion(pos(X,Y),Dir));
		}
		
.


+!eliminarCreencias:size(N)<-

	-estructura(_,_,_,_);
.

// Y-1 == ARRIBA	Y+1 == ABAJO	X+1 == DER.	X-1 == IZQ.

//Punto de referencia la primera x fija

/**
 * 3 fichas horizontal
 *   x
 * X o x
 */
+!tresFichasEspecialH8 <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & tablero(celda(X+1,Y,_),ficha(Color2,_)) & Color2 > 4 & Y1=Y-1 & X1=X+1 & X2=X+2 & Y2= Y & Color > 4 & Y > 0 & size(N) & X < N-2 
			, ListaFichas);
	
	.print("tresFichasEspecialH8: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		?estructura(X1,Y1,Dir,Max);
		?cont(N);
		
		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A+1,B-1,down,N);
		}
		-cont(N);
		}
		.
/**
 * 3 fichas horizontal
 * X o x
 *   x
 */
+!tresFichasEspecialH7 <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & tablero(celda(X+1,Y,_),ficha(Color2,_)) & Color2 > 4 & Y1=Y & X1=X+2 & X2=X+1 & Y2= Y+1 & Color > 4 & Y < N-1 & size(N) & X < N-2 
			, ListaFichas);
	
	.print("tresFichasEspecialH7: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		?estructura(X1,Y1,Dir,Max);
		?cont(N);
		
		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A+1,B+1,up,N);
		}
		-cont(N);
		}
		.

/**
 * 3 fichas horizontal
 * X x o
 *     x
 */ 
+!tresFichasEspecialH6 <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & tablero(celda(X+2,Y,_),ficha(Color2,_)) & Color2 > 4 &Y1=Y & X1=X+1 & X2=X+2 & Y2= Y+1 & Color > 4 & Y < N-1 & size(N) & X < N-2 
			, ListaFichas);
	
.print("tresFichasEspecialH6: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		?estructura(X1,Y1,Dir,Max);
		?cont(N);
		
		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A+2,B+1,up,N);
		}
		-cont(N);
		}
		.
/**
 * 3 fichas horizontal
 *     x
 * X x o
 */
+!tresFichasEspecialH5 <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & tablero(celda(X+2,Y,_),ficha(Color2,_)) & Color2 > 4 &Y1=Y & X1=X+1 & X2=X+2 & Y2= Y-1 & Color > 4 & Y > 0 & size(N) & X < N-2 
			, ListaFichas);
	
	.print("tresFichasEspecialH5: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		?estructura(X1,Y1,Dir,Max);
		?cont(N);
	
		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A+2,B-1,down,N);
		}
		-cont(N);
		}
		.
/**
 * 3 fichas horizontal
 * o x X
 * x
 */
+!tresFichasEspecialH4 <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & tablero(celda(X-2,Y,_),ficha(Color2,_)) & Color2 > 4 &Y1=Y+1 & X1=X-2 & X2=X-1 & Y2= Y & Color > 4 & Y < N-1 & size(N) & X < N-2 
			, ListaFichas);
.print("tresFichasEspecialH4: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		?estructura(X1,Y1,Dir,Max);
		?cont(N);
		
		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A-2,B+1,up,N);
		}
		-cont(N);
		}
		.
/**
 * 3 fichas horizontal, tomando como referencia X
 * x
 * o x X
 */
+!tresFichasEspecialH3 <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & tablero(celda(X-2,Y,_),ficha(Color2,_)) & Color2 > 4 & Y1=Y & X1=X-1 & X2=X-2 & Y2= Y-1 & Color > 4 & Y > 0 & size(N) & X < N-2 
			, ListaFichas);
	
	.print("tresFichasEspecialH3: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		?estructura(X1,Y1,Dir,Max);
		?cont(N);
		
		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A-2,B-1,down,N);
		}
		-cont(N);
		}
		.
//3 fichas horizontal, tomando como referencia X
/**
* x x o X 
**/
+!tresFichasEspecialH2 <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & tablero(celda(X-1,Y,_),ficha(Color2,_)) & Color2 > 4 &Y1=Y & X1=X-2 & X2=X-3 & Y2= Y & Color > 4  & size(N) & X > 2 
			, ListaFichas);
	
	.print("tresFichasEspecialH2: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		?estructura(X1,Y1,Dir,Max);
		?cont(N);
	
		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A,B,left,N);
		}
		-cont(N);
		}
		.
//3 fichas horizontal, tomando como referencia X
/**
* X o x x 
**/
+!tresFichasEspecialH1 <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & tablero(celda(X+1,Y,_),ficha(Color2,_)) & Color2 > 4 & Y1=Y & X1=X+2 & X2=X+3 & Y2= Y & Color > 4  & size(N) & X < N-3 
			, ListaFichas);
	.print("tresFichasEspecialH1: ",ListaFichas);
	
	for (.member(fichas(A,B,A1,B1,A2,B2), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		?estructura(X1,Y1,Dir,Max);
		?cont(N);
		
		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A,B,right,N);
		}
		-cont(N);
		}
		.
/**
 * 3 fichas vertical
 * x
 * o
 * x
 * X
 */
+!tresFichasEspecialV1 <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & tablero(celda(X,Y-2,_),ficha(Color2,_)) & Color2 > 4 & Y1=Y-1 & X1=X & X2=X & Y2= Y-3 & Color > 4  & size(N) & Y > 2 
			, ListaFichas);

	.print("tresFichasEspecialV1: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		?estructura(X1,Y1,Dir,Max);
		?cont(N);
	
		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A,B-3,down,N);
		}
		-cont(N);
		}
		.
	
/**
 * 3 fichas vertical
 * X
 * x
 * o
 * x
 */
+!tresFichasEspecialV2 <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & tablero(celda(X,Y+2,_),ficha(Color2,_)) & Color2 > 4 & Y1=Y+1 & X1=X & X2=X & Y2= Y+3 & Color > 4  & size(N) & Y < N-4
			, ListaFichas);

	.print("tresFichasEspecialV2: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		?estructura(X1,Y1,Dir,Max);
		?cont(N);

		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A,B+3,up,N);
		}
		-cont(N);
		}
		.

/**
 * 3 fichas vertical
 * X
 * x
 * o x
 */
+!tresFichasEspecialV3 <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & tablero(celda(X,Y+2,_),ficha(Color2,_)) & Color2 > 4 & Y1=Y+1 & X1=X & X2=X+1 & Y2= Y+2 & Color > 4 & Y < N-2 & size(N) & X < N
			, ListaFichas);
	
	.print("tresFichasEspecialV3: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		?estructura(X1,Y1,Dir,Max);
		?cont(N);
		
		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A+1,B+2,left,N);
		}
		-cont(N);
		}
		.
/**
 * 3 fichas vertical
 * o x
 * x
 * X
 */
+!tresFichasEspecialV4 <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & tablero(celda(X,Y-2,_),ficha(Color2,_)) & Color2 > 4 &Y1=Y-1 & X1=X & X2=X+1 & Y2= Y-2 & Color > 4  & size(N) & Y > 1 & X < N-2 
			, ListaFichas);

	.print("tresFichasEspecialV4: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		?estructura(X1,Y1,Dir,Max);
		?cont(N);
	
		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A+1,B-2,left,N);
		}
		-cont(N);
		}
		.

/**
 * 3 fichas vertical
 * x o
 *   x
 *   X
 */
+!tresFichasEspecialV5 <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & tablero(celda(X,Y-2,_),ficha(Color2,_)) & Color2 > 4 &Y1=Y-1 & X1=X & X2=X-1 & Y2= Y-2 & Color > 4  & size(N) & Y > 1 & X > 0
			, ListaFichas);
	.print("tresFichasEspecialV5: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		?estructura(X1,Y1,Dir,Max);
		?cont(N);

		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A-1,B-2,right,N);
		}
		-cont(N);
		}
		.

/**
 * 3 fichas vertical
 *   X
 *   x
 * x o
 */
+!tresFichasEspecialV6 <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & tablero(celda(X,Y+2,_),ficha(Color2,_)) & Color2 > 4 & Y1=Y+1 & X1=X & X2=X-1 & Y2= Y+2 & Color > 4  & size(N) & Y > 0 & X < N-2 
			, ListaFichas);

	.print("tresFichasEspecialV6: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		?estructura(X1,Y1,Dir,Max);
		?cont(N);

		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A-1,B+2,right,N);
		}
		-cont(N);
		}
		.
		
/**
 * 3 fichas vertical
 *      X
 * (7)x o x (8)
 *      x
 */
+!tresFichasEspecialV7 <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & tablero(celda(X,Y+1,_),ficha(Color2,_)) & Color2 > 4 &Y1=Y+2 & X1=X & X2=X-1 & Y2= Y+1 & Color > 4  & size(N) & Y < N-2 & X < 0
			, ListaFichas);
	     .print("tresFichasEspecialV7: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		?estructura(X1,Y1,Dir,Max);
		?cont(N);

		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A-1,B+1,right,N);
		}
		-cont(N);
		}
		.
		
		
/**
 * 3 fichas vertical
 *      X
 * (7)x o x (8)
 *      x
 */		
+!tresFichasEspecialV8 <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & tablero(celda(X,Y+1,_),ficha(Color2,_)) & Color2 > 4 & Y1=Y+2 & X1=X & X2=X+1 & Y2= Y+1 & Color > 4  & size(N) & Y < N-1 & X > 0
			, ListaFichas);
	.print("tresFichasEspecialV8: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		?estructura(X1,Y1,Dir,Max);
		?cont(N);
		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A+1,B+1,left,N);
		}
		-cont(N);
		}
		.

/**
 * 	4 fichas vertical
 *	    X
 *      x
 * (1)x o x(2)
 *	    x
 */
+!cuatroFichasEspecialV21 <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2,X3,Y3),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & 
			tablero(celda(X3,Y3,_),ficha(Color,_)) & tablero(celda(X,Y+2,_),ficha(Color2,_)) & Color2 > 4 &Y1=Y+1 & X1=X & X2=X & Y2= Y+3 & X3=X+1 & Y3=Y+2 & Color > 4  & size(N) & Y > 2 
			, ListaFichas);
.print("cuatroFichasEspecialV21: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2,A3,B3), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		!contadorPuntuacion(A3,B3);	
		?estructura(X1,Y1,Dir,Max);
		?cont(P);
		-cont(P);
		+cont(P+2);
		?cont(N);
		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A+1,B+2,left,N);
		}
		-cont(N);
		}
		.

/**
 * 	4 fichas vertical
 *	    X
 *      x
 * (1)x o x(2)
 *	    x
 */
+!cuatroFichasEspecialV22 <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2,X3,Y3),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & 
			tablero(celda(X3,Y3,_),ficha(Color,_)) & tablero(celda(X,Y+2,_),ficha(Color2,_)) & Color2 > 4 &Y1=Y+1 & X1=X & X2=X & Y2= Y+3 & X3=X-1 & Y3=Y+2 & Color > 4  & size(N) & Y < N-3 & X>0
			, ListaFichas);

	.print("cuatroFichasEspecialV22: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2,A3,B3), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		!contadorPuntuacion(A3,B3);	
		?estructura(X1,Y1,Dir,Max);
		?cont(P);
		-cont(P);
		+cont(P+2);
		
		?cont(N);
	
		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A-1,B+2,right,N);
		}
		-cont(N);
		}
		.
/**
 * 	4 fichas vertical, tomando como referencia X
 *	    X
 * (1)x o x(2)
 *	    x
 *	    x
 */
+!cuatroFichasEspecialV11 <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2,X3,Y3),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & 
			tablero(celda(X3,Y3,_),ficha(Color,_)) & tablero(celda(X,Y+1,_),ficha(Color2,_)) & Color2 > 4 &Y1=Y+2 & X1=X & X2=X & Y2= Y+3 & X3=X+1 & Y3=Y+1 & Color > 4  & size(N) & Y < N-3 & X < N-1
			, ListaFichas);

	.print("cuatroFichasEspecialV11: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2,A3,B3), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		!contadorPuntuacion(A3,B3);	
		?estructura(X1,Y1,Dir,Max);
		?cont(P);
		-cont(P);
		+cont(P+2);
		
		?cont(N);

		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A+1,B+1,left,N);
		}
		-cont(N);
		}
		.
/**
 * 	4 fichas vertical, tomando como referencia X
 *	    X
 * (1)x o x(2)
 *	    x
 *	    x
 */
+!cuatroFichasEspecialV12 <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2,X3,Y3),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & 
			tablero(celda(X3,Y3,_),ficha(Color,_)) & tablero(celda(X,Y+1,_),ficha(Color2,_)) & Color2 > 4 &Y1=Y+2 & X1=X & X2=X & Y2= Y+3 & X3=X-1 & Y3=Y+1 & Color > 4  & size(N) & Y < N-3 & X>0
			, ListaFichas);
	
	.print("cuatroFichasEspecialV12: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2,A3,B3), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		!contadorPuntuacion(A3,B3);	
		?estructura(X1,Y1,Dir,Max);
		?cont(P);
		-cont(P);
		+cont(P+2);
		
		?cont(N);
		
		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A-1,B+1,right,N);
		}
		-cont(N);
		}
		.
//4 fichas horizontal, tomando X como referencia 
/*  x (1)
X x o x 
    x  (2)
*/
+!cuatroFichasEspecialH22 <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2,X3,Y3),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & 
			tablero(celda(X3,Y3,_),ficha(Color,_)) & tablero(celda(X+2,Y,_),ficha(Color2,_)) & Color2 > 4 &Y1=Y & X1=X+1 & X2=X+3 & Y2= Y & X3=X+2 & Y3=Y+1 & Color > 4  & size(N) & X < N-3 & Y < N-1
			, ListaFichas);

	.print("cuatroFichasEspecialH22: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2,A3,B3), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		!contadorPuntuacion(A3,B3);	
		?estructura(X1,Y1,Dir,Max);
		?cont(P);
		-cont(P);
		+cont(P+2);
		
		?cont(N);
		
		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A+2,B+1,up,N);
		}
		-cont(N);
		}
		.
//4 fichas horizontal, tomando X como referencia 
/*  x (1)
X x o x 
    x  (2)
*/
+!cuatroFichasEspecialH21 <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2,X3,Y3),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & 
			tablero(celda(X3,Y3,_),ficha(Color,_)) & tablero(celda(X+2,Y,_),ficha(Color2,_)) & Color2 > 4 &Y1=Y & X1=X+1 & X2=X+3 & Y2= Y & X3=X+2 & Y3=Y-1 & Color > 4  & size(N) & X < N-3 & Y > 0
			, ListaFichas);
	
		.print("cuatroFichasEspecialH21: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2,A3,B3), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		!contadorPuntuacion(A3,B3);	
		?estructura(X1,Y1,Dir,Max);
		?cont(P);
		-cont(P);
		+cont(P+2);
		
		?cont(N);
	
		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A+2,B-1,down,N);
		}
		-cont(N);
		}
		.
//4 fichas horizontal 
/** x (2)
* X o x x
*   x (1)
**/
+!cuatroFichasEspecialH11 <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2,X3,Y3),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & 
			tablero(celda(X3,Y3,_),ficha(Color,_)) & tablero(celda(X+1,Y,_),ficha(Color2,_)) & Color2 > 4 &Y1=Y & X1=X+2 & X2=X+3 & Y2= Y & X3=X+1 & Y3=Y+1 & Color > 4  & size(N) & X < N-3 & Y < N
			, ListaFichas);
	
		.print("cuatroFichasEspecialH11: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2,A3,B3), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		!contadorPuntuacion(A3,B3);	
		?estructura(X1,Y1,Dir,Max);
		?cont(P);
		-cont(P);
		+cont(P+2);
		
		?cont(N);
	
		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A+1,B+1,up,N);
		}
		-cont(N);
		}
		.
//4 fichas horizontal 
/** x (2)
* X o x x
*   x (1)
**/
+!cuatroFichasEspecialH12 <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2,X3,Y3),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & 
			tablero(celda(X3,Y3,_),ficha(Color,_)) & tablero(celda(X+1,Y,_),ficha(Color2,_)) & Color2 > 4 &Y1=Y & X1=X+2 & X2=X+3 & Y2= Y & X3=X+1 & Y3=Y-1 & Color > 4  & size(N) & X < N-3 & Y > 0
			, ListaFichas);
	
	.print("cuatroFichasEspecialH12: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2,A3,B3), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		!contadorPuntuacion(A3,B3);	
		?estructura(X1,Y1,Dir,Max);
		?cont(P);
		-cont(P);
		+cont(P+2);
		
		?cont(N);
		
		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A+1,B-1,down,N);
		}
		-cont(N);
		}
		.
		
/**
 * 4 fichas, tomando como referencia X
 *	  x(1) 
 *	X o x(2)
 *	x x 	
*/		
+!cuatroFichasEspecialC41 <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2,X3,Y3),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & 
			tablero(celda(X3,Y3,_),ficha(Color,_)) & tablero(celda(X+1,Y,_),ficha(Color2,_)) & Color2 > 4 &Y1=Y+1 & X1=X & X2=X+1 & Y2= Y+1 & X3=X+1 & Y3=Y-1 & Color > 4  & size(N) & X < N & X > 0 & Y > 0
			, ListaFichas);
	
	.print("cuatroFichasEspecialC41: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2,A3,B3), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		!contadorPuntuacion(A3,B3);	
		?estructura(X1,Y1,Dir,Max);
		?cont(P);
		-cont(P);
		+cont(P+4);
		
		?cont(N);
		
		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A+1,B-1,down,N);
		}
		-cont(N);
		}
		.
/**
 * 4 fichas, tomando como referencia X
 *	  x(1) 
 *	X o x(2)
 *	x x 	
*/		
+!cuatroFichasEspecialC42 <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2,X3,Y3),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & 
			tablero(celda(X3,Y3,_),ficha(Color,_)) & tablero(celda(X+1,Y,_),ficha(Color2,_)) & Color2 > 4 &Y1=Y+1 & X1=X & X2=X+1 & Y2= Y+1 & X3=X+2 & Y3=Y & Color > 4  & size(N) & X < N & X > 0 & Y > 0 &  Y > N-1
			, ListaFichas);
	
	.print("cuatroFichasEspecialC42: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2,A3,B3), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		!contadorPuntuacion(A3,B3);	
		?estructura(X1,Y1,Dir,Max);
		
		?cont(P);
		-cont(P);
		+cont(P+4);
		?cont(N);
		
		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A+2,B,left,N);
		}
		-cont(N);
		}
		.
/**
 * 4 fichas, tomando como referencia la X 
 *	     x (1)
 *	(2)x o x
 *	     X x	
*/
+!cuatroFichasEspecialC31 <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2,X3,Y3),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & 
			tablero(celda(X3,Y3,_),ficha(Color,_)) & tablero(celda(X,Y-1,_),ficha(Color2,_)) & Color2 > 4 &Y1=Y & X1=X+1 & X2=X+1 & Y2= Y-1 & X3=X & Y3=Y-2 & Color > 4  & size(N) & X < N  & Y > 0 & Y < N
			, ListaFichas);

	.print("cuatroFichasEspecialC31: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2,A3,B3), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		!contadorPuntuacion(A3,B3);	
		?estructura(X1,Y1,Dir,Max);
		?cont(P);
		-cont(P);
		+cont(P+4);
		
		?cont(N);
		
		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A,B-2,down,N);
		}
		-cont(N);
		}
		.
/**
 * 4 fichas, tomando como referencia la X 
 *	     x (1)
 *	(2)x o x
 *	     X x	
*/
+!cuatroFichasEspecialC32 <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2,X3,Y3),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & 
			tablero(celda(X3,Y3,_),ficha(Color,_)) & tablero(celda(X,Y-1,_),ficha(Color2,_)) & Color2 > 4 &Y1=Y & X1=X+1 & X2=X+1 & Y2= Y-1 & X3=X-1 & Y3=Y-1 & Color > 4  & size(N) & X < N & X > 0 & Y > 0 & Y < N
			, ListaFichas);
	
	
	.print("cuatroFichasEspecialC32: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2,A3,B3), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		!contadorPuntuacion(A3,B3);	
		?estructura(X1,Y1,Dir,Max);
		?cont(P);
		-cont(P);
		+cont(P+4);
		?cont(N);
		
		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A-1,B-1,right,N);
		}
		-cont(N);
		}
		.
/**
 * 4 fichas, tomando como referencia la X
 *	      X x
 *   (1)x o x
 *	      x
 *		 (2)
*/
+!cuatroFichasEspecialC21 <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2,X3,Y3),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & 
			tablero(celda(X3,Y3,_),ficha(Color,_)) & tablero(celda(X,Y+1,_),ficha(Color2,_)) & Color2 > 4 &Y1=Y & X1=X+1 & X2=X+1 & Y2= Y+1 & X3=X-1 & Y3=Y+1 & Color > 4  & size(N) & X < N  & Y < N-1 & Y < N
			, ListaFichas);
	
	.print("cuatroFichasEspecialC21: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2,A3,B3), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		!contadorPuntuacion(A3,B3);	
		?estructura(X1,Y1,Dir,Max);
		?cont(P);
		-cont(P);
		+cont(P+4);
		?cont(N);
		
		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A-1,B+1,right,N);			
		}
		-cont(N);
		}
		.
/**
 * 4 fichas, tomando como referencia la X
 *	      X x
 *   (1)x o x
 *	      x
 *		 (2)
*/
+!cuatroFichasEspecialC22 <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2,X3,Y3),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & 
			tablero(celda(X3,Y3,_),ficha(Color,_)) & tablero(celda(X,Y+1,_),ficha(Color2,_)) & Color2 > 4 &Y1=Y & X1=X+1 & X2=X+1 & Y2= Y+1 & X3=X & Y3=Y+2 & Color > 4  & size(N) & X < N  & X > 0 & Y < N
			, ListaFichas);
	
.print("cuatroFichasEspecialC22: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2,A3,B3), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		!contadorPuntuacion(A3,B3);	
		?estructura(X1,Y1,Dir,Max);
		?cont(P);
		-cont(P);
		+cont(P+4);
		?cont(N);
		
		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A,B+2,up,N);
		}
		-cont(N);
		}
		.

/**
 * 4 fichas, tomando como referencia la X
 *	X x 
 *	x o x (1)
 *	  x	(2)
*/
+!cuatroFichasEspecialC12 <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2,X3,Y3),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & 
			tablero(celda(X3,Y3,_),ficha(Color,_)) & tablero(celda(X+1,Y+1,_),ficha(Color2,_)) & Color2 > 4 &Y1=Y & X1=X+1 & X2=X & Y2= Y+1 & X3=X+1 & Y3=Y+2 & Color > 4  & size(N) & X < N  & Y < N-1 & Y < N
			, ListaFichas);
	
.print("cuatroFichasEspecialC12: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2,A3,B3), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		!contadorPuntuacion(A3,B3);	
		?estructura(X1,Y1,Dir,Max);
		?cont(P);
		-cont(P);
		+cont(P+4);
		?cont(N);
		
		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A+1,B+2,up,N);
			
		}
		-cont(N);
		}
		.

		
/**
 * 4 fichas, tomando como referencia la X
 *	X x 
 *	x o x (1)
 *	  x	(2)
*/
+!cuatroFichasEspecialC11 <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2,X3,Y3),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & 
			tablero(celda(X3,Y3,_),ficha(Color,_)) & tablero(celda(X+1,Y+1,_),ficha(Color2,_)) & Color2 > 4 &Y1=Y & X1=X+1 & X2=X & Y2= Y+1 & X3=X+2 & Y3=Y+1 & Color > 4  & size(N) & X < N & not( Y<N-1) & X < N-1 & Y < N
			, ListaFichas);
	
.print("cuatroFichasEspecialC11: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2,A3,B3), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		!contadorPuntuacion(A3,B3);	
		?estructura(X1,Y1,Dir,Max);
		?cont(P);
		-cont(P);
		+cont(P+4);
		?cont(N);
	
		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A+2,B+1,left,N);
		}
		-cont(N);
		}
		.		
		
		
		
		
		
		
		
		
		
//5 fichas en T tumbada a la derecha, tomamos como referencia la X
/*  x
X x o x
    x 
*/		
+!cincoFichasEspecialTDer <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2,X3,Y3,X4,Y4),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & 
			tablero(celda(X3,Y3,_),ficha(Color,_)) &
			tablero(celda(X4,Y4,_),ficha(Color,_))& tablero(celda(X+2,Y,_),ficha(Color2,_)) & Color2 > 4 &Y1=Y & X1=X+1 & X2=X+2 & Y2= Y-1 & X3=X+2 & Y3=Y+1 & X4 = X+3 & Y4 = Y & Color > 4  & size(N) & X < N  & Y < N-1 & X < N
			, ListaFichas);
	.print("cincoFichasEspecialTDer: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2,A3,B3,A4,B4), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		!contadorPuntuacion(A3,B3);	
		!contadorPuntuacion(A4,B4);	
		?estructura(X1,Y1,Dir,Max);
		?cont(P);
		-cont(P);
		+cont(P+6);
		?cont(N);
	
		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A+3,B,left,N);
		}
		-cont(N);
		}
		.              
//5 fichas en T tumbada a la izquierda, tomando como referencia la X
/*
  X
x o x x
  x
*/
+!cincoFichasEspecialTIzq <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2,X3,Y3,X4,Y4),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & 
			tablero(celda(X3,Y3,_),ficha(Color,_)) & 
			tablero(celda(X4,Y4,_),ficha(Color,_))& tablero(celda(X,Y+1,_),ficha(Color2,_)) & Color2 > 4 &Y1=Y+2 & X1=X & X2=X+1 & Y2= Y+1 & X3=X+2 & Y3=Y+1 & X4 = X-1 & Y4 = Y+1 & Color > 4  & size(N) & X < N-2  & Y < N-1 & X > 0
			, ListaFichas);
	
	.print("cincoFichasEspecialTIzq: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2,A3,B3,A4,B4), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		!contadorPuntuacion(A3,B3);	
		!contadorPuntuacion(A4,B4);	
		?estructura(X1,Y1,Dir,Max);
		?cont(P);
		-cont(P);
		+cont(P+6);
		?cont(N);
		
		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A-1,B+1,right,N);
		}
		-cont(N);
		}
		.    

//5 fichas en T invertida, tomando como referencia la X 
/*
   x
   x
 X o x
   x
*/ 
+!cincoFichasEspecialTIvertida <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2,X3,Y3,X4,Y4),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & 
			tablero(celda(X3,Y3,_),ficha(Color,_)) &
			tablero(celda(X4,Y4,_),ficha(Color,_))& tablero(celda(X+1,Y,_),ficha(Color2,_)) & Color2 > 4 &Y1=Y & X1=X+2 & X2=X+1 & Y2= Y-1 & X3=X+1 & Y3=Y-2 & X4 = X+1 & Y4 = Y+1 & Color > 4  & size(N) & X < N-1  & Y < N-1 & Y> 1
			, ListaFichas);
	
.print("cincoFichasEspecialTIvertida: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2,A3,B3,A4,B4), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		!contadorPuntuacion(A3,B3);	
		!contadorPuntuacion(A4,B4);	
		?estructura(X1,Y1,Dir,Max);
	?cont(P);
		-cont(P);
		+cont(P+6);
		?cont(N);
		
		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A+1,B+1,up,N);
		}
		-cont(N);
		}
		.  
//5 fichas en T normal, tomando como referencia la X 
/*
  x  
X o x
  x
  x
*/
+!cincoFichasEspecialT <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2,X3,Y3,X4,Y4),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & 
			tablero(celda(X3,Y3,_),ficha(Color,_)) &
			tablero(celda(X4,Y4,_),ficha(Color,_))& tablero(celda(X+1,Y,_),ficha(Color2,_)) & Color2 > 4 &Y1=Y & X1=X+2 & X2=X+1 & Y2= Y+1 & X3=X+1 & Y3=Y+2 & X4 = X+1 & Y4 = Y-1 & Color > 4  & size(N) & X < N-1  & Y < N-1 & Y> 0
			, ListaFichas);
	
.print("cincoFichasEspecialT: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2,A3,B3,A4,B4), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		!contadorPuntuacion(A3,B3);	
		!contadorPuntuacion(A4,B4);	
		?estructura(X1,Y1,Dir,Max);
		?cont(P);
		-cont(P);
		+cont(P+6);
		?cont(N);
		
		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A+1,B-1,down,N);
		}
		-cont(N);
		}
		.       
//5 fichas en vertical, tomo xomo referencia la X 
/*
     X
     x
     x
(1)x o x (2)
     x 
  */
+!cincoFichasEspecialV1 <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2,X3,Y3,X4,Y4),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & 
			tablero(celda(X3,Y3,_),ficha(Color,_)) &
			tablero(celda(X4,Y4,_),ficha(Color,_))& tablero(celda(X,Y+3,_),ficha(Color2,_)) & Color2 > 4 &Y1=Y+1 & X1=X & X2=X & Y2= Y+2 & X3=X & Y3=Y+4 & X4 = X+1 & Y4 = Y+3 & Color > 4  & size(N) & X < N & Y < N-3
			, ListaFichas);
	
.print("cincoFichasEspecialV1: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2,A3,B3,A4,B4), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		!contadorPuntuacion(A3,B3);	
		!contadorPuntuacion(A4,B4);	
		?estructura(X1,Y1,Dir,Max);
		?cont(P);
		-cont(P);
		+cont(P+8);
		?cont(N);
		
		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A+1,B+3,left,N);
		}
		-cont(N);
		}
		.  
//5 fichas en vertical, tomo xomo referencia la X 
/*
     X
     x
     x
(1)x o x (2)
     x 
  */
+!cincoFichasEspecialV2 <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2,X3,Y3,X4,Y4),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & 
			tablero(celda(X3,Y3,_),ficha(Color,_)) &
			tablero(celda(X4,Y4,_),ficha(Color,_))& tablero(celda(X,Y+3,_),ficha(Color2,_)) & Color2 > 4 &Y1=Y+1 & X1=X & X2=X & Y2= Y+2 & X3=X & Y3=Y+4 & X4 = X-1 & Y4 = Y+3 & Color > 4  & size(N) & X > 0 & Y < N-3
			, ListaFichas);
	
.print("cincoFichasEspecialV2: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2,A3,B3,A4,B4), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		!contadorPuntuacion(A3,B3);	
		!contadorPuntuacion(A4,B4);	
		?estructura(X1,Y1,Dir,Max);
		?cont(P);
		-cont(P);
		+cont(P+8);
		?cont(N);
		
		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A-1,B+3,right,N);
		}
		-cont(N);
		}
		.  
//5 fichas en horizontal.

/*
      x (2)
X x x o x
      x (1)
*/		
+!cincoFichasEspecialH1 <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2,X3,Y3,X4,Y4),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & 
			tablero(celda(X3,Y3,_),ficha(Color,_)) &
			tablero(celda(X4,Y4,_),ficha(Color,_))& tablero(celda(X+3,Y,_),ficha(Color2,_)) & Color2 > 4 &Y1=Y & X1=X+1 & X2=X+2 & Y2= Y & X3=X+4 & Y3=Y & X4 = X+3 & Y4 = Y+1 & Color > 4  & size(N) & X < N-3 & Y < N
			, ListaFichas);
	
.print("cincoFichasEspecialH1: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2,A3,B3,A4,B4), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		!contadorPuntuacion(A3,B3);	
		!contadorPuntuacion(A4,B4);	
		?estructura(X1,Y1,Dir,Max);
		?cont(P);
		-cont(P);
		+cont(P+8);
		?cont(N);
		
		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A+3,B+1,up,N);
		}
		-cont(N);
		}
		.             
//5 fichas en horizontal.

/*
      x (2)
X x x o x
      x (1)
*/		
+!cincoFichasEspecialH2 <-
	.findall(fichas(X,Y,X1,Y1,X2,Y2,X3,Y3,X4,Y4),
			tablero(celda(X,Y,_),ficha(Color,_)) &
			tablero(celda(X1,Y1,_),ficha(Color,_))&
			tablero(celda(X2,Y2,_),ficha(Color,_)) & 
			tablero(celda(X3,Y3,_),ficha(Color,_)) &
			tablero(celda(X4,Y4,_),ficha(Color,_))& tablero(celda(X+3,Y,_),ficha(Color2,_)) & Color2 > 4 &Y1=Y & X1=X+1 & X2=X+2 & Y2= Y & X3=X+4 & Y3=Y & X4 = X+3 & Y4 = Y-1 & Color > 4  & size(N) & X < N-3 & Y > 0
			, ListaFichas);
	
.print("cincoFichasEspecialH2: ",ListaFichas);
	for (.member(fichas(A,B,A1,B1,A2,B2,A3,B3,A4,B4), ListaFichas)){  
		+cont(0);
		!contadorPuntuacion(A,B);
		!contadorPuntuacion(A1,B1);
		!contadorPuntuacion(A2,B2);	
		!contadorPuntuacion(A3,B3);	
		!contadorPuntuacion(A4,B4);	
		?estructura(X1,Y1,Dir,Max);
		?cont(P);
		-cont(P);
		+cont(P+8);
		?cont(N);
		
		if(Max<N){
			-estructura(X1,Y1,Dir,Max);
			+estructura(A+3,B-1,down,N);
		}
		-cont(N);
		}

		.    
+!contadorPuntuacion(X,Y) :  tablero(celda(X,Y,_),ficha(Color,Tipo)) & cont(N) <-
	if ( Tipo == ip ) {
			-+cont(N+2);
		}else{ 
		if (Tipo == ct){
			-+cont(N+8);
		}else{
		if (Tipo == gs){
		  -+cont(N+4);
		}else{
		if (Tipo == co){
			-+cont(N+6);
		}else {
		-+cont(N+1);
		}
		
	
		};};};.
