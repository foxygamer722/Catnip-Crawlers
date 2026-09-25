class Parcela {
  float x, y;
  float tam;
  Planta miPlanta;

  Parcela(float x, float y, float tam) {
    this.x = x;
    this.y = y;
    this.tam = tam;
    this.miPlanta = null;
  }
  
  boolean contienePunto(float px, float py) {
    return px >= x && px <= x + tam && py >= y && py <= y + tam;
  }

  void plantar(String nombre, color colorPlanta) {
    if (miPlanta == null) {
      miPlanta = new Planta(x, y, tam, nombre, colorPlanta);
    }
  }

  void dibujar() {
    stroke(60, 120, 60); 
    strokeWeight(2);
    
    if (miPlanta != null) {
      fill(100, 70, 40);
    } else {
      fill(80, 160, 80);
    }
    
    rect(x, y, tam, tam);
    
    if (miPlanta != null) {
      miPlanta.dibujar();
    }
  }
}
