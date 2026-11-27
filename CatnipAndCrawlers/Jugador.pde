class Jugador {
  float x, y, tam, velocidad;
  boolean movArriba, movAbajo, movIzq, movDer;
  int direccion = 1; // 0=Arriba, 1=Abajo, 2=Izq, 3=Der
  boolean mirandoIzquierda = false;
  Regadera miRegadera;
  PImage sprite;
  
  Jugador() {
    tam = min(width, height) * 0.085;
    velocidad = min(width, height) * 0.008;
    x = width / 2.0; y = height / 2.0;
    miRegadera = new Regadera();
    sprite = loadImage("gato.png");
  }
  
  void usarHerramienta(Jardin jardin, GestorOleadas oleadas, boolean enOleada) {
    miRegadera.usar(x, y, direccion, jardin, oleadas, enOleada);
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
    if (movIzq) { x -= velocidad; direccion = 2; mirandoIzquierda = true; }
    if (movDer) { x += velocidad; direccion = 3; mirandoIzquierda = false; }
    x = constrain(x, tam/2.0, width - tam/2.0);
    y = constrain(y, tam/2.0, height - tam/2.0);
  }
  
  void dibujar() {
    miRegadera.dibujarEfecto(x, y, direccion);
    if (sprite != null) {
      pushMatrix();
      translate(x, y);
      if (mirandoIzquierda) {
        scale(-1, 1);
      }
      imageMode(CENTER);
      image(sprite, 0, 0, tam, tam);
      imageMode(CORNER);
      popMatrix();
    } else {
      fill(255, 150, 0); noStroke(); ellipse(x, y, tam, tam);
      fill(0);
      float off = tam * 0.4, h = tam * 0.25;
      if (direccion == 0) ellipse(x, y - off, h, h);
      if (direccion == 1) ellipse(x, y + off, h, h);
      if (direccion == 2) ellipse(x - off, y, h, h);
      if (direccion == 3) ellipse(x + off, y, h, h);
    }
  }
}
