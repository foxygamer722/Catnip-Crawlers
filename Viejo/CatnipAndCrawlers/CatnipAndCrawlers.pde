final int MENU = 0;
final int JUGANDO = 1;
final int GAME_OVER = 2;

int estadoActual = MENU;
Juego juego;
Table tablaPuntuaciones;
String nombreJugador = "";
boolean puntajeGuardado = false;
PImage fondoMenu;

void setup() {
  size(1000, 700);
  cargarBaseDatos();
  fondoMenu = loadImage("fondo_menu.png");
  juego = new Juego();
}

void draw() {
  if (estadoActual == MENU) dibujarMenu();
  else if (estadoActual == JUGANDO) { juego.actualizar(); juego.dibujar(); }
  else if (estadoActual == GAME_OVER) dibujarGameOver();
}

void cargarBaseDatos() {
  File f = new File(dataPath("puntuaciones.csv"));
  if (f.exists()) {
    tablaPuntuaciones = loadTable("puntuaciones.csv", "header");
  } else {
    tablaPuntuaciones = new Table();
    tablaPuntuaciones.addColumn("nombre", Table.STRING);
    tablaPuntuaciones.addColumn("oleada", Table.INT);
    tablaPuntuaciones.addColumn("dinero", Table.INT);
    tablaPuntuaciones.addColumn("puntaje", Table.INT);
    saveTable(tablaPuntuaciones, "data/puntuaciones.csv");
  }
}

void guardarPuntuacion(String nombre, int oleada, int dineroTotal) {
  TableRow fila = tablaPuntuaciones.addRow();
  fila.setString("nombre", nombre.trim().equals("") ? "Gato Anónimo" : nombre);
  fila.setInt("oleada", oleada);
  fila.setInt("dinero", dineroTotal);
  fila.setInt("puntaje", (oleada * 100) + dineroTotal);
  tablaPuntuaciones.sortReverse("puntaje");
  saveTable(tablaPuntuaciones, "data/puntuaciones.csv");
}

void keyPressed() {
  if (estadoActual == MENU && (key == ENTER || key == RETURN)) {
    iniciarNuevaPartida();
  } else if (estadoActual == GAME_OVER) {
    if (!puntajeGuardado) {
      if (key == BACKSPACE && nombreJugador.length() > 0) {
        nombreJugador = nombreJugador.substring(0, nombreJugador.length() - 1);
      } else if (key == ENTER || key == RETURN) {
        guardarPuntuacion(nombreJugador, juego.oleada, juego.dineroTotalGenerado);
        puntajeGuardado = true;
      } else if (key >= 32 && key <= 126 && nombreJugador.length() < 15) {
        nombreJugador += key;
      }
    } else if (key == ENTER || key == RETURN) {
      estadoActual = MENU;
    }
  } else if (estadoActual == JUGANDO) {
    juego.jugador.controlarInput(key, keyCode, true);
  }
}

void keyReleased() {
  if (estadoActual == JUGANDO) juego.jugador.controlarInput(key, keyCode, false);
}

void mousePressed() {
  if (estadoActual == MENU) {
    float btnW = width * 0.24, btnH = height * 0.08;
    float btnX = width/2.0 - btnW/2.0, btnY = height * 0.83;
    if (mouseX >= btnX && mouseX <= btnX + btnW && mouseY >= btnY && mouseY <= btnY + btnH) {
      iniciarNuevaPartida();
    }
  } else if (estadoActual == JUGANDO) {
    juego.mousePresionado(mouseX, mouseY, mouseButton);
  }
}

void mouseReleased() {
  if (estadoActual == JUGANDO) juego.mouseSoltado(mouseX, mouseY);
}

void iniciarNuevaPartida() {
  estadoActual = JUGANDO;
  nombreJugador = "";
  puntajeGuardado = false;
  juego.iniciarPartida();
}

void dibujarMenu() {
  // 1. Fondo (imagen si existe, o degradado verde bosque con césped decorativo)
  if (fondoMenu != null) {
    image(fondoMenu, 0, 0, width, height);
  } else {
    for (int y = 0; y < height; y++) {
      stroke(lerpColor(color(34, 85, 52), color(68, 138, 78), float(y) / height));
      line(0, y, width, y);
    }
    noStroke();
    fill(45, 110, 60, 120);
    rect(0, height * 0.78, width, height * 0.22);
  }

  // 2. Cartel principal del Título (estilo madera)
  float titleW = width * 0.64, titleH = height * 0.16;
  float titleX = (width - titleW) / 2.0, titleY = height * 0.05;
  fill(92, 58, 33); stroke(54, 32, 16); strokeWeight(max(2, height * 0.005));
  rect(titleX, titleY, titleW, titleH, 18);

  textAlign(CENTER, CENTER);
  textSize(height * 0.058);
  fill(40, 20, 10);
  text("CATNIP & CRAWLERS", width/2.0 + 3, titleY + titleH * 0.44 + 3); // Sombra
  fill(255, 225, 110);
  text("CATNIP & CRAWLERS", width/2.0, titleY + titleH * 0.44);

  textSize(height * 0.02);
  fill(230, 240, 210);
  text("Defendé el jardín, cosechá oro y sobreviví a las estaciones", width/2.0, titleY + titleH * 0.8);

  float panelW = width * 0.42, panelH = height * 0.52;
  float panelY = height * 0.26;
  float panelIzqX = width * 0.06;
  float panelDerX = width * 0.52;

  fill(30, 48, 36, 225); stroke(145, 195, 120); strokeWeight(2);
  rect(panelIzqX, panelY, panelW, panelH, 14);

  fill(255, 225, 110); textSize(height * 0.026); textAlign(CENTER, TOP);
  text("CONTROLES Y CÓMO JUGAR", panelIzqX + panelW/2.0, panelY + height * 0.025);

  textAlign(LEFT, TOP); textSize(height * 0.019);
  float tx = panelIzqX + panelW * 0.07;
  float ty = panelY + height * 0.085;
  float salto = height * 0.068;

  dibujarFilaControl(tx, ty, "WASD / Flechas", "Mover al gato por el jardín");
  dibujarFilaControl(tx, ty + salto, "Arrastrar", "Plantar semillas desde la barra inferior");
  dibujarFilaControl(tx, ty + salto*2, "Click Izquierdo", "Regar semillas/plantas y atacar insectos");
  dibujarFilaControl(tx, ty + salto*3, "Click Derecho", "Quitar una planta (mínimo queda 1)");
  dibujarFilaControl(tx, ty + salto*4, "Signo [!] Rojo", "Regá la planta antes que se seque");
  dibujarFilaControl(tx, ty + salto*5, "Fin de Oleada", "Las plantas crecen y dan oro");

  fill(30, 48, 36, 225); stroke(145, 195, 120); strokeWeight(2);
  rect(panelDerX, panelY, panelW, panelH, 14);

  fill(255, 225, 110); textSize(height * 0.026); textAlign(CENTER, TOP);
  text("MEJORES JUGADORES (TOP 6)", panelDerX + panelW/2.0, panelY + height * 0.025);

  int limite = min(6, tablaPuntuaciones.getRowCount());
  if (limite == 0) {
    fill(200); textSize(height * 0.02); textAlign(CENTER, CENTER);
    text("Todavía no hay récords.\nJugá una partida para estar en la tabla", panelDerX + panelW/2.0, panelY + panelH/2.0);
  } else {
    textAlign(LEFT, CENTER); textSize(height * 0.019);
    for (int i = 0; i < limite; i++) {
      TableRow r = tablaPuntuaciones.getRow(i);
      float ry = panelY + height * (0.105 + i * 0.065);
      fill(i == 0 ? color(255, 215, 0) : color(235));
      text("#" + (i+1) + "  " + r.getString("nombre"), panelDerX + panelW*0.07, ry);
      textAlign(RIGHT, CENTER);
      text("Oleada." + r.getInt("oleada") + " | $" + r.getInt("dinero") + " | " + r.getInt("puntaje") + " pts", panelDerX + panelW*0.93, ry);
      textAlign(LEFT, CENTER);
    }
  }

  float btnW = width * 0.24, btnH = height * 0.08;
  float btnX = width/2.0 - btnW/2.0, btnY = height * 0.83;
  boolean hover = (mouseX >= btnX && mouseX <= btnX + btnW && mouseY >= btnY && mouseY <= btnY + btnH);

  fill(hover ? color(255, 200, 50) : color(235, 165, 30));
  stroke(255); strokeWeight(3);
  rect(btnX, btnY, btnW, btnH, 14);

  fill(40, 25, 10); textAlign(CENTER, CENTER); textSize(height * 0.03);
  text("JUGAR (ENTER)", width/2.0, btnY + btnH/2.0);
}

void dibujarFilaControl(float x, float y, String tecla, String desc) {
  fill(120, 230, 140);
  text("• " + tecla + ":", x, y);
  fill(240);
  text(desc, x + width * 0.145, y);
}

void dibujarGameOver() {
  background(110, 35, 35);
  fill(255); textAlign(CENTER, CENTER);
  textSize(height * 0.06); text("GAME OVER", width/2.0, height*0.25);
  textSize(height * 0.03);
  text("Oleada alcanzada: " + juego.oleada + " | Oro generado: $" + juego.dineroTotalGenerado +
       "\nPuntaje final: " + ((juego.oleada * 100) + juego.dineroTotalGenerado), width/2.0, height*0.38);

  if (!puntajeGuardado) {
    text("Escribí tu nombre y presioná ENTER para guardar:", width/2.0, height*0.52);
    fill(255, 255, 150);
    text("[ " + nombreJugador + "_ ]", width/2.0, height*0.58);
  } else {
    fill(150, 255, 150);
    text("Guardado", width/2.0, height*0.52);
    fill(255);
    text("Presioná ENTER para volver al menú", width/2.0, height*0.6);
  }
}
