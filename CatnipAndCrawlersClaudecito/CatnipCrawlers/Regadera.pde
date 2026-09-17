class Regadera {
  float anchoArea, altoArea;
  float danio;
  int cooldown;
  int ultimoUso;

  Regadera() {
    anchoArea = 90;
    altoArea = 70;
    danio = 8;
    cooldown = 400;
    ultimoUso = -99999;
  }

  boolean puedeUsarse() {
    return millis() - ultimoUso >= cooldown;
  }

  // Calcula el area rectangular {x, y, w, h} frente al jugador segun su direccion
  float[] calcularArea(float px, float py, int direccion) {
    float ax = px, ay = py, w, h;
    if (direccion == ARRIBA) {
      w = anchoArea; h = altoArea;
      ax = px - w / 2.0; ay = py - h - 18;
    } else if (direccion == ABAJO) {
      w = anchoArea; h = altoArea;
      ax = px - w / 2.0; ay = py + 18;
    } else if (direccion == IZQUIERDA) {
      w = altoArea; h = anchoArea;
      ax = px - w - 18; ay = py - h / 2.0;
    } else {
      w = altoArea; h = anchoArea;
      ax = px + 18; ay = py - h / 2.0;
    }
    return new float[]{ax, ay, w, h};
  }

  boolean dentroDeArea(float x, float y, float[] area) {
    return x >= area[0] && x <= area[0] + area[2] && y >= area[1] && y <= area[1] + area[3];
  }

  void regar(ArrayList<Parcela> parcelas, float[] area) {
    for (Parcela p : parcelas) {
      if (!p.estaLibre()) {
        float cx = p.posX + p.tamanio / 2.0;
        float cy = p.posY + p.tamanio / 2.0;
        if (dentroDeArea(cx, cy, area)) {
          p.planta.regar();
        }
      }
    }
  }

  void atacar(ArrayList<Enemigo> enemigos, float[] area) {
    for (Enemigo e : enemigos) {
      if (dentroDeArea(e.posX, e.posY, area)) {
        e.recibirDanio(danio);
      }
    }
  }

  void usar(float px, float py, int direccion, ArrayList<Parcela> parcelas, ArrayList<Enemigo> enemigos) {
    if (!puedeUsarse()) return;
    float[] area = calcularArea(px, py, direccion);
    regar(parcelas, area);
    atacar(enemigos, area);
    ultimoUso = millis();
  }

  void mostrarArea(float px, float py, int direccion) {
    float[] area = calcularArea(px, py, direccion);
    noStroke();
    color c = puedeUsarse() ? color(100, 180, 255, 70) : color(150, 150, 150, 50);
    fill(c);
    rect(area[0], area[1], area[2], area[3], 6);
  }
}
