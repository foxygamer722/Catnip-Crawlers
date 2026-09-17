class Planta {
  String nombre;
  String tipo;
  int rareza;
  float vida;
  float hidratacion;
  float tiempoCrecimiento;
  float dineroGenerado;
  int estado;

  // Auxiliar interno: indica que la planta debe ser removida de su parcela
  boolean muerta = false;
  float vidaMaxima;

  Planta(String nombre, String tipo, int rareza, float vidaMax, float dineroGenerado, float tiempoCrecimientoInicial) {
    this.nombre = nombre;
    this.tipo = tipo;
    this.rareza = rareza;
    this.vida = vidaMax;
    this.vidaMaxima = vidaMax;
    this.hidratacion = 55;
    this.tiempoCrecimiento = tiempoCrecimientoInicial;
    this.dineroGenerado = dineroGenerado;
    this.estado = CRECIENDO;
  }

  void actualizar() {
    if (estado == CRECIENDO) {
      if (hidratacion > 0) {
        crecer();
        hidratacion -= 0.08;
      } else {
        recibirDanio(0.06);
      }
    } else if (estado == MADURA) {
      hidratacion -= 0.03;
      if (hidratacion <= 0) {
        recibirDanio(0.06);
      }
      // tiempoCrecimiento se reutiliza aqui como cuenta regresiva
      // para la proxima generacion de dinero
      if (tiempoCrecimiento > 0) tiempoCrecimiento -= 1;
    }
  }

  void regar() {
    hidratacion = min(100, hidratacion + 35);
  }

  void crecer() {
    tiempoCrecimiento -= 1;
    if (tiempoCrecimiento <= 0) {
      estado = MADURA;
      tiempoCrecimiento = 240; // cuenta regresiva para generar dinero
    }
  }

  void recibirDanio(float cantidad) {
    vida -= cantidad;
    if (vida <= 0) morir();
  }

  void morir() {
    estado = MARCHITA;
    muerta = true;
  }

  float generarDinero() {
    if (estado == MADURA && tiempoCrecimiento <= 0) {
      tiempoCrecimiento = 240;
      return dineroGenerado;
    }
    return 0;
  }

  void mostrar(float x, float y, float tam) {
    noStroke();
    color base = color(60, 160, 60);
    if (rareza == RARA)            base = color(60, 120, 200);
    else if (rareza == EPICA)      base = color(160, 60, 200);
    else if (rareza == LEGENDARIA) base = color(230, 180, 30);

    if (estado == CRECIENDO) {
      float progreso = constrain(1 - (tiempoCrecimiento / 240.0), 0.05, 1);
      fill(90, 60, 30);
      ellipse(x, y + tam * 0.25, tam * 0.45, tam * 0.22);
      fill(base);
      ellipse(x, y, tam * 0.35 * progreso, tam * 0.35 * progreso);
    } else if (estado == MADURA) {
      fill(base);
      ellipse(x, y, tam * 0.62, tam * 0.62);
      fill(255, 255, 255, 110);
      ellipse(x - tam * 0.12, y - tam * 0.12, tam * 0.16, tam * 0.16);
    } else if (estado == MARCHITA) {
      fill(120, 100, 70);
      ellipse(x, y, tam * 0.4, tam * 0.4);
      stroke(80, 60, 40);
      line(x - tam * 0.2, y - tam * 0.2, x + tam * 0.2, y + tam * 0.2);
      noStroke();
    }
  }
}
