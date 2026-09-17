class Semilla {
  String nombre;
  String tipoPlanta;
  int rareza;
  float precio;

  // Datos base para generar la planta correspondiente
  float vidaBase, dineroBase, tiempoCrecBase;

  Semilla(String nombre, String tipoPlanta, int rareza, float precio,
          float vidaBase, float dineroBase, float tiempoCrecBase) {
    this.nombre = nombre;
    this.tipoPlanta = tipoPlanta;
    this.rareza = rareza;
    this.precio = precio;
    this.vidaBase = vidaBase;
    this.dineroBase = dineroBase;
    this.tiempoCrecBase = tiempoCrecBase;
  }

  Planta crearPlanta() {
    return new Planta(nombre, tipoPlanta, rareza, vidaBase, dineroBase, tiempoCrecBase);
  }

  void mostrar(float x, float y, float tam) {
    color c = color(60, 160, 60);
    if (rareza == RARA)            c = color(60, 120, 200);
    else if (rareza == EPICA)      c = color(160, 60, 200);
    else if (rareza == LEGENDARIA) c = color(230, 180, 30);

    noStroke();
    fill(c);
    rect(x, y, tam, tam, 6);
    fill(0);
    textSize(9);
    textAlign(CENTER);
    text(nombre, x + tam / 2.0, y + tam + 11);
    text("$" + int(precio), x + tam / 2.0, y + tam + 22);
    textAlign(LEFT);
  }
}
