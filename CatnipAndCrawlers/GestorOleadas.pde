class GestorOleadas {
  ArrayList<Enemigo> enemigos;
  int oleadaActual = 1;
  int enemigosPorSpawnear;
  int ultimoSpawn;
  int intervaloSpawn = 2500;

  GestorOleadas() {
    enemigos = new ArrayList<Enemigo>();
  }

  // Cantidad de enemigos y intervalo de aparicion.
  void iniciarOleada(int numOleada) {
    oleadaActual = numOleada;
    enemigosPorSpawnear = 3 + (oleadaActual * 2);
    intervaloSpawn = max(800, 2500 - (oleadaActual * 150));
    ultimoSpawn = millis();
  }

  int actualizar(Jardin jardin, Jugador jugador, Juego juego, float multVelEstacion) {
    int oroPorBajas = 0;

    if (enemigosPorSpawnear > 0 && millis() - ultimoSpawn >= intervaloSpawn) {
      int lado = int(random(4));
      float x = lado < 2 ? random(width) : (lado == 2 ? -20 : width + 20);
      float y = lado < 2 ? (lado == 0 ? -20 : height + 20) : random(height);

      int maxTipo = (oleadaActual >= 3) ? 3 : ((oleadaActual == 2) ? 2 : 1);
      int tipoElegido = int(random(maxTipo));

      enemigos.add(new Enemigo(x, y, oleadaActual, multVelEstacion, tipoElegido));
      enemigosPorSpawnear--;
      ultimoSpawn = millis();
    }

    for (int i = enemigos.size() - 1; i >= 0; i--) {
      Enemigo e = enemigos.get(i);
      e.actualizar(jardin, jugador, juego);
      if (e.estaMuerto()) {
        if (e.vida < 0 || e.objetivo != null) oroPorBajas += e.recompensaOro;
        enemigos.remove(i);
      }
    }
    return oroPorBajas;
  }

  // Aplica el daño a los enemigos
  void danarEnArea(float ax, float ay, float tamArea, int dano) {
    for (Enemigo e : enemigos) {
      if (dist(ax, ay, e.x, e.y) <= tamArea * 0.8) e.recibirDano(dano);
    }
  }

  // Verifica si no faltan mas enemigos
  boolean oleadaTerminada() {
    return enemigosPorSpawnear == 0 && enemigos.isEmpty();
  }
  
  void dibujar() {
    for (Enemigo e : enemigos) e.dibujar();
  }
}
