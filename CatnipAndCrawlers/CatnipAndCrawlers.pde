final int MENU = 0;
final int JUGANDO = 1;
final int GAME_OVER = 2;

int estadoActual = MENU;
Juego juego;

void setup() {
  size(1000, 800);
  juego = new Juego();
}

void draw() {
  switch (estadoActual) {
    case MENU:
      dibujarMenu();
      break;
    case JUGANDO:
      juego.actualizar();
      juego.dibujar();
      break;
    case GAME_OVER:
      dibujarGameOver();
      break;
  }
}

void keyPressed() {
  if (estadoActual == MENU && key == ENTER) {
    estadoActual = JUGANDO;
    juego.iniciarPartida();
  } else if (estadoActual == GAME_OVER && key == ENTER) {
    estadoActual = MENU;
  } else if (estadoActual == JUGANDO) {
    juego.jugador.manejarInput(key, keyCode, true);
  }
}

void keyReleased() {
  if (estadoActual == JUGANDO) {
    juego.jugador.manejarInput(key, keyCode, false);
  }
}

void mousePressed() {
  if (estadoActual == JUGANDO) {
    juego.manejarMousePresionado(mouseX, mouseY);
  }
}

void mouseReleased() {
  if (estadoActual == JUGANDO) {
    juego.manejarMouseSoltado(mouseX, mouseY);
  }
}

void dibujarMenu() {
  background(50, 150, 50);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(40);
  text("Catnip & Crawlers", width/2, height/2 - 50);
  textSize(20);
  text("Presiona ENTER para empezar", width/2, height/2 + 20);
}

void dibujarGameOver() {
  background(150, 50, 50);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(40);
  text("GAME OVER", width/2, height/2 - 50);
  textSize(20);
  text("Plantas destruidas: 3\nPresiona ENTER para volver al menú", width/2, height/2 + 20);
}
