class GestorEstaciones {
  String[] nombres = {"Primavera", "Verano", "Otoño", "Invierno"};
  PImage[] fondos;
  int estacionActual = 0;
  int tiempoCambio = -10000;
  int duracionCartel = 10000;

  GestorEstaciones() {
    fondos = new PImage[4];
    fondos[0] = prepararFondo("fondo_primavera.png");
    fondos[1] = prepararFondo("fondo_verano.png");
    fondos[2] = prepararFondo("fondo_otono.png");
    fondos[3] = prepararFondo("fondo_invierno.png");
  }

  // Adapta la imagen
  PImage prepararFondo(String nombreArchivo) {
    PImage img = loadImage(nombreArchivo);
    if (img != null) {
      img.resize(width, height);
    }
    return img;
  }

  void activarAvisoInicial() {
    tiempoCambio = millis();
  }

  void cambiarEstacion() {
    int nueva = estacionActual;
    while (nueva == estacionActual) {
      nueva = int(random(4));
    }
    estacionActual = nueva;
    tiempoCambio = millis();
  }

  String getNombre() { return nombres[estacionActual]; }

  String getDescripcionEfecto() {
    if (estacionActual == 0) return "Clima ideal: Las plantas crecen más rápido (+25% velocidad).";
    if (estacionActual == 1) return "Clima cálido: Condiciones normales en todo el jardín.";
    if (estacionActual == 2) return "Viento otoñal: ¡Los insectos se mueven un 25% más rápido!";
    return "Frío invernal: Insectos 25% más lentos, pero plantas crecen más lento.";
  }

  // Colores por si hay errores con las imagenes
  color getColorFondo() {
    if (estacionActual == 0) return color(100, 200, 100);
    if (estacionActual == 1) return color(160, 210, 80);
    if (estacionActual == 2) return color(200, 150, 80);
    return color(190, 225, 240);
  }

  void dibujarFondo() {
    if (fondos[estacionActual] != null) {
      background(fondos[estacionActual]);
    } else {
      background(getColorFondo());
    }
  }

  float getMultVelocidadEnemigos() {
    if (estacionActual == 2) return 1.25;
    if (estacionActual == 3) return 0.75;
    return 1.0;
  }

  float getMultCrecimiento() {
    if (estacionActual == 0) return 0.75;
    if (estacionActual == 3) return 1.35;
    return 1.0;
  }

  // AVISO DEL CAMBIO
  void dibujarAviso() {
    if (millis() - tiempoCambio < duracionCartel) {
      float boxW = width * 0.56;
      float boxH = height * 0.14;
      float boxX = (width - boxW) / 2.0;
      float boxY = height * 0.16;

      fill(25, 35, 30, 220);
      stroke(255, 225, 110);
      strokeWeight(max(2, height * 0.004));
      rect(boxX, boxY, boxW, boxH, 14);

      textAlign(CENTER, CENTER);
      fill(255, 225, 110);
      textSize(height * 0.028);
      text("ESTACIÓN: " + getNombre().toUpperCase(), width / 2.0, boxY + boxH * 0.34);

      fill(245);
      textSize(height * 0.019);
      text(getDescripcionEfecto(), width / 2.0, boxY + boxH * 0.72);
    }
  }
}
