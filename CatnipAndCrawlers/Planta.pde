class Planta {
  float x, y, tam;
  String nombre, rareza;
  color colorPlanta;
  int estadoCrecimiento; // 0=Semilla, 1=Pequeña, 2=Mediana, 3=Madura
  int vida = 100, vidaMax = 100;
  int ultimoRiego;
  boolean necesitaAgua = false;
  boolean muertaPorSed = false;
  PImage[] spritesEtapa;
  PImage spriteRespaldo;
  PImage spriteSemilla;

  Planta(float x, float y, float tam, Semilla s) {
    this.x = x;
    this.y = y;
    this.tam = tam;
    this.nombre = s.nombre;
    this.rareza = s.rareza;
    this.colorPlanta = s.colorPlanta;
    this.estadoCrecimiento = 0;
    this.ultimoRiego = millis();

    String base = nombre.toLowerCase();
    this.spriteRespaldo = loadImage(base + ".png");
    this.spritesEtapa = new PImage[3];
    this.spriteSemilla = loadImage("semilla.png");
    this.spritesEtapa[0] = loadImage(base + "1.png");
    this.spritesEtapa[1] = loadImage(base + "2.png");
    this.spritesEtapa[2] = loadImage(base + "3.png");
  }

  // Contador de sed.
  void recibirAgua() {
    ultimoRiego = millis();
    necesitaAgua = false;
    if (estadoCrecimiento == 0) {
      estadoCrecimiento = 1;
    }
  }

  void actualizar(boolean enOleada) {
    if (!enOleada) {
      ultimoRiego = millis();
      return;
    }

    if (estadoCrecimiento > 0) {
      int sinAgua = millis() - ultimoRiego;
      if (sinAgua > 7000) necesitaAgua = true;
      if (sinAgua > 15000) muertaPorSed = true;
    }
  }

  int finalizarOleada() {
    vida = vidaMax;
    int dineroGenerado = 0;

    if (estadoCrecimiento > 0 && !necesitaAgua) {
      int base = rareza.equals("Epica") ? 18 : (rareza.equals("Rara") ? 12 : 8);
      dineroGenerado = base * estadoCrecimiento;
      if (estadoCrecimiento < 3) {
        estadoCrecimiento++;
      }
    }
    necesitaAgua = false;
    return dineroGenerado;
  }

  void recibirDano(int d) {
    vida -= d;
  }
  boolean estaMuertaPorEnemigo() {
    return vida <= 0;
  }

  void dibujar() {
    if (estadoCrecimiento == 0) {
      if (spriteSemilla != null) {
        imageMode(CENTER);
        image(spriteSemilla, x + tam/2.0, y + tam/2.0, tam * 0.45, tam * 0.45);
        imageMode(CORNER);
      } else {
        fill(80, 50, 20);
        ellipse(x + tam/2.0, y + tam/2.0, tam * 0.25, tam * 0.35);
      }
    } else {
      float escala = 0.55 + (estadoCrecimiento * 0.15);
      PImage imgActual = spritesEtapa[estadoCrecimiento - 1];
      if (imgActual == null) imgActual = spriteRespaldo;

      if (imgActual != null) {
        imageMode(CENTER);
        image(imgActual, x + tam/2.0, y + tam/2.0, tam * escala, tam * escala);
        imageMode(CORNER);
      } else {
        fill(colorPlanta);
        rect(x + tam*(1-escala)/2.0, y + tam*(1-escala)/2.0, tam * escala, tam * escala, 6);
      }

      if (vida < vidaMax) {
        fill(60);
        noStroke();
        rect(x + tam*0.15, y + tam*0.84, tam*0.7, tam*0.09);
        fill(vida > 40 ? color(50, 220, 50) : color(230, 50, 50));
        rect(x + tam*0.15, y + tam*0.84, (tam*0.7) * (max(0, float(vida))/vidaMax), tam*0.09);
      }

      if (necesitaAgua) {
        fill(255, 20, 20);
        textSize(tam * 0.55);
        textAlign(CENTER, CENTER);
        text("!", x + tam/2.0, y + tam*0.18);
      }
    }
  }
}
