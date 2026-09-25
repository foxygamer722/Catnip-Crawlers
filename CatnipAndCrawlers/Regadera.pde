class Regadera {
  float distanciaAlcance;
  float tamArea;
  
  Regadera() {
    tamArea = min(width, height) * 0.07;
    distanciaAlcance = tamArea * 0.65;
    // Hay agregar el cooldown
  }

  void usar(float gatoX, float gatoY, int direccion, Jardin jardin) {
    float objetivoX = gatoX;
    float objetivoY = gatoY;
    
    if (direccion == 0) objetivoY -= distanciaAlcance; // Arriba
    if (direccion == 1) objetivoY += distanciaAlcance; // Abajo
    if (direccion == 2) objetivoX -= distanciaAlcance; // Izquierda
    if (direccion == 3) objetivoX += distanciaAlcance; // Derecha
    
    jardin.regarParcela(objetivoX, objetivoY);
    
    fill(0, 150, 255, 150);
    noStroke();
    rectMode(CENTER);
    rect(objetivoX, objetivoY, tamArea, tamArea);
    rectMode(CORNER);
  }
}
