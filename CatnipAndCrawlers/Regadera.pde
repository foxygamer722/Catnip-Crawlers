class Regadera {
  float distanciaAlcance;
  float tamanoArea;
  
  Regadera() {
    tamanoArea = min(width, height) * 0.07;
    distanciaAlcance = tamanoArea * 0.65;
  }

  void usar(float gatoX, float gatoY, int direccion, Jardin jardin) {
    float objetivoX = gatoX;
    float objetivoY = gatoY;

    if (direccion == 0) objetivoY -= distanciaAlcance;
    if (direccion == 1) objetivoY += distanciaAlcance;
    if (direccion == 2) objetivoX -= distanciaAlcance;
    if (direccion == 3) objetivoX += distanciaAlcance;

    jardin.regarParcelaEn(objetivoX, objetivoY);
    
    fill(0, 150, 255, 150);
    noStroke();
    rectMode(CENTER);
    rect(objetivoX, objetivoY, tamanoArea, tamanoArea);
    rectMode(CORNER);
  }
}
