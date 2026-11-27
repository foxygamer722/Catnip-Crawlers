class Enemigo {
  float x, y, tam;
  float velocidad;
  int vida, vidaMax;
  int dano;
  int recompensaOro;
  int ultimoAtaque;
  int intervaloAtaque = 1200;
  int tipo;
  PImage sprite;
  
  Parcela objetivo;

  Enemigo(float x, float y, int nivelOleada, float multVelocidadEstacion, int tipo) {
    this.x = x; this.y = y; this.tipo = tipo;
    float baseVel = min(width, height) * 0.0022 + (nivelOleada * 0.12);

    if (tipo == 1) {                                   // AVISPA
      this.tam = min(width, height) * 0.04;
      this.vidaMax = 30;
      this.velocidad = (baseVel * 1.65) * multVelocidadEstacion;
      this.dano = 5 + nivelOleada;
      this.recompensaOro = 6 + nivelOleada;
      this.sprite = loadImage("avispa.png");
    } 
    else if (tipo == 2) {                              // ESCARABAJO
      this.tam = min(width, height) * 0.058;
      this.vidaMax = 90;
      this.velocidad = (baseVel * 0.6) * multVelocidadEstacion;
      this.dano = 10 + (nivelOleada * 2);
      this.recompensaOro = 12 + (nivelOleada * 2);
      this.sprite = loadImage("escarabajo.png");
    } 
    else {                                             // HORMIGA
      this.tam = min(width, height) * 0.045;
      this.vidaMax = 35;
      this.velocidad = baseVel * multVelocidadEstacion;
      this.dano = 10 + (nivelOleada * 2);
      this.recompensaOro = 5 + nivelOleada;
      this.sprite = loadImage("hormiga.png");
    }
    this.vida = vidaMax;
  }

  // Busca un objetivo, se acerca y ataca plantas o al jugador.
  void actualizar(Jardin jardin, Jugador jugador, Juego juego) {
    if (objetivo == null || objetivo.miPlanta == null) {
      objetivo = buscarPlantaCercana(jardin);
    }

    if (objetivo != null && objetivo.miPlanta != null) {
      float objX = objetivo.x + objetivo.tam / 2.0;
      float objY = objetivo.y + objetivo.tam / 2.0;
      float d = dist(x, y, objX, objY);

      if (d > objetivo.tam * 0.4) {
        float angulo = atan2(objY - y, objX - x);
        x += cos(angulo) * velocidad;
        y += sin(angulo) * velocidad;
      } else if (millis() - ultimoAtaque >= intervaloAtaque) {
        objetivo.miPlanta.recibirDano(dano);
        ultimoAtaque = millis();
      }
    } else {
      float d = dist(x, y, jugador.x, jugador.y);
      if (d > (tam + jugador.tam) * 0.45) {
        float angulo = atan2(jugador.y - y, jugador.x - x);
        x += cos(angulo) * (velocidad * 1.15);
        y += sin(angulo) * (velocidad * 1.15);
      } else {
        vida = 0;
        juego.registrarPerdidaVida();
      }
    }
  }

  // Encuentra la planta mas cercana
  Parcela buscarPlantaCercana(Jardin jardin) {
    Parcela masCercana = null;
    float menorDist = 999999;
    for (int i = 0; i < jardin.columnas; i++) {
      for (int j = 0; j < jardin.filas; j++) {
        if (jardin.grilla[i][j].miPlanta != null) {
          float cx = jardin.grilla[i][j].x + jardin.grilla[i][j].tam / 2.0;
          float cy = jardin.grilla[i][j].y + jardin.grilla[i][j].tam / 2.0;
          float d = dist(x, y, cx, cy);
          if (d < menorDist) { menorDist = d; masCercana = jardin.grilla[i][j]; }
        }
      }
    }
    return masCercana;
  }

  void recibirDano(int cantidad) { vida -= cantidad; }
  boolean estaMuerto() { return vida <= 0; }

  void dibujar() {
    if (sprite != null) {
      imageMode(CENTER);
      image(sprite, x, y, tam, tam);
      imageMode(CORNER);
    } else {                        // En caso de que nos funcione mal una imagen
      if (tipo == 1) fill(230, 200, 30);
      else if (tipo == 2) fill(90, 50, 140);
      else fill(180, 40, 40);
      stroke(0);
      ellipse(x, y, tam, tam);
    }
    fill(255, 0, 0);
    rect(x - tam/2, y - tam*0.7, tam * (max(0, float(vida))/vidaMax), height * 0.008);
  }
}
