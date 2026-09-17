class GestorOleadas {
  int numero;
  int cantEnemigos;
  int enemigosRestantes;
  int intervaloSpawn;
  ArrayList<PuntoSpawn> puntosSpawn;

  // Referencias/estado interno necesarios para operar
  Juego juego;
  int timerSpawn;
  int enemigosPorCrear;
  String[] tiposEnemigo = {"Hormiga", "Escarabajo", "Oruga", "Avispa", "Babosa"};

  GestorOleadas(Juego juego) {
    this.juego = juego;
    numero = 0;
    cantEnemigos = 0;
    enemigosRestantes = 0;
    intervaloSpawn = 90;
    puntosSpawn = new ArrayList<PuntoSpawn>();
    generarPuntosSpawn();
  }

  void generarPuntosSpawn() {
    puntosSpawn.clear();
    int total = 12; // 12 puntos posibles alrededor del jardin
    for (int i = 0; i < total; i++) {
      float ang = TWO_PI * i / total;
      float radioX = width / 2.0 - 30;
      float radioY = height / 2.0 - 30;
      float x = width / 2.0 + cos(ang) * radioX;
      float y = height / 2.0 + sin(ang) * radioY;
      puntosSpawn.add(new PuntoSpawn(constrain(x, 15, width - 15), constrain(y, 15, height - 15)));
    }
  }

  void iniciarOleada() {
    numero++;
    subirDificultad();
    enemigosRestantes = cantEnemigos;
    enemigosPorCrear = cantEnemigos;
    timerSpawn = 0;
  }

  void subirDificultad() {
    cantEnemigos = 4 + numero * 2;
    intervaloSpawn = max(18, 90 - numero * 4);
  }

  PuntoSpawn seleSpawn() {
    return puntosSpawn.get(int(random(puntosSpawn.size())));
  }

  Enemigo crearEnemigo() {
    PuntoSpawn punto = seleSpawn();
    int variedad = constrain(2 + numero / 2, 1, tiposEnemigo.length);
    String tipo = tiposEnemigo[int(random(variedad))];
    Enemigo e = new Enemigo(punto.posX, punto.posY, tipo);
    e.buscarObjetivo(juego.parcelas);
    return e;
  }

  void actualizar() {
    if (enemigosPorCrear > 0) {
      timerSpawn++;
      if (timerSpawn >= intervaloSpawn) {
        timerSpawn = 0;
        juego.enemigos.add(crearEnemigo());
        enemigosPorCrear--;
      }
    }
    enemigosRestantes = enemigosPorCrear + juego.enemigos.size();

    if (enemigosPorCrear <= 0 && juego.enemigos.size() == 0) {
      terminarOleada();
    }
  }

  void terminarOleada() {
    enemigosRestantes = 0;
    if (numero % 3 == 0) {
      juego.gestorEstaciones.cambiarEstacion();
    }
    juego.cambiarEstado(ESTADO_PREPARACION);
  }
}
