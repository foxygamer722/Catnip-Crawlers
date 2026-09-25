class Parcela {
  float x, y;
  float tamano;
  Planta miPlanta; // Reemplazamos el boolean "ocupada" por el objeto real

  Parcela(float x, float y, float tamano) {
    this.x = x;
    this.y = y;
    this.tamano = tamano;
    this.miPlanta = null; // null significa que está vacía
  }
  
  boolean contienePunto(float px, float py) {
    return px >= x && px <= x + tamano && py >= y && py <= y + tamano;
  }

  void plantar(String nombre, color colorPlanta) {
    // Solo plantamos si está vacía
    if (miPlanta == null) {
      miPlanta = new Planta(x, y, tamano, nombre, colorPlanta);
    }
  }

  void dibujar() {
    stroke(60, 120, 60); 
    strokeWeight(2);
    
    // Si hay una planta, dibujamos la tierra más oscura
    if (miPlanta != null) {
      fill(100, 70, 40); // Tierra arada
    } else {
      fill(80, 160, 80); // Pasto
    }
    
    rect(x, y, tamano, tamano);
    
    // Si hay planta, le decimos a la planta que se dibuje a sí misma
    if (miPlanta != null) {
      miPlanta.dibujar();
    }
  }
}
