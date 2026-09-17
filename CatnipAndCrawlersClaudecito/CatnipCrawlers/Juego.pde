class Juego {
  int estadoActual;
  Jugador jugador;
  ArrayList<Parcela> parcelas;
  ArrayList<Enemigo> enemigos;
  Tienda tienda;
  Inventario inventario;
  // "gestores" del enunciado: instancias de GestorOleadas y GestorEstaciones
  GestorOleadas gestorOleadas;
  GestorEstaciones gestorEstaciones;
  Jardin terreno;
  float dinero;
  int plantasDestruidas;

  // Auxiliar: temporizador de la fase de preparacion (en frames)
  int timerPreparacion;
  final int TIEMPO_PREP = 60 * 18; // ~18 segundos

  void iniciarJuego() {
    estadoActual = ESTADO_MENU;

    jugador = new Jugador(width / 2.0, height / 2.0);
    inventario = jugador.inventario;

    parcelas = new ArrayList<Parcela>();
    crearParcelas();

    enemigos = new ArrayList<Enemigo>();
    tienda = new Tienda();

    gestorEstaciones = new GestorEstaciones();
    gestorOleadas = new GestorOleadas(this);
    terreno = new Jardin(gestorEstaciones);

    dinero = 100;
    plantasDestruidas = 0;
    timerPreparacion = TIEMPO_PREP;

    // Semillas iniciales para poder empezar a jugar
    inventario.agregarSemilla(new Semilla("Girasol", "Girasol", COMUN, 10, 40, 3, 180));
    inventario.agregarSemilla(new Semilla("Tomate", "Tomate", COMUN, 15, 50, 4, 220));
  }

  void crearParcelas() {
    int cols = 6, rows = 4;
    float tam = 68;
    float startX = width / 2.0 - (cols * tam) / 2.0;
    float startY = height / 2.0 - (rows * tam) / 2.0 + 15;
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        parcelas.add(new Parcela(startX + c * tam, startY + r * tam, tam - 4));
      }
    }
  }

  void actualizar() {
    if (estadoActual == ESTADO_MENU || estadoActual == ESTADO_GAMEOVER) return;

    terreno.actualizarEstacion();
    jugador.mover();

    for (Parcela p : parcelas) {
      if (p.planta != null) {
        p.planta.actualizar();
        float generado = p.planta.generarDinero();
        if (generado > 0) dinero += generado;
        if (p.planta.muerta) {
          plantasDestruidas++;
        }
      }
    }

    if (estadoActual == ESTADO_PREPARACION) {
      timerPreparacion--;
      if (timerPreparacion <= 0) {
        tienda.cerrar();
        gestorOleadas.iniciarOleada();
        cambiarEstado(ESTADO_OLEADA);
      }
    } else if (estadoActual == ESTADO_OLEADA) {
      gestorOleadas.actualizar();

      ArrayList<Enemigo> muertos = new ArrayList<Enemigo>();
      for (Enemigo e : enemigos) {
        if (e.objetivo == null || e.objetivo.estaLibre()) {
          e.buscarObjetivo(parcelas);
        }
        e.mover();
        e.atacar();
        if (e.muerto) muertos.add(e);
      }
      enemigos.removeAll(muertos);

      // Si terminarOleada() ya cambio el estado, preparamos el proximo temporizador
      if (estadoActual == ESTADO_PREPARACION) {
        timerPreparacion = TIEMPO_PREP;
      }
    }

    comprobarGameOver();
  }

  void mostrar() {
    if (estadoActual == ESTADO_MENU) {
      mostrarMenu();
      return;
    }

    terreno.mostrar();
    for (Parcela p : parcelas) p.mostrar();
    for (Enemigo e : enemigos) e.mostrar();
    jugador.mostrar();

    mostrarHUD();
    tienda.mostrar(width - 430, 20);
    inventario.mostrar(15, height - 95);

    if (estadoActual == ESTADO_GAMEOVER) {
      mostrarGameOver();
    }
  }

  void mostrarMenu() {
    background(120, 190, 90);
    fill(255);
    textAlign(CENTER);
    textSize(36);
    text("Catnip & Crawlers", width / 2.0, height / 2.0 - 40);
    textSize(16);
    text("Presiona ESPACIO para comenzar", width / 2.0, height / 2.0 + 10);
    textSize(12);
    text("WASD/Flechas: moverse | ESPACIO: regar/atacar | Q: plantar | T: tienda | 1-9: elegir semilla",
         width / 2.0, height / 2.0 + 40);
    textAlign(LEFT);
  }

  void mostrarHUD() {
    noStroke();
    fill(255, 255, 255, 220);
    rect(10, 10, 230, 68, 8);
    fill(0);
    textAlign(LEFT);
    textSize(13);
    text("Dinero: $" + int(dinero), 20, 28);

    String est = estadoActual == ESTADO_PREPARACION ? "Preparacion" :
                 (estadoActual == ESTADO_OLEADA ? "Oleada " + gestorOleadas.numero : "");
    text("Estado: " + est, 20, 46);

    if (estadoActual == ESTADO_PREPARACION) {
      text("Siguiente oleada en: " + (timerPreparacion / 60) + "s", 20, 64);
    } else if (estadoActual == ESTADO_OLEADA) {
      text("Enemigos restantes: " + gestorOleadas.enemigosRestantes, 20, 64);
    }

    String[] nombresEstacion = {"Primavera", "Verano", "Otono", "Invierno"};
    textAlign(RIGHT);
    text("Estacion: " + nombresEstacion[gestorEstaciones.estacionActual], width - 20, 28);
    text("Plantas perdidas: " + plantasDestruidas + "/15", width - 20, 46);
    textAlign(LEFT);
  }

  void mostrarGameOver() {
    noStroke();
    fill(0, 0, 0, 180);
    rect(0, 0, width, height);
    fill(255);
    textAlign(CENTER);
    textSize(32);
    text("GAME OVER", width / 2.0, height / 2.0 - 10);
    textSize(14);
    text("Oleadas superadas: " + gestorOleadas.numero, width / 2.0, height / 2.0 + 16);
    text("Presiona R para reiniciar", width / 2.0, height / 2.0 + 40);
    textAlign(LEFT);
  }

  void manejarEntrada() {
    if (estadoActual == ESTADO_MENU) {
      if (key == ' ') {
        cambiarEstado(ESTADO_PREPARACION);
      }
      return;
    }

    if (estadoActual == ESTADO_GAMEOVER) {
      if (key == 'r' || key == 'R') {
        iniciarJuego();
      }
      return;
    }

    if (key == ' ') {
      jugador.usarRegadera(parcelas, enemigos);
    } else if (key == 'q' || key == 'Q') {
      for (Parcela p : parcelas) {
        float cx = p.posX + p.tamanio / 2.0;
        float cy = p.posY + p.tamanio / 2.0;
        if (dist(jugador.posX, jugador.posY, cx, cy) < 55) {
          jugador.plantar(p);
          break;
        }
      }
    } else if (key == 't' || key == 'T') {
      if (!tienda.visible) tienda.abrir();
      else tienda.minimizar();
    } else if (key == ESC) {
      tienda.cerrar();
    } else if (key >= '1' && key <= '9') {
      inventario.seleccionarSemilla(key - '1');
    }

    if (mousePressed) {
      tienda.manejarClick(mouseX, mouseY, width - 430, 20, this);
    }
  }

  void cambiarEstado(int nuevo) {
    estadoActual = nuevo;
  }

  void comprobarGameOver() {
    if (plantasDestruidas >= 15) {
      cambiarEstado(ESTADO_GAMEOVER);
    }
  }
}
