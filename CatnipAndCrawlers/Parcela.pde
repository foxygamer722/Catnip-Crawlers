class Parcela {
  float x, y, tam;
  Planta miPlanta;

  Parcela(float x, float y, float tam) { this.x = x; this.y = y; this.tam = tam; }
  boolean contienePunto(float px, float py) { return px >= x && px <= x + tam && py >= y && py <= y + tam; }

  boolean plantar(Semilla s) {
    if (miPlanta == null && s != null) {
      miPlanta = new Planta(x, y, tam, s);
      return true;
    }
    return false;
  }

  void dibujar() {
    if (miPlanta != null) {
      stroke(75, 50, 28);
      strokeWeight(2);
      fill(100, 70, 40, 225);
    } else {
      stroke(0, 0, 0, 90);
      strokeWeight(2);
      fill(0, 0, 0, 55);
    }
    rect(x, y, tam, tam, 6);
    if (miPlanta != null) miPlanta.dibujar();
  }
}
