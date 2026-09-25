class Jugador {
  float x, y;
  float tamano;
  float velocidad;
  boolean movArriba, movAbajo, movIzq, movDer;
  
  // NUEVO: Direcciones y Regadera
  int direccion; // 0=Arriba, 1=Abajo, 2=Izq, 3=Der
  Regadera miRegadera;
  
  Jugador() {
    tamano = min(width, height) * 0.05; // 5% del lado menor
    velocidad = min(width, height) * 0.008; // Velocidad proporcional
    x = width / 2.0;
    y = height / 2.0;
    direccion = 1; // Arranca mirando hacia abajo
    miRegadera = new Regadera();
  }
  
  // NUEVO: Método para que el Juego le ordene usar la regadera
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
    // Movemos y guardamos hacia dónde estamos yendo
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
    ellipse(x, y, tamano, tamano); // Cuerpo del gato
    
    // Hociquito / Dirección proporcional
    fill(0);
    float offset = tamano * 0.4;
    float tamanoHocico = tamano * 0.25;
    
    // NUEVO: Un indicador negro para saber a dónde mira
    fill(0);
    if (direccion == 0) ellipse(x, y - offset, tamanoHocico, tamanoHocico); // Arriba
    if (direccion == 1) ellipse(x, y + offset, tamanoHocico, tamanoHocico); // Abajo
    if (direccion == 2) ellipse(x - offset, y, tamanoHocico, tamanoHocico); // Izquierda
    if (direccion == 3) ellipse(x + offset, y, tamanoHocico, tamanoHocico); // Derecha
  }
}
