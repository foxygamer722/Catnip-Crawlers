class Jugador {
  float posX, posY;
  float velocidad;
  int direccion;
  Regadera regadera;
  Inventario inventario;

  Jugador(float posX, float posY) {
    this.posX = posX;
    this.posY = posY;
    this.velocidad = 2.6;
    this.direccion = ABAJO;
    this.regadera = new Regadera();
    this.inventario = new Inventario(12);
  }

  void mover() {
    float dx = 0, dy = 0;
    if (keyPressed) {
      if (key == 'w' || key == 'W' || keyCode == UP)    dy -= 1;
      if (key == 's' || key == 'S' || keyCode == DOWN)  dy += 1;
      if (key == 'a' || key == 'A' || keyCode == LEFT)  dx -= 1;
      if (key == 'd' || key == 'D' || keyCode == RIGHT) dx += 1;
    }
    if (dx != 0 || dy != 0) {
      float mag = sqrt(dx * dx + dy * dy);
      posX += (dx / mag) * velocidad;
      posY += (dy / mag) * velocidad;
      actualizarDireccion(dx, dy);
    }
    posX = constrain(posX, 15, width - 15);
    posY = constrain(posY, 15, height - 15);
  }

  void actualizarDireccion(float dx, float dy) {
    if (dy < 0) direccion = ARRIBA;
    else if (dy > 0) direccion = ABAJO;
    else if (dx < 0) direccion = IZQUIERDA;
    else if (dx > 0) direccion = DERECHA;
  }

  void usarRegadera(ArrayList<Parcela> parcelas, ArrayList<Enemigo> enemigos) {
    regadera.usar(posX, posY, direccion, parcelas, enemigos);
  }

  boolean plantar(Parcela p) {
    if (inventario.semillaSeleccionada == null) return false;
    if (!p.estaLibre()) return false;
    Planta nueva = inventario.semillaSeleccionada.crearPlanta();
    return p.plantar(nueva);
  }

  void mostrar() {
    regadera.mostrarArea(posX, posY, direccion);

    noStroke();
    fill(230, 150, 60);
    ellipse(posX, posY, 30, 26);

    fill(255, 240, 230);
    triangle(posX - 16, posY - 12, posX - 8, posY - 24, posX - 2, posY - 12);
    triangle(posX + 2, posY - 12, posX + 8, posY - 24, posX + 16, posY - 12);

    fill(0);
    float ox = 0, oy = 0;
    if (direccion == ARRIBA)      oy = -4;
    else if (direccion == ABAJO)  oy = 4;
    else if (direccion == IZQUIERDA) ox = -4;
    else if (direccion == DERECHA)   ox = 4;
    ellipse(posX + ox - 3, posY + oy - 2, 3, 3);
    ellipse(posX + ox + 3, posY + oy - 2, 3, 3);

    // Regadera visual segun cooldown
    fill(regadera.puedeUsarse() ? color(80, 160, 220) : color(150, 150, 150));
    ellipse(posX + ox * 3, posY + oy * 3, 10, 8);
  }
}
