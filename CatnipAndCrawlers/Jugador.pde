class Jugador {
  float x, y;
  float tamano;
  float velocidad;
  boolean movArriba, movAbajo, movIzq, movDer;
  
  int direccion;
  Regadera miRegadera;
  
  Jugador() {
    tamano = min(width, height) * 0.05;
    velocidad = min(width, height) * 0.008;
    x = width / 2.0;
    y = height / 2.0;
    direccion = 1;
    miRegadera = new Regadera();
  }

    void usarHerramienta(Jardin jardin) {
    miRegadera.usar(x, y, direccion, jardin);
  }
  
  void manejarInput(char k, int codigo, boolean presionado) {
    if (k == 'w' || k == 'W' || codigo == UP) movArriba = presionado;
    if (k == 's' || k == 'S' || codigo == DOWN) movAbajo = presionado;
    if (k == 'a' || k == 'A' || codigo == LEFT) movIzq = presionado;
    if (k == 'd' || k == 'D' || codigo == RIGHT) movDer = presionado;
  }
  
  void actualizar() {
    if (movArriba) { y -= velocidad; direccion = 0; }
    if (movAbajo) { y += velocidad; direccion = 1; }
    if (movIzq) { x -= velocidad; direccion = 2; }
    if (movDer) { x += velocidad; direccion = 3; }
    
    x = constrain(x, tamano/2.0, width - tamano/2.0);
    y = constrain(y, tamano/2.0, height - tamano/2.0);
  }
  
  void dibujar() {
    fill(255, 150, 0); 
    noStroke();
    ellipse(x, y, tamano, tamano);

    fill(0);
    float offset = tamano * 0.4;
    float tamanoHocico = tamano * 0.25;
    
    fill(0);
    if (direccion == 0) ellipse(x, y - offset, tamanoHocico, tamanoHocico); // Arriba
    if (direccion == 1) ellipse(x, y + offset, tamanoHocico, tamanoHocico); // Abajo
    if (direccion == 2) ellipse(x - offset, y, tamanoHocico, tamanoHocico); // Izquierda
    if (direccion == 3) ellipse(x + offset, y, tamanoHocico, tamanoHocico); // Derecha
  }
}
