class Regadera {
  float distanciaAlcance, tamArea;
  int cooldown = 600;
  int ultimoUso = -1000;
  int danoEnemigos = 20;

  Regadera() {
    tamArea = min(width, height) * 0.08;
    distanciaAlcance = tamArea * 0.65;
  }

  void usar(float gatoX, float gatoY, int direccion, Jardin jardin, GestorOleadas oleadas, boolean enOleada) {
    if (millis() - ultimoUso < cooldown) return;
    ultimoUso = millis();

    float objetivoX = gatoX;
    float objetivoY = gatoY;
    if (direccion == 0) objetivoY -= distanciaAlcance;
    if (direccion == 1) objetivoY += distanciaAlcance;
    if (direccion == 2) objetivoX -= distanciaAlcance;
    if (direccion == 3) objetivoX += distanciaAlcance;

    jardin.regarParcela(objetivoX, objetivoY);
    if (enOleada) {
      oleadas.danarEnArea(objetivoX, objetivoY, tamArea, danoEnemigos);
    }
  }

  void dibujarEfecto(float gatoX, float gatoY, int direccion) {
    if (millis() - ultimoUso < 150) {
      float objetivoX = gatoX + (direccion == 3 ? distanciaAlcance : (direccion == 2 ? -distanciaAlcance : 0));
      float objetivoY = gatoY + (direccion == 1 ? distanciaAlcance : (direccion == 0 ? -distanciaAlcance : 0));
      fill(0, 150, 255, 160); noStroke(); rectMode(CENTER);
      rect(objetivoX, objetivoY, tamArea, tamArea, 8);
      rectMode(CORNER);
    }
  }
}
