class Inventario {
  Semilla[] slots;
  int capacidad = 3;

  Inventario() {
    slots = new Semilla[capacidad];
  }

  boolean agregarSemilla(Semilla s) {
    for (int i = 0; i < capacidad; i++) {
      if (slots[i] == null) {
        slots[i] = s;
        return true;
      }
    }
    return false;
  }

  Semilla obtenerSemilla(int indice) {
    if (indice >= 0 && indice < capacidad) return slots[indice];
    return null;
  }

  void consumirSemilla(int indice) {
    if (indice >= 0 && indice < capacidad) slots[indice] = null;
  }
}
