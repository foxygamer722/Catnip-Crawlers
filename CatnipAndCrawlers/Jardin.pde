class Jardin {
  Parcela[][] grilla;
  int columnas = 3;
  int filas = 2;
  float tamanoParcela;
  float separacion;
  float margenX, margenY;
 
  Jardin() {
    grilla = new Parcela[columnas][filas];
   
    tamanoParcela = min(width * 0.08, height * 0.1);
    separacion = tamanoParcela * 0.12;
    
    float anchoTotal = (columnas * tamanoParcela) + ((columnas - 1) * separacion);
    float altoTotal = (filas * tamanoParcela) + ((filas - 1) * separacion);
    
    margenX = (width - anchoTotal) / 2.0;
    margenY = (height - altoTotal) / 2.0;

    for (int i = 0; i < columnas; i++) {
      for (int j = 0; j < filas; j++) {
        float posX = margenX + (i * (tamanoParcela + separacion));
        float posY = margenY + (j * (tamanoParcela + separacion));
        grilla[i][j] = new Parcela(posX, posY, tamanoParcela);
      }
    }
  }

  void intentarPlantar(float mx, float my, String nombre, color colorPlanta) {
    for (int i = 0; i < columnas; i++) {
      for (int j = 0; j < filas; j++) {
        if (grilla[i][j].contienePunto(mx, my)) {
          grilla[i][j].plantar(nombre, colorPlanta);
          return;
        }
      }
    }
  }
  
  void regarParcelaEn(float px, float py) {
    for (int i = 0; i < columnas; i++) {
      for (int j = 0; j < filas; j++) {
        if (grilla[i][j].contienePunto(px, py)) {
          if (grilla[i][j].miPlanta != null) {
            grilla[i][j].miPlanta.recibirAgua();
          }
          return;
        }
      }
    }
  }
  
    void dibujar() {
    for (int i = 0; i < columnas; i++) {
      for (int j = 0; j < filas; j++) {
        grilla[i][j].dibujar();
      }
    }
  }
}
