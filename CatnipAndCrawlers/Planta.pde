class Planta {
  float x, y;
  float tam;
  String nombre;
  color colorPlanta;
  int estadoCrecimiento; // 0 = Semilla, 1 = Brotada
  
  int ultimoRiego; 
  boolean necesitaAgua;

  Planta(float x, float y, float tam, String nombre, color colorPlanta) {
    this.x = x;
    this.y = y;
    this.tam = tam;
    this.nombre = nombre;
    this.colorPlanta = colorPlanta;
    this.estadoCrecimiento = 0;
    this.necesitaAgua = false;
  }

  void recibirAgua() {
    if (estadoCrecimiento == 0) {
      estadoCrecimiento = 1; 
      ultimoRiego = millis();
    } else {
      necesitaAgua = false;
      ultimoRiego = millis();
    }
  }

  void dibujar() {
    if (estadoCrecimiento == 0) {
      fill(80, 50, 20); 
      ellipse(x + tam/2.0, y + tam/2.0, tam * 0.25, tam * 0.35);
    } 
    else if (estadoCrecimiento == 1) {
      fill(0, 200, 0); 
      rect(x + tam * 0.2, y + tam * 0.2, tam * 0.6, tam * 0.6, 4);
      fill(255);
      textSize(tam * 0.18);
      textAlign(CENTER, CENTER);
      text(nombre, x + tam/2.0, y + tam/2.0);
    }
    // Hay que agregar el indicador de agua
  }
}
