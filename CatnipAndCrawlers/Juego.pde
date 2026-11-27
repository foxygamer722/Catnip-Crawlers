class Juego {
  Jugador jugador;
  Jardin jardin;
  GestorOleadas gestorOleadas;
  GestorEstaciones gestorEstaciones;
  Inventario inventario;
  Tienda tienda;

  float slotW = width * 0.08, slotH = height * 0.09, sep = width * 0.015;
  float menuX = (width - (3*slotW + 2*sep)) / 2.0;
  float menuY = height - slotH - (height * 0.03);
  float hudX = width * 0.015;
  float hudY = height * 0.015;
  float hudW = width * 0.30;
  float hudH = height * 0.115;
  float multCosecha = 1.0;

  int bonusVidaPlanta = 0;
  int dinero = 50;
  int dineroTotalGenerado = 0;
  int oleada = 1;
  int plantasDestruidas = 0;
  int slotArrastrado = -1;
  boolean enOleada = false;

  Juego() {
    iniciarPartida();
  }

  void iniciarPartida() {
    dinero = 50;
    dineroTotalGenerado = 0;
    oleada = 1;
    plantasDestruidas = 0;
    multCosecha = 1.0;
    bonusVidaPlanta = 0;
    enOleada = false;
    slotArrastrado = -1;
    jugador = new Jugador();
    jardin = new Jardin();
    gestorOleadas = new GestorOleadas(); // Limpia enemigos de partidas anteriores
    gestorEstaciones = new GestorEstaciones();
    gestorEstaciones.activarAvisoInicial();
    inventario = new Inventario();
    tienda = new Tienda();
    inventario.agregarSemilla(new Semilla("Catnip", "Comun", 15, color(100, 255, 100), "catnip.png"));
    tienda.generarOferta();
  }

  void iniciarSiguienteOleada() {
    if (!enOleada && jardin.contarPlantas() > 0) {
      tienda.abierta = false;
      enOleada = true;
      gestorOleadas.iniciarOleada(oleada);
    }
  }

  void registrarPerdidaVida() {
    plantasDestruidas++;
    if (plantasDestruidas >= 3) {
      estadoActual = GAME_OVER;
    }
  }

  void actualizar() {
    jugador.actualizar();
    jardin.actualizar(enOleada, this);

    if (enOleada) {
      int oroEnemigos = gestorOleadas.actualizar(jardin, jugador, this, gestorEstaciones.getMultVelocidadEnemigos());
      dinero += oroEnemigos;
      dineroTotalGenerado += oroEnemigos;

      if (gestorOleadas.oleadaTerminada() && estadoActual == JUGANDO) {
        enOleada = false;
        int dineroPlantas = jardin.procesarFinDeOleada();
        dinero += dineroPlantas;
        dineroTotalGenerado += dineroPlantas;

        oleada++;
        if (oleada % 3 == 1) gestorEstaciones.cambiarEstacion();
        tienda.generarOferta();
      }
    }
  }

  void mousePresionado(float mx, float my, int boton) {
    if (tienda.abierta) {
      dinero = tienda.manejarClick(mx, my, dinero, inventario, this);
      return;
    }

    if (boton == RIGHT && !enOleada) {
      jardin.eliminarPlantaManual(mx, my);
      return;
    }

    if (!enOleada && mx > width * 0.78 && mx < width * 0.98 && my > height * 0.02 && my < height * 0.08) {
      iniciarSiguienteOleada();
      return;
    }
    if (!enOleada && mx > width * 0.78 && mx < width * 0.98 && my > height * 0.09 && my < height * 0.15) {
      tienda.abierta = true;
      return;
    }

    if (my >= menuY && my <= menuY + slotH) {
      for (int i = 0; i < 3; i++) {
        float sx = menuX + i*(slotW + sep);
        if (mx >= sx && mx <= sx + slotW && inventario.obtenerSemilla(i) != null) {
          slotArrastrado = i;
          return;
        }
      }
    } else {
      jugador.usarHerramienta(jardin, gestorOleadas, enOleada);
    }
  }

  void mouseSoltado(float mx, float my) {
    if (slotArrastrado != -1) {
      Semilla s = inventario.obtenerSemilla(slotArrastrado);
      if (jardin.intentarPlantar(mx, my, s)) {
        inventario.consumirSemilla(slotArrastrado);
      }
      slotArrastrado = -1;
    }
  }

  void dibujar() {
    gestorEstaciones.dibujarFondo();
    jardin.dibujar();
    gestorOleadas.dibujar();
    jugador.dibujar();

    for (int i = 0; i < 3; i++) {
      float sx = menuX + i*(slotW + sep);
      Semilla s = inventario.obtenerSemilla(i);
      fill(s != null ? s.colorPlanta : color(180));
      stroke(0);
      rect(sx, menuY, slotW, slotH, 8);
      if (s != null) {
        if (s.sprite != null) {
          imageMode(CENTER);
          image(s.sprite, sx + slotW/2, menuY + slotH*0.38, slotH*0.55, slotH*0.55);
          imageMode(CORNER);
        }
        fill(0);
        textSize(height * 0.015);
        textAlign(CENTER, CENTER);
        text(s.nombre, sx + slotW/2, menuY + slotH*0.78);
      }
    }

    if (slotArrastrado != -1) {
      Semilla s = inventario.obtenerSemilla(slotArrastrado);
      if (s.sprite != null) {
        imageMode(CENTER);
        image(s.sprite, mouseX, mouseY, width*0.04, width*0.04);
        imageMode(CORNER);
      } else {
        fill(s.colorPlanta);
        ellipse(mouseX, mouseY, width*0.03, width*0.03);
      }
    }

    fill(255, 255, 255, 175);
    stroke(0, 0, 0, 80);
    strokeWeight(1.5);
    rect(hudX, hudY, hudW, hudH, 10);

    fill(0);
    textSize(height * 0.022);
    textAlign(LEFT, TOP);
    text("Oleada: " + oleada + " (" + (enOleada ? "EN CURSO" : "PREPARACIÓN") + ")" +
      "\nEstación: " + gestorEstaciones.getNombre() +
      "\nDinero: $" + dinero + " | Vidas: " + (3 - plantasDestruidas) + "/3",
      hudX + width * 0.01, hudY + height * 0.01);

    if (!enOleada) {
      fill(50, 180, 80);
      rect(width*0.78, height*0.02, width*0.2, height*0.06, 6);
      fill(255);
      textAlign(CENTER, CENTER);
      text("INICIAR OLEADA", width*0.88, height*0.05);

      fill(220, 160, 40);
      rect(width*0.78, height*0.09, width*0.2, height*0.06, 6);
      fill(0);
      text("ABRIR TIENDA", width*0.88, height*0.12);
    }

    gestorEstaciones.dibujarAviso();
    tienda.dibujar();
  }
}
