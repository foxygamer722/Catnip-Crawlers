class Tienda {
  ArrayList<Semilla> semillasDispo;
  ArrayList<Mejora> mejorasDispo;
  boolean visible;
  boolean minimizada;

  Tienda() {
    semillasDispo = new ArrayList<Semilla>();
    mejorasDispo = new ArrayList<Mejora>();
    visible = false;
    minimizada = false;
    generarOfertas();
  }

  void abrir() {
    visible = true;
    minimizada = false;
  }

  void cerrar() {
    visible = false;
  }

  void minimizar() {
    minimizada = !minimizada;
  }

  void generarOfertas() {
    semillasDispo.clear();
    semillasDispo.add(new Semilla("Girasol",     "Girasol",     COMUN,      10, 40,  3,  180));
    semillasDispo.add(new Semilla("Tomate",      "Tomate",      COMUN,      15, 50,  4,  220));
    semillasDispo.add(new Semilla("Cactus",      "Cactus",      RARA,       25, 70,  7,  260));
    semillasDispo.add(new Semilla("Menta",       "Menta",       RARA,       20, 45,  6,  200));
    semillasDispo.add(new Semilla("FlorLuna",    "FlorLuna",    EPICA,      40, 90,  12, 320));
    if (random(1) < 0.4) {
      semillasDispo.add(new Semilla("ArbolDorado", "ArbolDorado", LEGENDARIA, 80, 140, 25, 420));
    }

    mejorasDispo.clear();
    mejorasDispo.add(new Mejora("Patas Rapidas",     "+ velocidad del gato",        35, "velocidad"));
    mejorasDispo.add(new Mejora("Regadera Reforzada","+ danio de la regadera",      40, "danio"));
    mejorasDispo.add(new Mejora("Riego Rapido",      "- cooldown de la regadera",   45, "cooldown"));
    mejorasDispo.add(new Mejora("Chorro Amplio",     "+ area de la regadera",       50, "area"));
    mejorasDispo.add(new Mejora("Bolsa Grande",      "+ capacidad del inventario",  30, "capacidad"));
  }

  boolean comprarSemilla(Semilla s, Juego juego) {
    if (juego.dinero >= s.precio && !juego.jugador.inventario.estaLleno()) {
      if (juego.jugador.inventario.agregarSemilla(s)) {
        juego.dinero -= s.precio;
        return true;
      }
    }
    return false;
  }

  boolean comprarMejora(Mejora m, Juego juego) {
    if (juego.dinero >= m.precio) {
      juego.dinero -= m.precio;
      m.aplicar(juego.jugador, juego.jugador.inventario);
      return true;
    }
    return false;
  }

  void mostrar(float x, float y) {
    if (!visible) return;
    noStroke();
    fill(255, 255, 255, 235);
    float w = 420;
    float h = minimizada ? 30 : 300;
    rect(x, y, w, h, 8);
    fill(0);
    textSize(12);
    textAlign(LEFT);
    text("TIENDA  (T: minimizar, ESC: cerrar)", x + 8, y + 18);
    if (minimizada) return;

    textSize(11);
    text("Semillas:", x + 8, y + 36);
    for (int i = 0; i < semillasDispo.size(); i++) {
      float sx = x + 8 + (i % 5) * 80;
      float sy = y + 44 + (i / 5) * 66;
      semillasDispo.get(i).mostrar(sx, sy, 44);
    }

    text("Mejoras:", x + 8, y + 168);
    for (int i = 0; i < mejorasDispo.size(); i++) {
      float mx = x + 8 + (i % 2) * 205;
      float my = y + 176 + (i / 2) * 58;
      mejorasDispo.get(i).mostrar(mx, my, 195, 52);
    }
  }

  void manejarClick(float mx, float my, float x, float y, Juego juego) {
    if (!visible || minimizada) return;

    for (int i = 0; i < semillasDispo.size(); i++) {
      float sx = x + 8 + (i % 5) * 80;
      float sy = y + 44 + (i / 5) * 66;
      if (mx >= sx && mx <= sx + 44 && my >= sy && my <= sy + 44) {
        comprarSemilla(semillasDispo.get(i), juego);
        return;
      }
    }
    for (int i = 0; i < mejorasDispo.size(); i++) {
      float mxp = x + 8 + (i % 2) * 205;
      float myp = y + 176 + (i / 2) * 58;
      if (mx >= mxp && mx <= mxp + 195 && my >= myp && my <= myp + 52) {
        comprarMejora(mejorasDispo.get(i), juego);
        return;
      }
    }
  }
}
