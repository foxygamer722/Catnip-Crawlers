class Parcela {
  float posX, posY;
  float tamanio;
  Planta planta;
  boolean estaOcupada;

  Parcela(float posX, float posY, float tamanio) {
    this.posX = posX;
    this.posY = posY;
    this.tamanio = tamanio;
    this.estaOcupada = false;
    this.planta = null;
  }

  boolean contener(float px, float py) {
    return px >= posX && px <= posX + tamanio && py >= posY && py <= posY + tamanio;
  }

  boolean plantar(Planta p) {
    if (estaOcupada) return false;
    planta = p;
    estaOcupada = true;
    return true;
  }

  void eliminarPlanta() {
    planta = null;
    estaOcupada = false;
  }

  boolean estaLibre() {
    return !estaOcupada;
  }

  void mostrar() {
    noStroke();
    fill(101, 67, 33);
    rect(posX, posY, tamanio, tamanio, 4);
    stroke(70, 45, 20);
    noFill();
    rect(posX, posY, tamanio, tamanio, 4);
    noStroke();

    if (planta != null) {
      planta.mostrar(posX + tamanio / 2.0, posY + tamanio / 2.0, tamanio);
      if (planta.muerta) {
        eliminarPlanta();
      }
    }
  }
}
