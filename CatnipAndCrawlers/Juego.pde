class Juego {
  Jugador jugador;
  Jardin jardin;
  int tiempoInicioOleada;
  boolean enOleada;
  boolean arrastrandoSemilla = false;
  String semillaSeleccionada = "";
  color colorSemillaSeleccionada;
  float semillaX, semillaY; // Para dibujar la semilla en el puntero mientras arrastramos

  Juego() {
    jugador = new Jugador();
    jardin = new Jardin();
  }

  void iniciarPartida() {
    jugador.x = width/2;
    jugador.y = height/2;
    enOleada = true;
    tiempoInicioOleada = millis(); // Capturamos el tiempo de inicio
  }

  void actualizar() {
    jugador.actualizar();

    // Ejemplo de uso de millis() para controlar tiempos sin delay()
    if (enOleada) {
      int tiempoTranscurrido = millis() - tiempoInicioOleada;
      if (tiempoTranscurrido > 10000) { // 10 segundos de oleada de prueba
        enOleada = false;
        // Acá se abriría la tienda
      }
    }
  }

  void manejarMousePresionado(float mx, float my) {

    // Dimensiones relativas de la barra de semillas (Abajo al centro)
    float slotAncho = width * 0.08;
    float slotAlto = height * 0.09;
    float slotSeparacion = width * 0.015;

    float anchoTotalMenu = (3 * slotAncho) + (2 * slotSeparacion);
    float menuX = (width - anchoTotalMenu) / 2.0;
    float menuY = height - slotAlto - (height * 0.03); // Margen inferior del 3%

    // Verificamos si hizo clic dentro de la franja vertical del menú
    if (my >= menuY && my <= menuY + slotAlto) {
      // Slot 1: Catnip
      float x1 = menuX;
      if (mx >= x1 && mx <= x1 + slotAncho) {
        arrastrandoSemilla = true;
        semillaSeleccionada = "Catnip";
        colorSemillaSeleccionada = color(100, 255, 100);
      }
      
      // Slot 2: Menta
      float x2 = menuX + slotAncho + slotSeparacion;
      if (mx >= x2 && mx <= x2 + slotAncho) {
        arrastrandoSemilla = true;
        semillaSeleccionada = "Menta";
        colorSemillaSeleccionada = color(0, 180, 120);
      }
      
      // Slot 3: Girasol
      float x3 = menuX + (2 * (slotAncho + slotSeparacion));
      if (mx >= x3 && mx <= x3 + slotAncho) {
        arrastrandoSemilla = true;
        semillaSeleccionada = "Girasol";
        colorSemillaSeleccionada = color(255, 200, 0);
      }
    } else {
      // Clic fuera del menú → Usar la regadera
      jugador.usarHerramienta(jardin); 
    }
  }

  void manejarMouseSoltado(float mx, float my) {
    // Si soltamos el clic y teníamos una semilla en la mano, intentamos plantarla
    if (arrastrandoSemilla) {
      jardin.intentarPlantar(mx, my, semillaSeleccionada, colorSemillaSeleccionada); // Le mandamos las coordenadas al jardín
      arrastrandoSemilla = false;     // Soltamos la semilla, pase lo que pase
    }
  }

  void dibujar() {
    background(100, 200, 100); // Color temporal del pasto

    jardin.dibujar();
    jugador.dibujar();

// --- DIBUJAR MENÚ ABAJO AL CENTRO ---
    float slotAncho = width * 0.08;
    float slotAlto = height * 0.09;
    float slotSeparacion = width * 0.015;
    
    float anchoTotalMenu = (3 * slotAncho) + (2 * slotSeparacion);
    float menuX = (width - anchoTotalMenu) / 2.0;
    float menuY = height - slotAlto - (height * 0.03);

    stroke(0);
    strokeWeight(max(1, height * 0.002));
    
    // Slot 1: Catnip
    fill(100, 255, 100); 
    rect(menuX, menuY, slotAncho, slotAlto, 8);
    fill(0); textSize(height * 0.018); textAlign(CENTER, CENTER); 
    text("Catnip", menuX + slotAncho/2.0, menuY + slotAlto/2.0);
    
    // Slot 2: Menta
    fill(0, 180, 120); 
    rect(menuX + slotAncho + slotSeparacion, menuY, slotAncho, slotAlto, 8);
    fill(255); textSize(height * 0.018); textAlign(CENTER, CENTER); 
    text("Menta", menuX + slotAncho + slotSeparacion + slotAncho/2.0, menuY + slotAlto/2.0);
    
    // Slot 3: Girasol
    fill(255, 200, 0); 
    rect(menuX + 2 * (slotAncho + slotSeparacion), menuY, slotAncho, slotAlto, 8);
    fill(0); textSize(height * 0.018); textAlign(CENTER, CENTER); 
    text("Girasol", menuX + 2 * (slotAncho + slotSeparacion) + slotAncho/2.0, menuY + slotAlto/2.0);

    // Semilla flotante al arrastrar
    if (arrastrandoSemilla) {
      fill(colorSemillaSeleccionada);
      stroke(0);
      ellipse(mouseX, mouseY, width * 0.025, width * 0.025);
    }
    
    // --- INTERFAZ SUPERIOR (Tiempo) ---
    fill(0);
    textSize(height * 0.025);
    textAlign(LEFT, TOP);
    if (enOleada) {
      text("Estado: OLEADA (Faltan " + (10 - (millis()-tiempoInicioOleada)/1000) + "s)", width * 0.02, height * 0.02);
    } else {
      text("Estado: PREPARACIÓN", width * 0.02, height * 0.02);
    }
  }
}
