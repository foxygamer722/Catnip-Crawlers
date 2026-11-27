class Mejora {
  String nombre;
  String descripcion;
  int precio;
  int tipo;
  int nivel;

  Mejora(String nombre, String descripcion, int precio, int tipo) {
    this.nombre = nombre;
    this.descripcion = descripcion;
    this.precio = precio;
    this.tipo = tipo;
    this.nivel = 0;
  }

  void aplicar(Juego juego) {
    nivel++;
    Jugador jugador = juego.jugador;

    if (tipo == 0) jugador.velocidad *= 1.25;
    if (tipo == 1) jugador.miRegadera.tamArea *= 1.3;
    if (tipo == 2) jugador.miRegadera.cooldown = max(120, jugador.miRegadera.cooldown - 150);
    if (tipo == 3) jugador.miRegadera.danoEnemigos += 10;
    if (tipo == 4) juego.multCosecha += 0.2;
    if (tipo == 5) {
      juego.bonusVidaPlanta += 35;
      for (int i = 0; i < juego.jardin.columnas; i++) {
        for (int j = 0; j < juego.jardin.filas; j++) {
          Planta p = juego.jardin.grilla[i][j].miPlanta;
          if (p != null) {
            p.vidaMax += 35;
            p.vida += 35;
          }
        }
      }
    }

    precio = int(ceil((precio * 1.45) / 5.0)) * 5;
  }
}
