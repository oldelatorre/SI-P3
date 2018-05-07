// Agent judge in project ESEI_SAGA.mas2j

//Autores: Roi Perez Lopez, Martin Puga Egea

/* ----- Initial beliefs and rules ------ */

jugadasRestantes(100).

jugadasPlayer(player1,0).
jugadasPlayer(player2,0).

turnoActual(player1).

turnoActivado(0).

fueraTablero(0).

fueraTurno(player1,0).
fueraTurno(player2,0).

jugadorDescalificado(player1,0).
jugadorDescalificado(player2,0).

recursivityFlag(1). //Flag utilizado como herramienta para implentar un mecanismo de recursividad en el algoritmo de explosion-gravedad-rellenado
explosionFlag(1). // Cuando el jugador provoca directamente una explosion, el flag se activa. Si las explosiones se producen por caidas, permanece desactivado.
dualExplosionFlag(0). //Flag que permite controlar situaciones de explosion de doble patron

level(1).

obstacles(10). //Numero de obstaculos a generar

limitPoints(1,300). //Puntuacion a obtener para ganar un nivel
limitPoints(2,300).

points(1,player1,0). //Puntuacion de cada jugador en cada nivel [ points(nivel,jugador,puntos) ]
points(1,player2,0).
points(2,player1,0).
points(2,player2,0).

levelWinner(1,none). //Ganador del nivel
levelWinner(2,none).

finalWinner(none). //Ganador del juego

endGame(0). //Flag que indica la finalizacion del juego al terminar todos los niveles

//Correspondencia entre el patron que explosiona y la ficha especial que se genera
specialSteak("4inLineH",ip).
specialSteak("4inLineW",ip).
specialSteak("5inLineH",ct).
specialSteak("5inLineW",ct).
specialSteak("Square",gs).
specialSteak("T",co).

//Puntos por generacion de ficha
generationPoints(in,0).
generationPoints(ip,2).
generationPoints(gs,4).
generationPoints(co,6).
generationPoints(ct,8).

//Comprobacion completa de las condiciones de un movimiento correcto: Seleccion, movimiento y color
movimientoValido(pos(X,Y),Dir):- tablero(celda(X,Y,_),ficha(COrigen,_)) & validacion(X,Y,Dir,COrigen).
validacion(X,Y,"up",COrigen) :- tablero(celda(X,Y-1,_),ficha(CDestino,_)) & not mismoColor(COrigen,CDestino).
validacion(X,Y,"down",COrigen) :- tablero(celda(X,Y+1,_),ficha(CDestino,_)) & not mismoColor(COrigen,CDestino).
validacion(X,Y,"left",COrigen) :- tablero(celda(X-1,Y,_),ficha(CDestino,_)) & not mismoColor(COrigen,CDestino).
validacion(X,Y,"right",COrigen) :- tablero(celda(X+1,Y,_),ficha(CDestino,_)) & not mismoColor(COrigen,CDestino).
mismoColor(COrigen,CDestino) :- COrigen=CDestino.

//Comprobacion de Movimiento
direccionCorrecta(pos(X,Y),Dir):- tablero(celda(X,Y,_),_) & movimiento(X,Y,Dir).
movimiento(X,Y,"up") :- tablero(celda(X,Y-1,_),_).
movimiento(X,Y,"down") :- tablero(celda(X,Y+1,_),_).
movimiento(X,Y,"left") :- tablero(celda(X-1,Y,_),_).
movimiento(X,Y,"right") :- tablero(celda(X+1,Y,_),_).

//Comprobacion de Color
colorFichasDistintos(pos(X,Y),Dir):- tablero(celda(X,Y,_),ficha(COrigen,_)) & validacion(X,Y,Dir,COrigen).

//Duenho de la jugada
plNumb(A,PlNumb):-
	(A == player1 & PlNumb = 1) | (A == player2 & PlNumb = 2).


//Calculo de coordenadas para un movimiento
nextPosition(P1,P2,Dir,NX,NY):-
	(
	(Dir == "up" & NX = P1 & NY= (P2 - 1)) |
	(Dir == "down" & NX = P1 & NY = (P2 + 1)) |
	(Dir == "right" & NX = (P1 + 1) & NY = P2) |
	(Dir == "left" & NX = (P1 - 1) & NY = P2)
	).


//Reconocimiento de patrones
//Los Patrones que devuelven mas puntos son los primeros.
comprobarPatrones(Color,X,Y,StartsAtX,StartAtY,Direction,Pattern) :-
	((pattern5inLineW(Color,X,Y,StartsAtX,StartAtY) & Pattern = "5inLineW" & Direction="none") |
	(pattern5inLineH(Color,X,Y,StartsAtX,StartAtY) & Pattern = "5inLineH" & Direction="none") |
	(patternT(Color,X,Y,Direction) & Pattern = "T" & StartAtY = Y & StartsAtX = X) |
	(patternSquare(Color,X,Y,StartsAtX,StartAtY) & Pattern = "Square" & Direction="none") |
	(pattern4inLineW(Color,X,Y,StartsAtX,StartAtY) & Pattern = "4inLineW" & Direction="none") |
	(pattern4inLineH(Color,X,Y,StartsAtX,StartAtY) & Pattern = "4inLineH" & Direction="none") |
	(pattern3inLineW(Color,X,Y,StartsAtX,StartAtY) & Pattern = "3inLineW" & Direction="none") |
	(pattern3inLineH(Color,X,Y,StartsAtX,StartAtY) & Pattern = "3inLineH" & Direction="none") |
	(Pattern = "none" & StartsAtX = X & StartAtY = Y & Direction="none")).


pattern5inLineH(Color,X,Y,StartsAtX,StartAtY) :-
	(tablero(celda(X,Y+1,_),ficha(Color,_)) &
	tablero(celda(X,Y+2,_),ficha(Color,_)) &
	tablero(celda(X,Y+3,_),ficha(Color,_)) &
	tablero(celda(X,Y+4,_),ficha(Color,_)) & StartAtY = Y & StartsAtX = X) |
	(tablero(celda(X,Y-4,_),ficha(Color,_)) &
	tablero(celda(X,Y-3,_),ficha(Color,_)) &
	tablero(celda(X,Y-2,_),ficha(Color,_)) &
	tablero(celda(X,Y-1,_),ficha(Color,_)) & StartAtY = (Y-4) & StartsAtX = X) |
	(tablero(celda(X,Y-3,_),ficha(Color,_)) &
	tablero(celda(X,Y-2,_),ficha(Color,_)) &
	tablero(celda(X,Y-1,_),ficha(Color,_)) &
	tablero(celda(X,Y+1,_),ficha(Color,_)) & StartAtY = (Y-3) & StartsAtX = X) |
	(tablero(celda(X,Y-2,_),ficha(Color,_)) &
	tablero(celda(X,Y-1,_),ficha(Color,_)) &
	tablero(celda(X,Y+1,_),ficha(Color,_)) &
	tablero(celda(X,Y+2,_),ficha(Color,_)) & StartAtY = (Y-2) & StartsAtX = X) |
	(tablero(celda(X,Y-1,_),ficha(Color,_)) &
	tablero(celda(X,Y+1,_),ficha(Color,_)) &
	tablero(celda(X,Y+2,_),ficha(Color,_)) &
	tablero(celda(X,Y+3,_),ficha(Color,_)) & StartAtY = (Y-1) & StartsAtX = X).


pattern5inLineW(Color,X,Y,StartsAtX,StartAtY) :-
	(tablero(celda(X+1,Y,_),ficha(Color,_)) &
	tablero(celda(X+2,Y,_),ficha(Color,_)) &
	tablero(celda(X+3,Y,_),ficha(Color,_)) &
	tablero(celda(X+4,Y,_),ficha(Color,_)) & StartAtY = Y & StartsAtX = X) |
	(tablero(celda(X-4,Y,_),ficha(Color,_)) &
	tablero(celda(X-3,Y,_),ficha(Color,_)) &
	tablero(celda(X-2,Y,_),ficha(Color,_)) &
	tablero(celda(X-1,Y,_),ficha(Color,_)) & StartAtY = Y & StartsAtX = (X-4)) |
	(tablero(celda(X-3,Y,_),ficha(Color,_)) &
	tablero(celda(X-2,Y,_),ficha(Color,_)) &
	tablero(celda(X-1,Y,_),ficha(Color,_)) &
	tablero(celda(X+1,Y,_),ficha(Color,_)) & StartAtY = Y & StartsAtX = (X-3)) |
	(tablero(celda(X-2,Y,_),ficha(Color,_)) &
	tablero(celda(X-1,Y,_),ficha(Color,_)) &
	tablero(celda(X+1,Y,_),ficha(Color,_)) &
	tablero(celda(X+2,Y,_),ficha(Color,_)) & StartAtY = Y & StartsAtX = (X-2)) |
	(tablero(celda(X-1,Y,_),ficha(Color,_)) &
	tablero(celda(X+1,Y,_),ficha(Color,_)) &
	tablero(celda(X+2,Y,_),ficha(Color,_)) &
	tablero(celda(X+3,Y,_),ficha(Color,_)) & StartAtY = Y & StartsAtX = (X-1)).

patternT(Color,X,Y,Direction) :-
	(tablero(celda(X+1,Y,_),ficha(Color,_)) &
	tablero(celda(X-1,Y,_),ficha(Color,_)) &
	tablero(celda(X,Y+1,_),ficha(Color,_)) &
	tablero(celda(X,Y+2,_),ficha(Color,_)) & Direction = "standing") |
	(tablero(celda(X+1,Y,_),ficha(Color,_)) &
	tablero(celda(X-1,Y,_),ficha(Color,_)) &
	tablero(celda(X,Y-1,_),ficha(Color,_)) &
	tablero(celda(X,Y-2,_),ficha(Color,_)) & Direction = "upside-down") |
	(tablero(celda(X,Y-1,_),ficha(Color,_)) &
	tablero(celda(X,Y+1,_),ficha(Color,_)) &
	tablero(celda(X+1,Y,_),ficha(Color,_)) &
	tablero(celda(X+2,Y,_),ficha(Color,_)) & Direction = "pointing-right") |
	(tablero(celda(X,Y-1,_),ficha(Color,_)) &
	tablero(celda(X,Y+1,_),ficha(Color,_)) &
	tablero(celda(X-1,Y,_),ficha(Color,_)) &
	tablero(celda(X-2,Y,_),ficha(Color,_)) & Direction = "pointing-left").

patternSquare(Color,X,Y,StartsAtX,StartAtY) :-
	(tablero(celda(X+1,Y,_),ficha(Color,_)) &
	tablero(celda(X,Y+1,_),ficha(Color,_)) &
	tablero(celda(X+1,Y+1,_),ficha(Color,_)) & StartAtY = Y & StartsAtX = X) |
	(tablero(celda(X-1,Y,_),ficha(Color,_)) &
	tablero(celda(X-1,Y+1,_),ficha(Color,_)) &
	tablero(celda(X,Y+1,_),ficha(Color,_)) & StartAtY = Y & StartsAtX = X) |
	(tablero(celda(X,Y-1,_),ficha(Color,_)) &
	tablero(celda(X+1,Y-1,_),ficha(Color,_)) &
	tablero(celda(X+1,Y,_),ficha(Color,_)) & StartAtY = Y & StartsAtX = X) |
	(tablero(celda(X-1,Y-1,_),ficha(Color,_)) &
	tablero(celda(X,Y-1,_),ficha(Color,_)) &
	tablero(celda(X-1,Y,_),ficha(Color,_)) & StartAtY = Y & StartsAtX = X).

pattern4inLineH(Color,X,Y,StartsAtX,StartAtY) :-
	(tablero(celda(X,Y+1,_),ficha(Color,_)) &
	tablero(celda(X,Y+2,_),ficha(Color,_)) &
	tablero(celda(X,Y+3,_),ficha(Color,_)) & StartAtY = Y & StartsAtX = X) |
	(tablero(celda(X,Y-1,_),ficha(Color,_)) &
	tablero(celda(X,Y-2,_),ficha(Color,_)) &
	tablero(celda(X,Y-3,_),ficha(Color,_)) & StartAtY = (Y-3) & StartsAtX = X) |
	(tablero(celda(X,Y-1,_),ficha(Color,_)) &
	tablero(celda(X,Y+1,_),ficha(Color,_)) &
	tablero(celda(X,Y+2,_),ficha(Color,_)) & StartAtY = (Y-1) & StartsAtX = X) |
	(tablero(celda(X,Y-2,_),ficha(Color,_)) &
	tablero(celda(X,Y-1,_),ficha(Color,_)) &
	tablero(celda(X,Y+1,_),ficha(Color,_)) & StartAtY = (Y-2) & StartsAtX = X).

pattern4inLineW(Color,X,Y,StartsAtX,StartAtY) :-
	(tablero(celda(X+1,Y,_),ficha(Color,_)) &
	tablero(celda(X+2,Y,_),ficha(Color,_)) &
	tablero(celda(X+3,Y,_),ficha(Color,_)) & StartsAtX = X & StartAtY = Y) |
	(tablero(celda(X-1,Y,_),ficha(Color,_)) &
	tablero(celda(X-2,Y,_),ficha(Color,_)) &
	tablero(celda(X-3,Y,_),ficha(Color,_)) & StartsAtX = (X-3) & StartAtY = Y) |
	(tablero(celda(X-1,Y,_),ficha(Color,_)) &
	tablero(celda(X+1,Y,_),ficha(Color,_)) &
	tablero(celda(X+2,Y,_),ficha(Color,_)) & StartsAtX = (X-1) & StartAtY = Y) |
	(tablero(celda(X-2,Y,_),ficha(Color,_)) &
	tablero(celda(X-1,Y,_),ficha(Color,_)) &
	tablero(celda(X+1,Y,_),ficha(Color,_)) & StartsAtX = (X-2) & StartAtY = Y).

pattern3inLineW(Color,X,Y,StartsAtX,StartAtY) :-
	(tablero(celda(X+1,Y,_),ficha(Color,_)) & tablero(celda(X+2,Y,_),ficha(Color,_)) &
	StartsAtX = X & StartAtY = Y) |
	(tablero(celda(X-1,Y,_),ficha(Color,_)) & tablero(celda(X-2,Y,_),ficha(Color,_)) &
	StartsAtX = (X-2) & StartAtY = Y) |
	(tablero(celda(X-1,Y,_),ficha(Color,_)) & tablero(celda(X+1,Y,_),ficha(Color,_)) &
	StartsAtX = (X-1) & StartAtY = Y).

pattern3inLineH(Color,X,Y,StartsAtX,StartAtY) :-
	(tablero(celda(X,Y+1,_),ficha(Color,_)) & tablero(celda(X,Y+2,_),ficha(Color,_)) &
	StartAtY = Y & StartsAtX = X) |
	(tablero(celda(X,Y-1,_),ficha(Color,_)) & tablero(celda(X,Y-2,_),ficha(Color,_)) &
	StartAtY = (Y-2) & StartsAtX = X) |
	(tablero(celda(X,Y-1,_),ficha(Color,_)) & tablero(celda(X,Y+1,_),ficha(Color,_)) &
	StartAtY = (Y-1) & StartsAtX = X).

//Reconocimiento de celda vacia  para el algoritmo de caida y rodar
emptyUnder(X,Y) :- tablero(celda(X,Y,_),ficha(_,_)) & tablero(celda(X,Y+1,_),e).
emptyLeft(X,Y) :- tablero(celda(X,Y,_),ficha(_,_)) & tablero(celda(X-1,Y,_),e).


//Comprobacion del ganador de un nivel
levelWinner(P1,P2,Winner) :- P1 > P2 & Winner = player1.
levelWinner(P1,P2,Winner) :- P2 > P1 & Winner = player2.
levelWinner(P1,P2,Winner) :- P1 = P2 & Winner = draw.




/* ----- Initial goals ----- */
  //No hay objetivos iniciales


/* ----- Plans ----- */

//Finalizacion de la partida
+!comienzoTurno : endGame(1) & levelWinner(1,W1) & levelWinner(2,W2)<-
		.print(" *  *  *  *  *  *  *  *  * *  RESULTADOS  * *  *  *  *  *  *  *  *  *");
		.print(" * Ganador Nivel 1 -> ",W1);
		.print(" * Ganador Nivel 2 -> ",W2);
		!checkFinalWinner(W1,W2);
		?finalWinner(FinalWinner);
		.print(" *  *  *  *  *  *  *  *  * *  *  *  *  *  *  *  *  * *  *  *  *  *  *  *  *  *");
		.print(" * Ganador de la partida -> ",FinalWinner," !!");
		.print(" *  *  *  *  *  *  *  *  * *  *  *  *  *  *  *  *  * *  *  *  *  *  *  *  *  *");
		.print("--- --- --- --- --- Fin del juego --- --- --- --- ---").

//Comprobacion del ganador de la partida
+!checkFinalWinner(W1,W2) : W1=draw & W2=draw <- -+finalWinner(player1). //Si hay empate en ambos niveles, ganara el jugador uno por ser el que abre la partida

+!checkFinalWinner(W1,W2) : W1=draw <- -+finalWinner(W2). //Empate en el primer nivel, por lo tanto gana el jugador que ha ganado el segundo nivel

+!checkFinalWinner(W1,W2) : W1=W2 <- -+finalWinner(W1). //Ambos niveles han sido ganados por el mismo jugador y por tanto es el ganador del juego

+!checkFinalWinner(W1,W2) : points(1,player1,PointsPlayer1Lvl1) & points(2,player1,PointsPlayer1Lvl2) & points(1,player2,PointsPlayer2Lvl1) & points(2,player2,PointsPlayer2Lvl2) & ((PointsPlayer1Lvl1+PointsPlayer1Lvl2) > (PointsPlayer2Lvl1+PointsPlayer2Lvl2)) <- -+finalWinner(player1). //Gana por total de puntos player1

+!checkFinalWinner(W1,W2) : points(1,player1,PointsPlayer1Lvl1) & points(2,player1,PointsPlayer1Lvl2) & points(1,player2,PointsPlayer2Lvl1) & points(2,player2,PointsPlayer2Lvl2) & ((PointsPlayer2Lvl1+PointsPlayer2Lvl2) > (PointsPlayer1Lvl1+PointsPlayer1Lvl2)) <- -+finalWinner(player2). //Gana por total de puntos player2

+!checkFinalWinner(W1,W2) <- .print("ERROR en !finalWinner").


/* ----------------------------------------------------- COMIENZO INTOCABLE ----------------------------------------------------- */

//Comienzo del turno de un jugador.
+!comienzoTurno : jugadorDescalificado(player1,1) & jugadorDescalificado(player2,1) <-
			.print("FIN DE LA PARTIDA: Ambos jugadores han sido descalificados. TRAMPOSOS!!!").

+!comienzoTurno : turnoActual(P) & jugadasRestantes(N) & N>0 & jugadasPlayer(P,J) & J<50 <-
	.print("Turno de: ",P,"!");
	-+turnoActivado(1);
	.print(P,", puedes mover");
	.send(P,tell,puedesMover);
	.send(P,untell,puedesMover).

+!comienzoTurno : jugadasRestantes(N) & N=0 <- .print("FIN DE LA PARTIDA: Se ha realizado el numero maximo de jugadas").


+!comienzoTurno : turnoActual(P) & jugadasPlayer(P,J) & J>=50 <- .print("FIN DE LA PARTIDA: ",P," ha realizado el maximo de jugadas por jugador (50)").


+!comienzoTurno <- .print("DEBUG: Error en +!comienzoTurno"). //Salvaguarda

+moverDesdeEnDireccion(pos(X,Y),Dir)[source(P)] :
	turnoActual(P) & movimientoValido(pos(X,Y),Dir) & turnoActivado(1) <-
			-+turnoActivado(0);
			-moverDesdeEnDireccion(pos(X,Y),Dir)[source(P)];
			.print("Jugada valida!")
			.send(P,tell,valido);
			.send(P,untell,valido);
			+intercambiarFichas(X,Y,Dir,P);
			-intercambiarFichas(X,Y,Dir,P);
			-+turnoTerminado(P);
			!comienzoTurno.

//Movimiento Incorrecto
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(P)] :
	turnoActual(P) & not movimientoValido(pos(X,Y),Dir) & turnoActivado(1)<-
			-+turnoActivado(0);
			+movimientoInvalido(pos(X,Y),Dir,P).

//Movimiento realizado por un jugador que tiene el turno pero el juez aun no le ha ordenado mover
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(P)] :
	turnoActual(P) & turnoActivado(0) <-
			.print("Agente ",P,", espera mi orden para realizar el siguiente movimiento. No intentes mover mas de una vez.").


//Movimiento realizado por un jugador fuera de su turno
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(P)] :
	not turnoActual(P) & fueraTurno(P,N) <-
		.print(P," Has intentado realizar un movimiento fuera de tu turno. ", N+1," aviso");
		.send(P,tell,invalido(fueraTurno,N+1));
		.send(P,untell,invalido(fueraTurno,N+1));
		-fueraTurno(P,N);
		+fueraTurno(P,N+1).

//Descalificacion de un jugador
+fueraTurno(P,N) : N>3 <-
		-jugadorDescalificado(P,0);
		+jugadorDescalificado(P,1);
		.print("AVISO: ",P," ha sido descalificado por tramposo!!!").



//Deteccion de un agente externo a la partida (distinto a player1 y player 2) que esta intentando jugar.
// Esta regla la podeis adecuar a vuestras necesidades

+moverDesdeEnDireccion(pos(X,Y),Dir)[source(P)] :
	not turnoActual(P) & not fueraTurno(P,N) <- // --- TODO ---
		.print("El agente ",P," externo a la partida est� intentando jugar.").

// Esta regla la podeis adecuar a vuestras necesidades
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(P)] <-
	.print("DEBUG: Error en +moverDesdeEnDireccion. Source", P). //Salvaguarda

//Comprobacion de la falta cometida por mover una ficha hacia una posicion fuera del tablero, intentar mover una ficha de una posicion inexistente, o realizar un tipo de movimiento desconocido
+movimientoInvalido(pos(X,Y),Dir,P):
	fueraTablero(V) & not direccionCorrecta(pos(X,Y),Dir)  <-
		-movimientoInvalido(pos(X,Y),Dir,P);
		.print("Movimiento Invalido. Has intentado mover una ficha fuera del tablero");
		.send(P,tell,invalido(fueraTablero,V+1));
		.send(P,untell,invalido(fueraTablero,V+1));
		-+turnoActivado(1);
		-+fueraTablero(V+1).

//Comprobacion de la falta cometida por intercambiar dos fichas del mismo color
+movimientoInvalido(pos(X,Y),Dir,P) :
	not colorFichasDistintos(pos(X,Y),Dir) <-
		-movimientoInvalido(pos(X,Y),Dir,P);
		.print("Movimiento Invalido. Has intentado  intercambiar dos fichas del mismo color");
		-+turnoActivado(1);
		.print("Intentalo de nuevo!");
		.send(P,tell,tryAgain);
		.send(P,untell,tryAgain).

// Esta regla la podeis adecuar a vuestras necesidades
+movimientoInvalido(pos(X,Y),Dir,P) <-
	.print("DEBUG: Error en +movimientoInvalido").


//Recepcion del aviso de que un jugador pasa turno por haber realizado un movimiento fuera del tablero mas de 3 veces
+pasoTurno[source(P)] : turnoActual(P) <-
		-+fueraTablero(0);
		.print(P," ha pasado turno");
		+cambioTurno(P);
		!comienzoTurno.

/* ----------------------------------------------------- FIN INTOCABLE ----------------------------------------------------- */




//Gestion del comienzo del juego
+startGame : size(N) <- //Este plan se ejecutará cuando el entorno le avise al terminar la generacion del tablero
				.print("Tablero de juego generado!");
				.send(player1,tell,size(N));
				.send(player2,tell,size(N));
				.wait(500);
				!mostrarTablero(player1);
				.wait(500);
				!mostrarTablero(player2);
				.print(" ----- ----- ----- ----- EMPIEZA EL JUEGO! ----- ----- ----- -----");
				.print("                ----- ----- ----- NIVEL 1 ----- ----- -----\n");
				!comienzoTurno.


//Recepcion del tamanho del tablero
+size(N).

//Recepcion de la informacion de una posicion del tablero. Actua como interface para que las creencias tablero sean self
+addTablero(Celda,Ficha)[source(percept)] <-
				-addTablero(Celda,Ficha)[source(percept)];
				+tablero(Celda,Ficha).


//Finalizacion de un turno
+turnoTerminado(Player) : level(L) & L=1 & (limitPoints(1,LimitPoints)  & points(L,Player,Points) & Points>=LimitPoints) | (jugadasRestantes(N) & N=0) |  (jugadasPlayer(Player,J) & J>=50) <- //Final del Nivel 1
					.print("Alcanzado el numero maximo de puntos en el Nivel 1");
					!showPoints;
					!checkLevelWinner;
					?levelWinner(1,Winner);
					.print("[ GANADOR NIVEL 1: ",Winner," ]\n");
					.print("                      ----- ----- ----- NIVEL 2 ----- ----- -----\n");
					.wait(1000);
					-+level(2);
					-+turnoActual(player1);
					-+jugadasRestantes(100);
					-jugadasPlayer(player1,_);
					+jugadasPlayer(player1,0);
					-jugadasPlayer(player2,_);
					+jugadasPlayer(player2,0);
					.abolish(tablero(X,Y));
					.wait(250);
					resetTablero(_);
					.wait(250);
					!generateObstacles;
					!updatePlayersTableroBB.



+turnoTerminado(Player) : level(L) & L=2 & (limitPoints(2,LimitPoints)  & points(L,Player,Points) & Points>=LimitPoints) | (jugadasRestantes(N) & N=0) |  (jugadasPlayer(Player,J) & J>=50) <- //Final del Nivel 2
					.print("Alcanzado el numero maximo de puntos en el Nivel 2");
					!showPoints;
					!checkLevelWinner;
					?levelWinner(2,Winner);
					.print("[ GANADOR NIVEL 2: ",Winner," ]");
					-+endGame(1).


+turnoTerminado(P): jugadorDescalificado(J,B) & B=1 <-
					!showPoints;
					!cambioTurnoMismoJugador(P,N,J). //Cambio de turno sobre el mismo jugador, ya que hay un jugador descalificado

+turnoTerminado(P) <-
					!showPoints;
					+cambioTurno(P). //Cambio de turno de forma normal

//Mostrar Puntuaciones
+!showPoints : level(L) & points(L,player1,P1) & points(L,player2,P2) <-	.print("Puntuaciones:  Player 1 -> ",P1,"  //  Player 2 -> ",P2).


//Comprobacion del ganador de nivel
+!checkLevelWinner : level(L) & points(L,player1,P1) & points(L,player2,P2) &  levelWinner(P1,P2,Winner) <-
				-levelWinner(L,_);
				+levelWinner(L,Winner).


//Cambio de turno de un jugador a otro
+cambioTurno(P) : jugadasRestantes(N) & jugadasPlayer(P,J)<-
				-cambioTurno(P);
				!cambioTurno(P,N,J).


+!cambioTurno(P,N,J) : P = player1 | jugadorDescalificado(player1,1) <-
					-+turnoActual(player2);
					-+jugadasRestantes(N-1);
					-jugadasPlayer(player1,J);
					+jugadasPlayer(player1,J+1);
					.print("[ Jugadas restantes: ", N-1," || Jugadas completadas ",P,": ", J+1," ]\n").


+!cambioTurno(P,N,J) : P = player2 | jugadorDescalificado(player2,1) <-
					-+turnoActual(player1);
					-+jugadasRestantes(N-1);
					-jugadasPlayer(player2,J);
					+jugadasPlayer(player2,J+1);
					.print("[ Jugadas restantes: ", N-1," || Jugadas completadas ",P,": ", J+1," ]\n").


//Cambio de turno cuando hay un jugador descalificado
+!cambioTurnoMismoJugador(P,N,J) :jugadasRestantes(N) & jugadasPlayer(P,J)<-
					-+jugadasRestantes(N-1);
					-jugadasPlayer(P,J);
					+jugadasPlayer(P,J+1);
					.print("[ Jugadas restantes: ", N-1," || Jugadas completadas ",P,": ", J+1," ]\n").




//Generacion aleatoria de obstaculos
+!generateObstacles : obstacles(N) & N>0 <-
					.random(X,10);
					.random(Y,10);
					!generateObstacle(math.round(9*X),math.round(9*Y));
					!generateObstacles.

+!generateObstacle(X,Y) : tablero(celda(X,Y,_),ficha(C,_)) & obstacles(N) <- //Obliga a generar los N obstaculos en celdas distintas
					-tablero(celda(X,Y,_),ficha(C,_));
					+tablero(celda(X,Y,0),obstacle);
					delete(C,X,Y);
					putObstacle(X,Y);
					-+obstacles(N-1).

+!generateObstacle(X,Y).
+!generateObstacles.





//Analisis del movimiento solicitado por un jugador
//Movimiento correcto
+intercambiarFichas(X1,Y1,Dir,P) : nextPosition(X1,Y1,Dir,X2,Y2) & plNumb(P,PlNumb) <-
								-+direction(Dir);
								-tablero(celda(X1,Y1,0),ficha(C1,TipoFicha1));
								-tablero(celda(X2,Y2,0),ficha(C2,TipoFicha2));
								+tablero(celda(X2,Y2,0),ficha(C1,TipoFicha1));
								+tablero(celda(X1,Y1,0),ficha(C2,TipoFicha2));
								exchange(C1,X1,Y1,C2,X2,Y2); //Intercambio de fichas en el tablero grafico
								.print("Se han intercambiado las fichas entre las posiciones (",X1,",",Y1,") y (",X2,",",Y2,")");
								//.wait(250); //Ajusta la velocidad del intercambio de fichas
								-+recursivityFlag(1);
								-+explosionFlag(1);
								-+dualExplosionFlag(0);
								-+posicionesIntercambiadas(X1,Y1,X2,Y2);
								!exchangedPatternMatch; //Deteccion y borrado de patrones en las dos posiciones intercambiadas								
								!fullPatternMatch; //Deteccion y borrado de todos los patrones, aplicacion del algoritmo de caida y rellenado
								//.wait(750);  //Ajusta la velocidad del intercambio de fichas
								!updatePlayersTableroBB. //Actualizacion de la base del conocimiento de los players tras los eventos sucedidos en tablero durante un turno

+!exchangedPatternMatch : posicionesIntercambiadas(X1,Y1,X2,Y2) <- 
							!patternMatchExchangedPosition(X1,Y1);
							!patternMatchExchangedPosition(X2,Y2).

+!patternMatchExchangedPosition(X,Y) : comprobarPatrones(C,X,Y,StartsAtX,StartsAtY,Direction,Pattern) & Pattern = "T" <-
										!handlePattern(C,StartsAtX,StartsAtY,Direction,"T");
										.wait(350); // Ajusta el tiempo tras cada explosion
										!setMovedSteak(X,Y,"T");
										!generateSpecialSteak("T",C);
										!gravity;
										!refill;
										-+recursivityFlag(1);//Reset de flags
										-+explosionFlag(1);
										-+dualExplosionFlag(0).
+!patternMatchExchangedPosition(X,Y).


//Deteccion de patrones en todo el tablero
+!fullPatternMatch : recursivityFlag(1) & size(N) <-
					-+recursivityFlag(0);
					for ( .range(I,0,(N-1)) ) {
									for ( .range(J,0,(N-1)) ) {
										!patternMatchPosition(I,J);
									}
								}
					-+explosionFlag(0);
					!gravity;
					!refill;
					!fullPatternMatch.
+!fullPatternMatch.



+!patternMatchPosition(I,J): tablero(celda(I,J,_),ficha(C,_)) & comprobarPatrones(C,I,J,StartsAtX,StartsAtY,Direction,Pattern) & not Pattern = "none" & posicionesIntercambiadas(X1,Y1,X2,Y2)<-
	!handlePattern(C,StartsAtX,StartsAtY,Direction,Pattern);
	.wait(350); // Ajusta el tiempo tras cada explosion
	!setMovedSteak(X1,Y1,Pattern);
	!setMovedSteak(X2,Y2,Pattern);
	!generateSpecialSteak(Pattern,C);
	-+recursivityFlag(1).

+!patternMatchPosition(I,J).


//Algoritmo de caida y rodar
+!gravity : emptyUnder(_,_) & size(N) <-
					for ( .range(X,0,(N-1)) ) {
									for ( .range(Y,0,(N-1)) ) {
										!fall(X,Y);
									}
								}
								!gravity;
								.wait(100). //Ajusta el tiempo tras la caida de todas las fichas
+!gravity.

+!fall(X,Y) : emptyUnder(X,Y)  <-
	!fallAndRoll(X,Y). //Solo rodaran las fichas que primeramente han caido

+!fallAndRoll(X,Y) : emptyUnder(X,Y) & tablero(celda(X,Y,Owner),ficha(Color,Tipo))<-
 	-tablero(celda(X,Y,Owner),ficha(Color,Tipo));
	-tablero(celda(X,Y+1,Owner),e);
    +tablero(celda(X,Y,Owner),e);
	+tablero(celda(X,Y+1,Owner),ficha(Color,Tipo));
	delete(Color,X,Y);
	put(Color,X,Y+1,Tipo);
	!fallAndRoll(X,Y+1).

+!fallAndRoll(X,Y) : emptyLeft(X,Y) & tablero(celda(X,Y,Owner),ficha(Color,Tipo))<- //Se ha elegido que las fichas rueden hacia la izquierda para funcionar correctamente con el orden de exploracion del tablero establecido.
 	-tablero(celda(X,Y,Owner),ficha(Color,Tipo));
	-tablero(celda(X-1,Y,Owner),e);
    +tablero(celda(X,Y,Owner),e);
	+tablero(celda(X-1,Y,Owner),ficha(Color,Tipo));
	delete(Color,X,Y);
	put(Color,X-1,Y,Tipo);
	!fallAndRoll(X-1,Y).



+!fallAndRoll(X,Y).
+!fall(X,Y).


//Algoritmo de rellenado de celdas vacias con fichas generadas de color aleatorio
+!refill : tablero(celda(_,0,_),e) & size(N) <- //Anhade una ficha en las posiciones (X,0) que esten libres y posteriormente aplica la caida
		for ( .range(X,0,(N-1)) ) {
			.random(Color,10);
	       	!refillSteak(X,math.round(5*Color));
			};
		!gravity;
		.wait(50); // Ajusta el tiempo tras la aplicacion del algoritmo de caida
		!refill.
+!refill.

+!refillSteak(X,Color) : tablero(celda(X,0,_),e)<-
					put(Color,X,0,in);
					-tablero(celda(X,0,_),e);
					+tablero(celda(X,0,0),ficha(Color,in)).
+!refillSteak(X,Color).





//Actualizacion de los BB tras todas las acciones ocurridas sobre el tablero despues de que el jugador realice movimiento
+!updatePlayersTableroBB <-
			.send(player1,tell,deleteTableroBB);
			.send(player2,tell,deleteTableroBB);
			.wait(500);
			.send(player1,untell,deleteTableroBB);
			.send(player2,untell,deleteTableroBB);
			!mostrarTablero(player1);
			!mostrarTablero(player2).

//Comunicacion del tablero al jugador indicado.
+!mostrarTablero(P) <- .findall(tablero(X,Y),tablero(X,Y),Lista);
		for ( .member(Estructure,Lista) ) {
			.send(P,tell,Estructure);
		 }.

//Gestion de explosion de patrones segun su tipo y colocacion en el tablero
+!handlePattern(Color,StartsAtX,StartsAtY,Direction,Pattern) : Pattern = "3inLineH" <-
		delete(Color,StartsAtX,StartsAtY);
		delete(Color,StartsAtX,StartsAtY+1);
		delete(Color,StartsAtX,StartsAtY+2);

		!explosion(StartsAtX,StartsAtY);
		!explosion(StartsAtX,StartsAtY+1);
		!explosion(StartsAtX,StartsAtY+2).

+!handlePattern(Color,StartsAtX,StartsAtY,Direction,Pattern) : Pattern = "3inLineW" <-
		delete(Color,StartsAtX,StartsAtY);
		delete(Color,StartsAtX+1,StartsAtY);
		delete(Color,StartsAtX+2,StartsAtY);

		!explosion(StartsAtX,StartsAtY);
		!explosion(StartsAtX+1,StartsAtY);
		!explosion(StartsAtX+2,StartsAtY).


+!handlePattern(Color,StartsAtX,StartsAtY,Direction,Pattern) : Pattern = "4inLineH" <-
		delete(Color,StartsAtX,StartsAtY);
		delete(Color,StartsAtX,StartsAtY+1);
		delete(Color,StartsAtX,StartsAtY+2);
		delete(Color,StartsAtX,StartsAtY+3);

		!explosion(StartsAtX,StartsAtY);
		!explosion(StartsAtX,StartsAtY+1);
		!explosion(StartsAtX,StartsAtY+2);
		!explosion(StartsAtX,StartsAtY+3).


+!handlePattern(Color,StartsAtX,StartsAtY,Direction,Pattern) : Pattern = "4inLineW" <-
		delete(Color,StartsAtX,StartsAtY);
		delete(Color,StartsAtX+1,StartsAtY);
		delete(Color,StartsAtX+2,StartsAtY);
		delete(Color,StartsAtX+3,StartsAtY);

		!explosion(StartsAtX,StartsAtY);
		!explosion(StartsAtX+1,StartsAtY);
		!explosion(StartsAtX+2,StartsAtY);
		!explosion(StartsAtX+3,StartsAtY).


+!handlePattern(Color,StartsAtX,StartsAtY,Direction,Pattern) : Pattern = "5inLineH"<-
		delete(Color,StartsAtX,StartsAtY);
		delete(Color,StartsAtX,StartsAtY+1);
		delete(Color,StartsAtX,StartsAtY+2);
		delete(Color,StartsAtX,StartsAtY+3);
		delete(Color,StartsAtX,StartsAtY+4);

		!explosion(StartsAtX,StartsAtY);
		!explosion(StartsAtX,StartsAtY+1);
		!explosion(StartsAtX,StartsAtY+2);
		!explosion(StartsAtX,StartsAtY+3);
		!explosion(StartsAtX,StartsAtY+4).


+!handlePattern(Color,StartsAtX,StartsAtY,Direction,Pattern) : Pattern = "5inLineW" <-
		delete(Color,StartsAtX,StartsAtY);
		delete(Color,StartsAtX+1,StartsAtY);
		delete(Color,StartsAtX+2,StartsAtY);
		delete(Color,StartsAtX+3,StartsAtY);
		delete(Color,StartsAtX+4,StartsAtY);


		!explosion(StartsAtX,StartsAtY);
		!explosion(StartsAtX+1,StartsAtY);
		!explosion(StartsAtX+2,StartsAtY);
		!explosion(StartsAtX+3,StartsAtY);
		!explosion(StartsAtX+4,StartsAtY).


+!handlePattern(Color,StartsAtX,StartsAtY,Direction,Pattern) : Pattern = "Square" <-
		delete(Color,StartsAtX,StartsAtY);
		delete(Color,StartsAtX+1,StartsAtY);
		delete(Color,StartsAtX,StartsAtY+1);
		delete(Color,StartsAtX+1,StartsAtY+1);

		!explosion(StartsAtX,StartsAtY);
		!explosion(StartsAtX+1,StartsAtY);
		!explosion(StartsAtX,StartsAtY+1);
		!explosion(StartsAtX+1,StartsAtY+1).


+!handlePattern(Color,StartsAtX,StartsAtY,Direction,Pattern) : Pattern = "T"<-
	!handleT(Color,StartsAtX,StartsAtY,Direction,Pattern).


+!handleT(Color,StartsAtX,StartsAtY,Direction,Pattern) : Direction = "standing" <-
	delete(Color,StartsAtX,StartsAtY);
	delete(Color,StartsAtX+1,StartsAtY);
	delete(Color,StartsAtX-1,StartsAtY);
	delete(Color,StartsAtX,StartsAtY+1);
	delete(Color,StartsAtX,StartsAtY+2);

	!explosion(StartsAtX,StartsAtY);
	!explosion(StartsAtX+1,StartsAtY);
	!explosion(StartsAtX-1,StartsAtY);
	!explosion(StartsAtX,StartsAtY+1);
	!explosion(StartsAtX,StartsAtY+2).

+!handleT(Color,StartsAtX,StartsAtY,Direction,Pattern) : Direction = "upside-down" <-
	delete(Color,StartsAtX,StartsAtY);
	delete(Color,StartsAtX+1,StartsAtY);
	delete(Color,StartsAtX-1,StartsAtY);
	delete(Color,StartsAtX,StartsAtY-1);
	delete(Color,StartsAtX,StartsAtY-2);

	!explosion(StartsAtX,StartsAtY);
	!explosion(StartsAtX+1,StartsAtY);
	!explosion(StartsAtX-1,StartsAtY);
	!explosion(StartsAtX,StartsAtY-1);
	!explosion(StartsAtX,StartsAtY-2).


+!handleT(Color,StartsAtX,StartsAtY,Direction,Pattern) : Direction = "pointing-right" <-

	delete(Color,StartsAtX,StartsAtY);
	delete(Color,StartsAtX,StartsAtY+1);
	delete(Color,StartsAtX,StartsAtY-1);
	delete(Color,StartsAtX+1,StartsAtY);
	delete(Color,StartsAtX+2,StartsAtY);

	!explosion(StartsAtX,StartsAtY);
	!explosion(StartsAtX,StartsAtY+1);
	!explosion(StartsAtX,StartsAtY-1);
	!explosion(StartsAtX+1,StartsAtY);
	!explosion(StartsAtX+2,StartsAtY).

+!handleT(Color,StartsAtX,StartsAtY,Direction,Pattern) : Direction = "pointing-left" <-

	delete(Color,StartsAtX,StartsAtY);
	delete(Color,StartsAtX,StartsAtY+1);
	delete(Color,StartsAtX,StartsAtY-1);
	delete(Color,StartsAtX-1,StartsAtY);
	delete(Color,StartsAtX-2,StartsAtY);

	!explosion(StartsAtX,StartsAtY);
	!explosion(StartsAtX,StartsAtY+1);
	!explosion(StartsAtX,StartsAtY-1);
	!explosion(StartsAtX-1,StartsAtY);
	!explosion(StartsAtX-2,StartsAtY).


//Establecer celda como movida para generar sobre ella la ficha especial cuando la explosion es directamente realizada por el movimiento del jugador
+!setMovedSteak(X,Y,Pattern) : explosionFlag(1) & tablero(celda(X,Y,_),e) & specialSteak(Pattern,Type)<-

			-tablero(celda(X,Y,_),_);
			+tablero(celda(X,Y,0),m);
			-+dualExplosionFlag(1). //Aunque se active el flag, solo se utilizara si explota otro patron contiguo
+!setMovedSteak(X,Y,Pattern).

//Generacion de la ficha especial acorde al patron que le corresponde tras una explosion
+!generateSpecialSteak(Pattern,Color) : explosionFlag(1) & tablero(celda(X,Y,_),m) & specialSteak(Pattern,Type)<- //La explosion se produjo directamente por el movimiento del jugador, y la ficha especial se debe de colocar en la ficha movida.
			put(Color,X,Y,Type);
			-tablero(celda(X,Y,_),m);
			+tablero(celda(X,Y,0),ficha(Color,Type));
			!specialStickGenerationPoints(Type);
			!dualExplosion.

+!dualExplosion : dualExplosionFlag(F) & F=1 & tablero(celda(NX,NY,_),m)<- //Gestion de la explosion de dos patrones contiguos para evitar problemas en la generacion de fichas especiales
			-tablero(celda(NX,NY,_),m);
			+tablero(celda(NX,NY,0),e);
			-+dualExplosionFlag(0).
+!dualExplosion.

//Generacion de ficha especial por explosion de un patron
+!generateSpecialSteak(Pattern,Color) : explosionFlag(0) & tablero(celda(X,Y,_),e) & specialSteak(Pattern,Type)<-  //La explosion se produjo de forma indirecta por la caida de fichas. La ficha especial se coloca de forma aleatoria por unificacion.
			put(Color,X,Y,Type);
			-tablero(celda(X,Y,_),e);
			+tablero(celda(X,Y,0),ficha(Color,Type));
			!specialStickGenerationPoints(Type).
+!generateSpecialSteak(Pattern,Color).

//Suma de los puntos correspondientes a la generacion de una ficha especial
+!specialStickGenerationPoints(T) : generationPoints(T,NP) & turnoActual(A) & level(L) & points(L,A,P) <-
				-points(L,A,P);
				+points(L,A,P+NP).



//Gestion de explosiones segun el tipo de ficha
+!explosion(X,Y) : tablero(celda(X,Y,_),ficha(C,T)) & direction(D) & turnoActual(A) & level(L) & points(L,A,P)<-
				-tablero(celda(X,Y,_),_);//Primero se elimina la ficha seleccionada, luego las otras fichas afectadas en caso de ser necesario
				+tablero(celda(X,Y,0),e);
				delete(C,X,Y);
				!specialExplosion(X,Y,C,T,D,A,P,L).

+!explosion(X,Y) : tablero(celda(X,Y,_),e).
+!explosion(X,Y) <- .print("ERROR. !explosion(",X,",",Y,")").

+!specialExplosion(X,Y,C,T,D,A,P,L) : T = in <-
	-points(L,A,P);
    +points(L,A,P+1).


+!specialExplosion(X,Y,C,T,D,A,P,L) : T = ip  & (D="up" | D="down")<-     //Explosion en linea vertical
			-points(L,A,P);
			+points(L,A,P+2);
			for( tablero(celda(X,NY,_),ficha(NC,_))){
					!explosion(X,NY);
					-tablero(celda(X,NY,_),_);
					+tablero(celda(X,NY,0),e);
					delete(NC,X,NY);
				}.

+!specialExplosion(X,Y,C,T,D,A,P,L) : T = ip  & (D="left" | D="right")<-     //Explosion en linea horizontal
			-points(L,A,P);
			+points(L,A,P+2);
			for( tablero(celda(NX,Y,_),ficha(NC,_))){
				 	!explosion(NX,Y);
					-tablero(celda(NX,Y,_),_);
					+tablero(celda(NX,Y,0),e);
					delete(NC,NX,Y);
				}.

+!specialExplosion(X,Y,C,T,D,A,P,L) : T = gs & tablero(celda(NX,NY,_),ficha(C,_)) & not X=NX & not Y=NY <-	 //Explosion de una ficha del mismo color (distinta a si misma)
			-points(L,A,P);
			+points(L,A,P+4);
			!explosion(NX,NY);
			-tablero(celda(NX,NY,_),ficha(C,_));
			+tablero(celda(NX,NY,0),e);
			delete(C,NX,NY).

+!specialExplosion(X,Y,C,T,D,A,P,L) : T = co <-  			//Explosion en cuadrado 3x3
			-points(L,A,P);
			+points(L,A,P+6);
			for ( .range(I,-1,1) ) {
				for ( .range(J,-1,1) ) {
					!coExplosion(X+I,Y+J);
				};
			}.

+!coExplosion(X,Y) : tablero(celda(X,Y,_),ficha(C,_)) <-
			  !explosion(X+I,Y+J);
			  -tablero(celda(X,Y,_),_);
			  +tablero(celda(X,Y,0),e);
			  delete(C,X,Y).
+!coExplosion(X,Y).

+!specialExplosion(X,Y,C,T,D,A,P,L) : T = ct <-     //Explosion de todas las fichas de ese color
			-points(L,A,P);
			+points(L,A,P+8);
			for( tablero(celda(NX,NY,_),ficha(C,_))){
				 	!explosion(NX,NY);
					-tablero(celda(NX,NY,_),_);
					+tablero(celda(NX,NY,0),e);
					delete(C,NX,NY);
			}.

+!specialExplosion(X,Y,C,T,D,A,P,L).
+!explosion(X,Y).

//Plan por defecto a ejecutar en caso desconocido.
+Default[source(A)]: not A=self  <- .print("He recibido el mensaje '",Default, "', pero no lo entiendo!");
									-Default[source(A)].
