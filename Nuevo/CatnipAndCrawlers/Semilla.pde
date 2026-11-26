class Semilla {
  String nombre;
  String rareza;
  int precio;
  color colorPlanta;
  PImage sprite;

  Semilla(String nombre, String rareza, int precio, color colorPlanta, String rutaSprite) {
    this.nombre = nombre;
    this.rareza = rareza;
    this.precio = precio;
    this.colorPlanta = colorPlanta;
    this.sprite = loadImage(rutaSprite);
  }
}
