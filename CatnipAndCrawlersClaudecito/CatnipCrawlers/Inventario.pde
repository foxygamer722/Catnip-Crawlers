class Inventario {
  int capacidad;
  ArrayList<Semilla> semillas;
  Semilla semillaSeleccionada;

  Inventario(int capacidad) {
    this.capacidad = capacidad;
    this.semillas = new ArrayList<Semilla>();
    this.semillaSeleccionada = null;
  }

  boolean agregarSemilla(Semilla s) {
    if (estaLleno()) return false;
    semillas.add(s);
    if (semillaSeleccionada == null) semillaSeleccionada = s;
    return true;
  }

  void eliminarSemilla(Semilla s) {
    semillas.remove(s);
    if (semillaSeleccionada == s) {
      semillaSeleccionada = semillas.size() > 0 ? semillas.get(0) : null;
    }
  }

  void seleccionarSemilla(int indice) {
    if (indice >= 0 && indice < semillas.size()) {
      semillaSeleccionada = semillas.get(indice);
    }
  }

  boolean estaLleno() {
    return semillas.size() >= capacidad;
  }

  void mostrar(float x, float y) {
    noStroke();
    fill(255, 255, 255, 210);
    rect(x, y, 260, 80, 8);
    fill(0);
    textSize(11);
    textAlign(LEFT);
    text("Inventario (" + semillas.size() + "/" + capacidad + ") - teclas 1-9", x + 8, y + 15);

    for (int i = 0; i < semillas.size(); i++) {
      Semilla s = semillas.get(i);
      float sx = x + 8 + (i % 8) * 30;
      float sy = y + 22 + (i / 8) * 30;
      fill(s == semillaSeleccionada ? color(255, 220, 120) : color(210, 210, 210));
      rect(sx, sy, 26, 26, 4);
      fill(0);
      textSize(8);
      textAlign(CENTER);
      String corto = s.nombre.length() > 4 ? s.nombre.substring(0, 4) : s.nombre;
      text(corto, sx + 13, sy + 16);
    }
    textAlign(LEFT);
  }
}
