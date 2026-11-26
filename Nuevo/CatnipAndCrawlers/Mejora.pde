class Mejora {
  String nombre;
  String descripcion;
  int precio;
  int tipo;
  boolean comprada;

  Mejora(String nombre, String descripcion, int precio, int tipo) {
    this.nombre = nombre;
    this.descripcion = descripcion;
    this.precio = precio;
    this.tipo = tipo;
    this.comprada = false;
  }

  void aplicar(Jugador jugador) {
    comprada = true;
    if (tipo == 0) jugador.velocidad *= 1.3;
    if (tipo == 1) jugador.miRegadera.tamArea *= 1.35;
    if (tipo == 2) jugador.miRegadera.cooldown = max(150, jugador.miRegadera.cooldown - 250);
  }
}
