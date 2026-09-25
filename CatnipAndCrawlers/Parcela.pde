class Parcela {
  float x, y;
  float tamano;
  Planta miPlanta;

  Parcela(float x, float y, float tamano) {
    this.x = x;
    this.y = y;
    this.tamano = tamano;
    this.miPlanta = null;
  }
  
  boolean contienePunto(float px, float py) {
    return px >= x && px <= x + tamano && py >= y && py <= y + tamano;
  }

  void plantar(String nombre, color colorPlanta) {
    if (miPlanta == null) {
      miPlanta = new Planta(x, y, tamano, nombre, colorPlanta);
    }
  }

  void dibujar() {
    stroke(60, 120, 60); 
    strokeWeight(2);
    
    if (miPlanta != null) {
      fill(100, 70, 40); // Tierra arada
    } else {
      fill(80, 160, 80); // Pasto
    }    
    rect(x, y, tamano, tamano);
    
    if (miPlanta != null) {
      miPlanta.dibujar();
    }
  }
}
