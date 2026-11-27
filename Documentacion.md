# Catnip & Crawlers

El jugador es un gato jardinero encargado de cultivar plantas para generar oro, defenderlas de oleadas de insectos y sobrevivir a los cambios climáticos de las estaciones del año.

---

## 1. Arquitectura del Proyecto

| Archivo / Clase | Responsabilidad Principal |
| :--- | :--- |
| `CatnipAndCrawlers.pde` | Punto de entrada (`setup`, `draw`), máquina de estados global (`MENU`, `JUGANDO`, `GAME_OVER`), captura de periféricos y persistencia de récords en CSV. |
| `Juego.pde` | Controlador central de la partida. Coordina el ciclo entre preparación y oleadas, administra el oro, las vidas y dibuja la interfaz (HUD). |
| `Jugador.pde` | Representa al gato controlado por el usuario. Gestiona movimiento direccional, espejado horizontal de sprite y activación de herramienta. |
| `Regadera.pde` | Herramienta multifunción con tiempo de reutilización (*cooldown*). Hidrata plantas y provoca daño en área a los enemigos durante las oleadas. |
| `Jardin.pde` | Administra la grilla bidimensional de parcelas (5 x 3), el conteo de plantas activas y la liquidación de cosechas al finalizar cada oleada. |
| `Parcela.pde` | Celda individual del jardín. Controla su estado (vacía o cultivada) y deja el dibujado y actualización a su planta correspondiente. |
| `Planta.pde` | Modela el ciclo de vida vegetal: estado de semilla (`0`), 3 etapas visuales de crecimiento (`1` a `3`), sistema de sed, barra de daño y generación de oro. |
| `Semilla.pde` | Estructura de datos que define tipo, rareza (`Común`, `Rara`, `Épica`), costo en tienda e ícono gráfico de cada especie. |
| `Inventario.pde` | Almacén rápido de 3 espacios (*slots*) desde donde el jugador arrastra semillas hacia el jardín. |
| `Tienda.pde` | Interfaz de tienda habilitada en fase de preparación. Genera ofertas aleatorias de semillas y mejoras permanentes para el jugador. |
| `Mejora.pde` | Encapsula potenciadores permanentes (`Botas Felinas`, `Boquilla Ancha`, `Tanque Presión`) que modifican atributos del jugador y su regadera. |
| `GestorOleadas.pde` | Controla la aparición progresiva de enemigos por oleada, el desbloqueo de especies y la detección de impacto en área. |
| `Enemigo.pde` | Define el comportamiento de los insectos (búsqueda de la planta más cercana o persecución al gato) y sus estadísticas según especie. |
| `PuntoSpawn.pde` | Coordenadas ubicadas fuera del área visible de la pantalla donde se instancian los enemigos. |
| `GestorEstaciones.pde` | Administra el ciclo climático (`Primavera`, `Verano`, `Otoño`, `Invierno`), sus fondos pre-escalados y los modificadores de velocidad. |

---

## 2. Mecánicas de Juego

### Flujo de Partida
1. **Fase de Preparación:** El juego comienza con $50 y una semilla de *Catnip*. El jugador puede comprar en la tienda, plantar arrastrando semillas desde la barra inferior, hidratar las semillas recién plantadas para hacerlas brotar o quitar plantas excedentes (siempre conservando al menos una). Durante esta fase las plantas no sufren sed.
2. **Fase de Oleada:** Al presionar **INICIAR OLEADA**, los insectos aparecen desde los bordes de la pantalla.
   * Los insectos atacan a la planta más cercana. Si no quedan plantas vivas, persiguen directamente al gato.
   * Cada planta perdida (por daño de insectos o por pasar más de $15\text{ s}$ sin agua tras mostrar la alerta roja `!`) resta **1 vida**. Al perder las **3 vidas**, finaliza la partida.
   * Eliminar insectos otorga oro de forma inmediata.
3. **Fin de Oleada:** Al derrotar a todos los enemigos, las plantas supervivientes recuperan el $100\%$ de su salud, generan oro según su etapa y rareza, y avanzan a la siguiente etapa de crecimiento. Cada 3 oleadas cambia la estación del año.

### Especies y Arquetipos

#### Plantas
* **Catnip (`Común`):** Costo bajo ($15), crecimiento rápido y rendimiento estable.
* **Menta (`Rara`):** Costo intermedio ($25), mayor producción de oro por oleada.
* **Girasol (`Épica`):** Costo elevado ($40), tarda más en madurar pero otorga las mayores recompensas económicas.

#### Insectos
* **Hormiga:** Estadísticas equilibradas (35 HP, muere de 2 riegos).
* **Avispa (desde Oleada 2):** Alta velocidad de desplazamiento (+65), baja resistencia (30 HP) y daño reducido.
* **Escarabajo (desde Oleada 3):** Movimiento lento (-40), alta resistencia (90 HP, requiere 5 riegos) y daño elevado.

---

## 3. Controles

| Acción | Entrada |
| :--- | :--- |
| **Mover al gato** | Teclas `W`, `A`, `S`, `D` o `Flechas direccionales` |
| **Plantar semilla** | Mantener `Clic Izquierdo` sobre un espacio del inventario y soltar sobre una parcela vacía |
| **Regar / Atacar insectos** | `Clic Izquierdo` sobre el jardín (actúa frente a la dirección a la que mira el gato) |
| **Quitar planta (Preparación)** | `Clic Derecho` sobre una parcela ocupada |
| **Iniciar / Guardar récord** | Tecla `ENTER` |

---

## 4. Persistencia de Datos (Base de Datos Local)

El historial de puntuaciones se almacena de forma persistente mediante la clase nativa `Table` de Processing en el archivo `data/puntuaciones.csv`.

* **Esquema de la tabla:** `nombre` (String), `oleada` (Int), `dinero` (Int), `puntaje` (Int).
* **Cálculo de puntaje:**
  Puntaje Total = (Oleada Alcanzada x 100) + Oro Total Generado
* Al finalizar la partida (`GAME_OVER`), el sistema lee el nombre ingresado por teclado, inserta el registro, ordena la tabla de forma descendente por puntaje y actualiza el Top 6 visible en el menú principal.

---

## 5. Estructura de Recursos (`data/`)

Todos los recursos gráficos y de datos deben alojarse dentro de la carpeta `data/` en la raíz del sketch. El motor cuenta con figuras geométricas de respaldo en caso de ausencia de algún archivo.

* **Personaje y Herramientas:** `gato.png`, `semilla.png`
* **Enemigos:** `hormiga.png`, `avispa.png`, `escarabajo.png`
* **Plantas (Íconos y Etapas 1 a 3):**
  * `catnip.png`, `catnip1.png`, `catnip2.png`, `catnip3.png`
  * `menta.png`, `menta1.png`, `menta2.png`, `menta3.png`
  * `girasol.png`, `girasol1.png`, `girasol2.png`, `girasol3.png`
* **Base de Datos:** `puntuaciones.csv`
* **Escenarios:** `fondo_primavera.png`, `fondo_verano.png`, `fondo_otono.png`, `fondo_invierno.png`, `fondo_menu.png`

(Los 4 primeros fondos corresponden a las 4 estaciones posibles, el último es el fondo que aparece en el menú inicial).
