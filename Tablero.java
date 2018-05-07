import jason.asSyntax.*;
import jason.environment.Environment;
import jason.environment.grid.GridWorldModel;
import jason.environment.grid.GridWorldView;
import jason.environment.grid.Location;

import java.util.*;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.util.Random;
import java.util.logging.Logger;



 /* * * * * * * * * * * * * * * * *** AVISO! *** * * * * * * * * * * * * * * * * * * */

 /* Para una correcta visualizacion del entorno grafico,
  es necesario ampliar la ventana del entorno hasta un tamanho aproximado de 15x15 */

 /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **/


public class Tablero extends Environment {

  public static final int GSize = 10; //Tamanho de celda

  //Codigos de colores
  public static final int BLUESTEAK  = 16;
  public static final int REDSTEAK  = 32;
  public static final int GREENSTEAK  = 64;
  public static final int YELLOWSTEAK  = 128;
  public static final int ORANGESTEAK  = 256;
  public static final int MAGENTASTEAK  = 512;
  public static final int OBSTACLE  = 1024;


  private Logger logger = Logger.getLogger("Tablero.mas2j."+Tablero.class.getName());

  private TableroModel model;
  private TableroView  view;

  String [][] steakType = new String[GSize][GSize];

  @Override
  public void init(String[] args) {
    addPercept("judge",Literal.parseLiteral("size(" + GSize + ")"));
    model = new TableroModel();
    view  = new TableroView(model);
    model.setView(view);
    super.init(args);
  }

  @Override
  public void stop() {
    super.stop();
  }

  @Override
  public boolean executeAction(String agent, Structure message) {
    //logger.info(agent + " doing: " + message); //Descomentar para mostrar por terminal las acciones ejecutadas
    try {
      if (agent.equals("judge")) { //Recepcion de un mensaje procedente del juez
        String action= message.getFunctor();
        switch(action){
          case("exchange"): //Intercambio de fichas
          int c1 = (int)((NumberTerm)message.getTerm(0)).solve();
          int x1 = (int)((NumberTerm)message.getTerm(1)).solve();
          int y1 = (int)((NumberTerm)message.getTerm(2)).solve();
          int c2 = (int)((NumberTerm)message.getTerm(3)).solve();
          int x2 = (int)((NumberTerm)message.getTerm(4)).solve();
          int y2 = (int)((NumberTerm)message.getTerm(5)).solve();
          model.exchange(c1,x1,y1,c2,x2,y2);
          //view.repaint(); //Descomentar en caso de problemas de visualizacion
          break;
          case("delete"): //Borrado de ficha
          int c = (int)((NumberTerm)message.getTerm(0)).solve();
          int x = (int)((NumberTerm)message.getTerm(1)).solve();
          int y = (int)((NumberTerm)message.getTerm(2)).solve();
          model.delete(c,x,y);
          //view.repaint();
          break;
          case("put"): //Establecer nueva ficha
          c = (int)((NumberTerm)message.getTerm(0)).solve();
          x = (int)((NumberTerm)message.getTerm(1)).solve();
          y = (int)((NumberTerm)message.getTerm(2)).solve();
          String t = message.getTerm(3).toString();
          model.put(c,x,y,t);
          //view.repaint();
          break;
          case("resetTablero"): //Restablecer tablero con la distribucion inicial
          model.reset();
          //view.repaint()
          break;
          case("putObstacle"): //Establecer nuevo obstaculo
          x = (int)((NumberTerm)message.getTerm(0)).solve();
          y = (int)((NumberTerm)message.getTerm(1)).solve();
          model.putObstacle(x,y);
          break;
        }
      } else { //Recepcion de un mensaje de otro agente que no sea el juez
        logger.info("Se ha recibido una peticion ilegal. "+ agent +" no puede realizar la accion: "+ message);
        Literal ilegal = Literal.parseLiteral("accionIlegal(" + agent + ")");
        addPercept("judge",ilegal);}
      } catch (Exception e) {
        e.printStackTrace();
      }
      return true;
    }



    class TableroModel extends GridWorldModel {

      Random random = new Random(System.currentTimeMillis());

      private TableroModel() {
        super(GSize, GSize, 3);
        reset();//Generacion del tablero
        addPercept("judge",Literal.parseLiteral("startGame")); //Envio de aviso al juez para que comienze el juego
      }

      void reset(){ //Generacion del tablero de juego con una distribucion especifica. (Se ha utilizado la distribucion en diagonal puesta como ejemplo por el profesor)
        removePerceptsByUnif("judge",Literal.parseLiteral("addTablero(X,Y)"));
        int color = 16;
        for(int i = 0; i < GSize; i++){
          for(int j = 0; j < GSize; j++){
            steakType[i][j]="in";
            set(color,i,j);
            int judgeColor = getJudgeColor(color);
            addPercept("judge",Literal.parseLiteral("addTablero(celda(" + i + "," + j + ",0),ficha(" + judgeColor + ",in))")); //Envio de la informacion correspondiente a la generacion de una posicion del tablero
            if (color < 512) {color = color * 2;}
            else {color = 16;};
          };
          if (color < 512) {color = color * 2;}
          else {color = 16;};
        };
      }

      void exchange(int c1, int x1, int y1, int c2, int x2, int y2) throws Exception { //Intercambio de fichas
        String aux = steakType[x1][y1];
        steakType[x1][y1] = steakType[x2][y2];
        steakType[x2][y2] = aux;
        int codColor1 = getEnvironmentColor(c1);
        int codColor2 = getEnvironmentColor(c2);
        set(codColor2,x1,y1);
        set(codColor1,x2,y2);
      }

      void delete(int color,int x, int y) throws Exception { //Borrado de ficha
        steakType[x][y]="";
        int codColor = getEnvironmentColor(color);
        remove(codColor,x,y);
      }

      void put(int c, int x, int y,String t) throws Exception { //Establecer ficha
        steakType[x][y]=t;
				set(getEnvironmentColor(c),x,y);
      }

      void putObstacle(int x, int y){ //establecer obstaculo
        steakType[x][y]="obstacle";
        set(OBSTACLE,x,y);
      }

      //Interface de colores entre el juez y el entorno
      public int getJudgeColor(int color){
        switch(color){
          case 16: return 0;
          case 32: return 1;
          case 64: return 2;
          case 128: return 3;
          case 256: return 4;
          case 512: return 5;
        }
        return 0;
      }

      public int getEnvironmentColor(int color){
        switch(color){
          case 0: return 16;
          case 1: return 32;
          case 2: return 64;
          case 3: return 128;
          case 4: return 256;
          case 5: return 512;
        }
        return 0;
      }
  } //End of Class [Tablero Model]



    class TableroView extends GridWorldView {

      public TableroView(TableroModel model) {
        super(model, "Tablero", 400);
        defaultFont = new Font("Arial", Font.BOLD, 12); //Modificar parámetros para una mejor visualizacion
        setVisible(true);
        repaint();
      }

      //Métodos de generacion visual de fichas y obstaculos
      @Override
      public void draw(Graphics g, int x, int y, int object) {
        if(steakType[x][y].equals("in")){
          drawSteak(g, x, y, object);
        }
        else{
          drawSpecialSteak(g, x, y,object);
        }
      }

      public void drawSteak(Graphics g, int x, int y, int object) {
        switch (object) {
          case Tablero.BLUESTEAK: //Circulo
          g.setColor(Color.blue);
          g.fillOval(x * cellSizeW + 10, y * cellSizeH + 10, cellSizeW - 20, cellSizeH - 20);
          break;
          case Tablero.REDSTEAK: //Cuadrado
          g.setColor(Color.red);
          g.fillRect(x*cellSizeW+10,y*cellSizeH+10,cellSizeW-20,cellSizeH-20);
          break;
          case Tablero.GREENSTEAK: //Triangulo
          g.setColor(Color.green);
          int[] triangleXPoints={x*cellSizeW+cellSizeW/2,x*cellSizeW+5,x*cellSizeW+cellSizeW-5};
          int[] triangleYPoints={y*cellSizeH+5,y*cellSizeH+cellSizeH-5,y*cellSizeH+cellSizeH-5};
          g.fillPolygon(triangleXPoints,triangleYPoints,3);
          break;
          case Tablero.ORANGESTEAK: //Rectangulo
          g.setColor(Color.orange);
          int[] rectangleXPoints={x*cellSizeW+cellSizeW/4,x*cellSizeW+3*cellSizeW/4,x*cellSizeW+3*cellSizeW/4,x*cellSizeW+cellSizeW/4};
          int[] rectangleYPoints={y*cellSizeH+5,y*cellSizeH+5,y*cellSizeH+cellSizeH-5,y*cellSizeH+cellSizeH-5};
          g.fillPolygon(rectangleXPoints,rectangleYPoints,4);
          break;
          case Tablero.YELLOWSTEAK: //Hexagono
          g.setColor(Color.yellow);
          int[] hexagonXPoints={x*cellSizeW+cellSizeW/4,x*cellSizeW+3*cellSizeW/4,x*cellSizeW+cellSizeW-10,x*cellSizeW+3*cellSizeW/4,x*cellSizeW+cellSizeW/4,x*cellSizeW+10};
          int[] hexagonYPoints={y*cellSizeH+10,y*cellSizeH+10,y*cellSizeH+cellSizeH/2,y*cellSizeH+cellSizeH-10,y*cellSizeH+cellSizeH-10,y*cellSizeH+cellSizeH/2};
          g.fillPolygon(hexagonXPoints,hexagonYPoints,6);
          break;
          case Tablero.MAGENTASTEAK: //Rombo
          g.setColor(Color.magenta);
          int[] diamondXPoints={x*cellSizeW+cellSizeW/2,x*cellSizeW+3*cellSizeW/4,x*cellSizeW+cellSizeW/2,x*cellSizeW+cellSizeW/4};
          int[] diamondYPoints={y*cellSizeH+5,y*cellSizeH+cellSizeH/2,y*cellSizeH+cellSizeH-5,y*cellSizeH+cellSizeH/2};
          g.fillPolygon(diamondXPoints,diamondYPoints,4);
          break;
          case Tablero.OBSTACLE: break;
        }
      }

      public void drawSpecialSteak(Graphics g, int x, int y, int object) {
        drawSteak(g, x, y, object);
        g.setColor(Color.lightGray);
        switch (object) {
          case Tablero.BLUESTEAK: //Circulo
          g.fillOval(x * cellSizeW + 20, y * cellSizeH + 20, cellSizeW - 40, cellSizeH - 40);
          break;
          case Tablero.REDSTEAK: //Cuadrado
          g.fillRect(x*cellSizeW+20,y*cellSizeH+20,cellSizeW-40,cellSizeH-40);
          break;
          case Tablero.GREENSTEAK: //Triangulo
          int[] triangleXPoints={x*cellSizeW+cellSizeW/2,x*cellSizeW+25,x*cellSizeW+cellSizeW-25};
          int[] triangleYPoints={y*cellSizeH+25,y*cellSizeH+cellSizeH-20,y*cellSizeH+cellSizeH-20};
          g.fillPolygon(triangleXPoints,triangleYPoints,3);
          break;
          case Tablero.ORANGESTEAK: //Rectangulo
          int[] rectangleXPoints={x*cellSizeW+cellSizeW/4+10,x*cellSizeW+3*cellSizeW/4-10,x*cellSizeW+3*cellSizeW/4-10,x*cellSizeW+cellSizeW/4+10};
          int[] rectangleYPoints={y*cellSizeH+20,y*cellSizeH+20,y*cellSizeH+cellSizeH-20,y*cellSizeH+cellSizeH-20};
          g.fillPolygon(rectangleXPoints,rectangleYPoints,4);
          break;
          case Tablero.YELLOWSTEAK: //Hexagono
          int[] hexagonXPoints={x*cellSizeW+cellSizeW/4+10,x*cellSizeW+3*cellSizeW/4-10,x*cellSizeW+cellSizeW-25,x*cellSizeW+3*cellSizeW/4-10,x*cellSizeW+cellSizeW/4+10,x*cellSizeW+25};
          int[] hexagonYPoints={y*cellSizeH+25,y*cellSizeH+25,y*cellSizeH+cellSizeH/2,y*cellSizeH+cellSizeH-25,y*cellSizeH+cellSizeH-25,y*cellSizeH+cellSizeH/2};
          g.fillPolygon(hexagonXPoints,hexagonYPoints,6);
          break;
          case Tablero.MAGENTASTEAK: //Rombo
          int[] diamondXPoints={x*cellSizeW+cellSizeW/2,x*cellSizeW+3*cellSizeW/4-10,x*cellSizeW+cellSizeW/2,x*cellSizeW+cellSizeW/4+10};
          int[] diamondYPoints={y*cellSizeH+20,y*cellSizeH+cellSizeH/2,y*cellSizeH+cellSizeH-20,y*cellSizeH+cellSizeH/2};
          g.fillPolygon(diamondXPoints,diamondYPoints,4);
          break;
          case Tablero.OBSTACLE: drawObstacle(g,x,y); break;
        }
        g.setColor(Color.black);
        drawString(g,x,y,defaultFont,steakType[x][y].toUpperCase());
      }

      public void drawObstacle(Graphics g, int x, int y){
        g.setColor(Color.darkGray);
        g.fillRoundRect(x*cellSizeW,y*cellSizeH,cellSizeW,cellSizeH,15,15);
        g.setColor(Color.black);
        //drawString(g,x,y,new Font("Arial", Font.BOLD, 50),"*"); //Descomentar si se desea relleno de los obstaculos para una mejor visualizacion
      }
    } //End of Class [Tablero View]

  } // End of Class [Tablero Environment]

