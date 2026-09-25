class Jardin {
  Parcela[][] grilla;
  int columnas = 3;
  int filas = 2;
  float tamanoParcela;
  float separacion;
  float margenX, margenY;
 
  Jardin() {
    grilla = new Parcela[columnas][filas];
    
    // 1. Calculamos cuánto mide la grilla entera (parcelas + espacios)
    // Calculamos tamaño dinámico relativo
    
    tamanoParcela = min(width * 0.08, height * 0.1);
    separacion = tamanoParcela * 0.12;
    
    // Se resta 1 a las columnas/filas porque no hay espacio vacío después de la última
    float anchoTotal = (columnas * tamanoParcela) + ((columnas - 1) * separacion);
    float altoTotal = (filas * tamanoParcela) + ((filas - 1) * separacion);
    
    // 2. Centramos usando esas nuevas medidas totales
    margenX = (width - anchoTotal) / 2.0;
    margenY = (height - altoTotal) / 2.0;

    for (int i = 0; i < columnas; i++) {
      for (int j = 0; j < filas; j++) {
        // 3. Al calcular la posición X e Y, sumamos el tamaño Y la separación
        float posX = margenX + (i * (tamanoParcela + separacion));
        float posY = margenY + (j * (tamanoParcela + separacion));
        grilla[i][j] = new Parcela(posX, posY, tamanoParcela);
      }
    }
  }
  
  // NUEVO: Busca en qué parcela soltamos el mouse y planta ahí
  void intentarPlantar(float mx, float my, String nombre, color colorPlanta) {
    for (int i = 0; i < columnas; i++) {
      for (int j = 0; j < filas; j++) {
        if (grilla[i][j].contienePunto(mx, my)) {
          grilla[i][j].plantar(nombre, colorPlanta);
          return; // Cortamos la búsqueda porque ya encontramos la parcela
        }
      }
    }
  }
  
  void regarParcelaEn(float px, float py) {
    for (int i = 0; i < columnas; i++) {
      for (int j = 0; j < filas; j++) {
        if (grilla[i][j].contienePunto(px, py)) {
          // Si encontramos la parcela y tiene planta, la regamos
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
