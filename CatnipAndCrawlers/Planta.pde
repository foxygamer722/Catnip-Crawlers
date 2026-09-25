class Planta {
  float x, y;
  float tamano;
  String nombre;
  color colorPlanta;
  int estadoCrecimiento;
  
  int ultimoRiego; 
  boolean necesitaAgua;

  Planta(float x, float y, float tamano, String nombre, color colorPlanta) {
    this.x = x;
    this.y = y;
    this.tamano = tamano;
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
      ellipse(x + tamano/2.0, y + tamano/2.0, tamano * 0.25, tamano * 0.35);
    } 
    else if (estadoCrecimiento == 1) {
      fill(0, 200, 0); 
      rect(x + tamano * 0.2, y + tamano * 0.2, tamano * 0.6, tamano * 0.6, 4);
      fill(255);
      textSize(tamano * 0.18);
      textAlign(CENTER, CENTER);
      text(nombre, x + tamano/2.0, y + tamano/2.0);
    }
  }
}
