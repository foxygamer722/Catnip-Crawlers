class GestorOleadas {
  PuntoSpawn[] spawns;
  ArrayList<Enemigo> enemigos;
  int oleadaActual = 1;
  int enemigosPorSpawnear;
  int ultimoSpawn;
  int intervaloSpawn = 2500;

  GestorOleadas() {
    enemigos = new ArrayList<Enemigo>();
    spawns = new PuntoSpawn[12];
    for (int i = 0; i < 3; i++) {
      float posHoriz = width * (0.25 + i * 0.25);
      float posVert = height * (0.25 + i * 0.25);
      spawns[i] = new PuntoSpawn(posHoriz, -20);
      spawns[i + 3] = new PuntoSpawn(posHoriz, height + 20);
      spawns[i + 6] = new PuntoSpawn(-20, posVert);
      spawns[i + 9] = new PuntoSpawn(width + 20, posVert);
    }
  }

  void iniciarOleada(int numOleada) {
    oleadaActual = numOleada;
    enemigosPorSpawnear = 3 + (oleadaActual * 2);
    intervaloSpawn = max(800, 2500 - (oleadaActual * 150));
    ultimoSpawn = millis();
  }

  int actualizar(Jardin jardin, Jugador jugador, Juego juego, float multVelEstacion) {
    int oroPorBajas = 0;
    if (enemigosPorSpawnear > 0 && millis() - ultimoSpawn >= intervaloSpawn) {
      PuntoSpawn sp = spawns[int(random(spawns.length))];
      int maxTipo = (oleadaActual >= 3) ? 3 : ((oleadaActual == 2) ? 2 : 1);
      int tipoElegido = int(random(maxTipo));
      enemigos.add(new Enemigo(sp.x, sp.y, oleadaActual, multVelEstacion, tipoElegido));
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

  void danarEnArea(float ax, float ay, float tamArea, int dano) {
    for (Enemigo e : enemigos) {
      if (dist(ax, ay, e.x, e.y) <= tamArea * 0.8) e.recibirDano(dano);
    }
  }

  boolean oleadaTerminada() { return enemigosPorSpawnear == 0 && enemigos.isEmpty(); }
  void dibujar() { for (Enemigo e : enemigos) e.dibujar(); }
}
