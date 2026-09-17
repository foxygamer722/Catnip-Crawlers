class Enemigo {
  float posX, posY;
  float vida;
  float velocidad;
  float danio;
  String tipo;
  Parcela objetivo;

  // Auxiliares internos (no forman parte de la lista original de atributos)
  boolean muerto = false;
  float vidaMaxima;

  Enemigo(float posX, float posY, String tipo) {
    this.posX = posX;
    this.posY = posY;
    this.tipo = tipo;
    configurarPorTipo();
  }

  void configurarPorTipo() {
    if (tipo.equals("Hormiga"))          { vida = 20; velocidad = 1.4; danio = 3; }
    else if (tipo.equals("Escarabajo"))  { vida = 40; velocidad = 0.9; danio = 6; }
    else if (tipo.equals("Oruga"))       { vida = 15; velocidad = 1.1; danio = 2; }
    else if (tipo.equals("Avispa"))      { vida = 25; velocidad = 1.8; danio = 4; }
    else if (tipo.equals("Babosa"))      { vida = 60; velocidad = 0.6; danio = 8; }
    else                                  { vida = 20; velocidad = 1.0; danio = 3; }
    vidaMaxima = vida;
  }

  void buscarObjetivo(ArrayList<Parcela> parcelas) {
    Parcela mejor = null;
    float distMin = Float.MAX_VALUE;
    for (Parcela p : parcelas) {
      if (!p.estaLibre() && p.planta != null && p.planta.estado != MARCHITA) {
        float d = dist(posX, posY, p.posX, p.posY);
        if (d < distMin) {
          distMin = d;
          mejor = p;
        }
      }
    }
    objetivo = mejor;
  }

  void mover() {
    if (objetivo == null) return;
    float cx = objetivo.posX + objetivo.tamanio / 2.0;
    float cy = objetivo.posY + objetivo.tamanio / 2.0;
    float dx = cx - posX;
    float dy = cy - posY;
    float d = sqrt(dx * dx + dy * dy);
    if (d > 6) {
      posX += (dx / d) * velocidad;
      posY += (dy / d) * velocidad;
    }
  }

  void atacar() {
    if (objetivo == null || objetivo.estaLibre() || objetivo.planta == null) return;
    float cx = objetivo.posX + objetivo.tamanio / 2.0;
    float cy = objetivo.posY + objetivo.tamanio / 2.0;
    if (dist(posX, posY, cx, cy) <= 42) {
      objetivo.planta.recibirDanio(danio * 0.06);
    }
  }

  void recibirDanio(float cantidad) {
    vida -= cantidad;
    if (vida <= 0) morir();
  }

  void morir() {
    muerto = true;
  }

  void mostrar() {
    noStroke();
    color c = color(120, 40, 40);
    if (tipo.equals("Hormiga"))          c = color(35, 35, 35);
    else if (tipo.equals("Escarabajo"))  c = color(90, 40, 110);
    else if (tipo.equals("Oruga"))       c = color(90, 160, 40);
    else if (tipo.equals("Avispa"))      c = color(235, 200, 30);
    else if (tipo.equals("Babosa"))      c = color(160, 100, 150);

    fill(c);
    ellipse(posX, posY, 22, 16);
    fill(0);
    ellipse(posX + 8, posY - 4, 3, 3);

    // Barra de vida
    float ratio = constrain(vida / vidaMaxima, 0, 1);
    noStroke();
    fill(60);
    rect(posX - 15, posY - 16, 30, 4);
    fill(200, 40, 40);
    rect(posX - 15, posY - 16, 30 * ratio, 4);
  }
}
