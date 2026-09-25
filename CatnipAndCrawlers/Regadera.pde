class Regadera {
  float distanciaAlcance; // Distancia corta (casi pegada al gato)
  float tamanoArea; // Tamaño del área de agua (más grande)
  
  Regadera() {
    tamanoArea = min(width, height) * 0.07; // 7% del tamaño de pantalla
    distanciaAlcance = tamanoArea * 0.65;    // Pegada al gato
    // Acá más adelante podemos poner el cooldown
  }

  // Recibe dónde está el gato, hacia dónde mira y el jardín para poder regar
  void usar(float gatoX, float gatoY, int direccion, Jardin jardin) {
    float objetivoX = gatoX;
    float objetivoY = gatoY;
    
    // Desplazamos el punto de impacto según la dirección
    if (direccion == 0) objetivoY -= distanciaAlcance; // Arriba
    if (direccion == 1) objetivoY += distanciaAlcance; // Abajo
    if (direccion == 2) objetivoX -= distanciaAlcance; // Izquierda
    if (direccion == 3) objetivoX += distanciaAlcance; // Derecha
    
    // Le decimos al jardín que intente regar en ese nuevo punto calculado
    jardin.regarParcelaEn(objetivoX, objetivoY);
    
    // (Opcional visual) Dibujamos un cuadradito azul rápido para ver dónde cayó el agua
    fill(0, 150, 255, 150); // Azul semitransparente
    noStroke();
    rectMode(CENTER);
    rect(objetivoX, objetivoY, tamanoArea, tamanoArea);
    rectMode(CORNER);
  }
}
