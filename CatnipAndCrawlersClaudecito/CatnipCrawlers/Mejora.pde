// Clase auxiliar NO incluida en el diseno original, agregada solo para que
// Tienda.mejorasDispo / comprarMejora() tengan un objeto concreto con el que trabajar.
class Mejora {
  String nombre;
  String descripcion;
  float precio;
  String tipoEfecto;

  Mejora(String nombre, String descripcion, float precio, String tipoEfecto) {
    this.nombre = nombre;
    this.descripcion = descripcion;
    this.precio = precio;
    this.tipoEfecto = tipoEfecto;
  }

  void aplicar(Jugador j, Inventario inv) {
    if (tipoEfecto.equals("velocidad")) {
      j.velocidad += 0.6;
    } else if (tipoEfecto.equals("danio")) {
      j.regadera.danio += 4;
    } else if (tipoEfecto.equals("cooldown")) {
      j.regadera.cooldown = max(100, j.regadera.cooldown - 60);
    } else if (tipoEfecto.equals("area")) {
      j.regadera.anchoArea += 20;
      j.regadera.altoArea += 15;
    } else if (tipoEfecto.equals("capacidad")) {
      inv.capacidad += 3;
    }
  }

  void mostrar(float x, float y, float w, float h) {
    noStroke();
    fill(220, 230, 255);
    rect(x, y, w, h, 6);
    fill(0);
    textSize(11);
    textAlign(LEFT);
    text(nombre, x + 6, y + 14);
    textSize(9);
    text(descripcion, x + 6, y + 28, w - 12, h - 30);
    textAlign(RIGHT);
    textSize(10);
    text("$" + int(precio), x + w - 6, y + 14);
    textAlign(LEFT);
  }
}
