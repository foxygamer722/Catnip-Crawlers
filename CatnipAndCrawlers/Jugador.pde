class Jugador {
  float x, y;
  float tam;
  float velocidad;
  boolean movArriba, movAbajo, movIzq, movDer;
  
  int direccion; // 0=Arriba, 1=Abajo, 2=Izq, 3=Der
  Regadera miRegadera;
  
  Jugador() {
    tam = min(width, height) * 0.05;
    velocidad = min(width, height) * 0.008;
    x = width / 2.0;
    y = height / 2.0;
    direccion = 1;
    miRegadera = new Regadera();
  }
  
  void usarHerramienta(Jardin jardin) {
    miRegadera.usar(x, y, direccion, jardin);
  }
  
  void controlarInput(char k, int codigo, boolean presionado) {
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
    
    x = constrain(x, tam/2.0, width - tam/2.0);
    y = constrain(y, tam/2.0, height - tam/2.0);
  }
  
  void dibujar() {
    fill(255, 150, 0); 
    noStroke();
    ellipse(x, y, tam, tam);
    
    fill(0);
    float offset = tam * 0.4;
    float tamHocico = tam * 0.25;
    
    fill(0);
    if (direccion == 0) ellipse(x, y - offset, tamHocico, tamHocico);
    if (direccion == 1) ellipse(x, y + offset, tamHocico, tamHocico);
    if (direccion == 2) ellipse(x - offset, y, tamHocico, tamHocico);
    if (direccion == 3) ellipse(x + offset, y, tamHocico, tamHocico);
  }
}
