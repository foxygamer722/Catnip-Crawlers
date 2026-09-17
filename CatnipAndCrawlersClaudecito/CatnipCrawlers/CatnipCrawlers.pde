// ============================================================
// CATNIP & CRAWLERS
// Juego 2D de estrategia y gestion de jardin (Processing/Java)
// ============================================================

Juego juego;

void setup() {
  size(960, 640);
  juego = new Juego();
  juego.iniciarJuego();
}

void draw() {
  juego.actualizar();
  juego.mostrar();
}

void keyPressed() {
  juego.manejarEntrada();
  // Evita que Processing cierre el sketch al presionar ESC
  if (key == ESC) {
    key = 0;
  }
}

void mousePressed() {
  juego.manejarEntrada();
}
