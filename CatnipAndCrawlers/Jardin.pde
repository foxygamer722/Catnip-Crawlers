class Jardin {
  Parcela[][] grilla;
  int columnas = 3;
  int filas = 3;
  float tamParcela, separacion, margenX, margenY;
 
  // GRILLA.
  Jardin() {
    grilla = new Parcela[columnas][filas];
    tamParcela = min(width * 0.11, height * 0.14);
    separacion = tamParcela * 0.12;
    float anchoTotal = (columnas * tamParcela) + ((columnas - 1) * separacion);
    float altoTotal = (filas * tamParcela) + ((filas - 1) * separacion);
    margenX = (width - anchoTotal) / 2.0;
    margenY = (height - altoTotal) / 2.0;

    for (int i = 0; i < columnas; i++) {
      for (int j = 0; j < filas; j++) {
        grilla[i][j] = new Parcela(margenX + i*(tamParcela + separacion), margenY + j*(tamParcela + separacion), tamParcela);
      }
    }
  }

  // Actualiza las plantas y registra las que se pierden.
  void actualizar(boolean enOleada, Juego juego) {
    for (int i = 0; i < columnas; i++) {
      for (int j = 0; j < filas; j++) {
        Planta p = grilla[i][j].miPlanta;
        if (p != null) {
          p.actualizar(enOleada);
          if (p.estaMuertaPorEnemigo() || p.muertaPorSed) {
            grilla[i][j].miPlanta = null;
            juego.registrarPerdidaVida();
          }
        }
      }
    }
  }

  int procesarFinDeOleada() {
    int dineroCosecha = 0;
    for (int i = 0; i < columnas; i++)
      for (int j = 0; j < filas; j++)
        if (grilla[i][j].miPlanta != null)
          dineroCosecha += grilla[i][j].miPlanta.finalizarOleada();
    return dineroCosecha;
  }

  int contarPlantas() {
    int c = 0;
    for (int i = 0; i < columnas; i++)
      for (int j = 0; j < filas; j++)
        if (grilla[i][j].miPlanta != null) c++;
    return c;
  }

  boolean intentarPlantar(float mx, float my, Semilla s) {
    for (int i = 0; i < columnas; i++)
      for (int j = 0; j < filas; j++)
        if (grilla[i][j].contienePunto(mx, my)) return grilla[i][j].plantar(s);
    return false;
  }

  void eliminarPlantaManual(float mx, float my) {
    if (contarPlantas() <= 1) return;
    for (int i = 0; i < columnas; i++)
      for (int j = 0; j < filas; j++)
        if (grilla[i][j].contienePunto(mx, my) && grilla[i][j].miPlanta != null) {
          grilla[i][j].miPlanta = null;
          return;
        }
  }

  void regarParcela(float px, float py) {
    for (int i = 0; i < columnas; i++)
      for (int j = 0; j < filas; j++)
        if (grilla[i][j].contienePunto(px, py) && grilla[i][j].miPlanta != null) {
          grilla[i][j].miPlanta.recibirAgua();
          return;
        }
  }

  void dibujar() {
    for (int i = 0; i < columnas; i++)
      for (int j = 0; j < filas; j++)
        grilla[i][j].dibujar();
  }
}
