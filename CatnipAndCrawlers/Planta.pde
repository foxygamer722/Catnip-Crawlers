class Planta {
  float x, y;
  float tamano;
  String nombre;
  color colorPlanta;
  int estadoCrecimiento; // 0 = Semilla, 1 = Brotada
  
  // Atributos para el futuro sistema de agua
  int ultimoRiego; 
  boolean necesitaAgua;

  Planta(float x, float y, float tamano, String nombre, color colorPlanta) {
    this.x = x;
    this.y = y;
    this.tamano = tamano;
    this.nombre = nombre;
    this.colorPlanta = colorPlanta;
    this.estadoCrecimiento = 0; // Nace como semilla
    this.necesitaAgua = false;  // Por ahora no pide agua sola
  }

  void recibirAgua() {
    if (estadoCrecimiento == 0) {
      // Si es una semilla y la riegan, brota
      estadoCrecimiento = 1; 
      ultimoRiego = millis(); // Guardamos el momento en que se regó
    } else {
      // Lógica para el futuro: si necesita agua, se la damos y le sacamos la sed
      necesitaAgua = false;
      ultimoRiego = millis();
    }
  }

  void dibujar() {
    // Dibujamos algo distinto según el estado
    if (estadoCrecimiento == 0) {
      // Dibuja una Semilla (un óvalo marrón)
      fill(80, 50, 20); 
      ellipse(x + tamano/2.0, y + tamano/2.0, tamano * 0.25, tamano * 0.35);
    } 
    else if (estadoCrecimiento == 1) {
      // Dibuja una planta pequeña (un cuadradito verde)
      fill(0, 200, 0); 
      rect(x + tamano * 0.2, y + tamano * 0.2, tamano * 0.6, tamano * 0.6, 4);
      // Muestra una etiqueta con su nombre
      fill(255);
      textSize(tamano * 0.18); // Texto relativo al tamaño de la parcela
      textAlign(CENTER, CENTER);
      text(nombre, x + tamano/2.0, y + tamano/2.0);
    }
    // (Futuro) Si necesitaAgua es true, acá dibujaríamos el "!" encima
  }
}
