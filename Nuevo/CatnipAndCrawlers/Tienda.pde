class Tienda {
  Semilla[] ofertaSemillas;
  Mejora[] catalogoMejoras;
  Mejora[] ofertaMejoras;
  boolean abierta = false;

  Tienda() {
    ofertaSemillas = new Semilla[3];
    ofertaMejoras = new Mejora[2];
    catalogoMejoras = new Mejora[]{
      new Mejora("Botas Felinas", "+30% Velocidad", 40, 0),
      new Mejora("Boquilla Ancha", "+35% Área Regadera", 50, 1),
      new Mejora("Tanque Presión", "-250ms Cooldown", 60, 2)
    };
  }

  void generarOferta() {
    abierta = true;
    for (int i = 0; i < 3; i++) {
      int r = int(random(3));
      if (r == 0) ofertaSemillas[i] = new Semilla("Catnip", "Comun", 15, color(100, 255, 100), "catnip.png");
      if (r == 1) ofertaSemillas[i] = new Semilla("Menta", "Rara", 25, color(0, 180, 120), "menta.png");
      if (r == 2) ofertaSemillas[i] = new Semilla("Girasol", "Epica", 40, color(255, 200, 0), "girasol.png");
    }
    ofertaMejoras[0] = catalogoMejoras[int(random(catalogoMejoras.length))];
    ofertaMejoras[1] = catalogoMejoras[int(random(catalogoMejoras.length))];
  }

  int manejarClick(float mx, float my, int dinero, Inventario inv, Jugador jug) {
    if (!abierta) return dinero;
    float panelX = width * 0.2;
    float panelY = height * 0.2;
    float panelW = width * 0.6;
    float panelH = height * 0.55;

    if (mx > panelX + panelW - width*0.08 && mx < panelX + panelW && my > panelY && my < panelY + height*0.05) {
      abierta = false;
      return dinero;
    }

    for (int i = 0; i < 3; i++) {
      float bx = panelX + width*0.04 + i*(width*0.18);
      float by = panelY + height*0.12;
      if (ofertaSemillas[i] != null && mx > bx && mx < bx + width*0.15 && my > by && my < by + height*0.14) {
        if (dinero >= ofertaSemillas[i].precio && inv.agregarSemilla(ofertaSemillas[i])) {
          dinero -= ofertaSemillas[i].precio;
          ofertaSemillas[i] = null;
        }
      }
    }

    for (int i = 0; i < 2; i++) {
      float bx = panelX + width*0.08 + i*(width*0.24);
      float by = panelY + height*0.32;
      if (ofertaMejoras[i] != null && !ofertaMejoras[i].comprada && mx > bx && mx < bx + width*0.2 && my > by && my < by + height*0.14) {
        if (dinero >= ofertaMejoras[i].precio) {
          dinero -= ofertaMejoras[i].precio;
          ofertaMejoras[i].aplicar(jug);
        }
      }
    }
    return dinero;
  }

  void dibujar() {
    if (!abierta) return;
    float panelX = width * 0.2;
    float panelY = height * 0.2;
    float panelW = width * 0.6;
    float panelH = height * 0.55;

    fill(40, 40, 50, 235);
    stroke(255);
    rect(panelX, panelY, panelW, panelH, 12);

    fill(255); textSize(height * 0.028); textAlign(LEFT, TOP);
    text("TIENDA DE JARDÍN", panelX + width*0.02, panelY + height*0.02);

    fill(200, 60, 60);
    rect(panelX + panelW - width*0.08, panelY, width*0.08, height*0.05, 6);
    fill(255); textAlign(CENTER, CENTER); textSize(height * 0.02);
    text("X", panelX + panelW - width*0.04, panelY + height*0.025);

    for (int i = 0; i < 3; i++) {
      float bx = panelX + width*0.04 + i*(width*0.18);
      float by = panelY + height*0.12;
      if (ofertaSemillas[i] != null) {
        fill(ofertaSemillas[i].colorPlanta);
        rect(bx, by, width*0.15, height*0.14, 8);
        fill(0); textSize(height * 0.018);
        text(ofertaSemillas[i].nombre + "\n$" + ofertaSemillas[i].precio, bx + width*0.075, by + height*0.07);
      }
    }

    for (int i = 0; i < 2; i++) {
      float bx = panelX + width*0.08 + i*(width*0.24);
      float by = panelY + height*0.32;
      Mejora m = ofertaMejoras[i];
      fill(m.comprada ? color(100) : color(100, 180, 255));
      rect(bx, by, width*0.2, height*0.14, 8);
      fill(0); textSize(height * 0.017);
      text(m.comprada ? "COMPRADA" : m.nombre + "\n" + m.descripcion + "\n$" + m.precio, bx + width*0.1, by + height*0.07);
    }
  }
}
