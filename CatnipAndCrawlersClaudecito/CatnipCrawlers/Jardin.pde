class Jardin {
  int estacionVisual;
  color textura;
  ArrayList<PVector> decoracion;

  GestorEstaciones gestorRef;

  Jardin(GestorEstaciones gestorEstaciones) {
    gestorRef = gestorEstaciones;
    estacionVisual = gestorRef.estacionActual;
    decoracion = new ArrayList<PVector>();
    generarDecoracion();
    actualizarEstacion();
  }

  void generarDecoracion() {
    decoracion.clear();
    for (int i = 0; i < 25; i++) {
      decoracion.add(new PVector(random(width), random(height)));
    }
  }

  void actualizarEstacion() {
    if (estacionVisual != gestorRef.estacionActual) {
      estacionVisual = gestorRef.estacionActual;
      generarDecoracion();
    }
    if (estacionVisual == PRIMAVERA)      textura = color(150, 210, 120);
    else if (estacionVisual == VERANO)    textura = color(120, 190, 80);
    else if (estacionVisual == OTONO)     textura = color(200, 150, 80);
    else                                   textura = color(225, 235, 245);
  }

  void mostrar() {
    background(textura);
    mostrarDecoracion();
  }

  void mostrarDecoracion() {
    noStroke();
    for (PVector v : decoracion) {
      if (estacionVisual == PRIMAVERA) {
        fill(255, 200, 220);
        ellipse(v.x, v.y, 5, 5);
      } else if (estacionVisual == VERANO) {
        fill(255, 255, 150, 180);
        ellipse(v.x, v.y, 3, 3);
      } else if (estacionVisual == OTONO) {
        fill(180, 90, 30);
        ellipse(v.x, v.y, 6, 4);
      } else {
        fill(255);
        ellipse(v.x, v.y, 4, 4);
      }
    }
  }
}
