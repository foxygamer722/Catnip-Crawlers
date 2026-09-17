class GestorEstaciones {
  int estacionActual;
  int estacionAnterior;

  // Modificadores aplicados al resto del juego segun la estacion
  float modCrecimiento;
  float modVelocidadEnemigos;

  GestorEstaciones() {
    estacionActual = PRIMAVERA;
    estacionAnterior = INVIERNO;
    aplicarModificadores();
  }

  void cambiarEstacion() {
    estacionAnterior = estacionActual;
    estacionActual = selecNuevaEstacion();
    aplicarModificadores();
  }

  int selecNuevaEstacion() {
    return (estacionActual + 1) % 4;
  }

  void aplicarModificadores() {
    if (estacionActual == PRIMAVERA) {
      modCrecimiento = 1.2;
      modVelocidadEnemigos = 1.0;
    } else if (estacionActual == VERANO) {
      modCrecimiento = 1.0;
      modVelocidadEnemigos = 1.1;
    } else if (estacionActual == OTONO) {
      modCrecimiento = 0.9;
      modVelocidadEnemigos = 1.0;
    } else {
      modCrecimiento = 0.6;
      modVelocidadEnemigos = 0.85;
    }
  }
}
