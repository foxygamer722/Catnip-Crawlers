import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

class BaseDatos {

  Connection conexion;
  String url = "jdbc:sqlite:" + sketchPath("catnip_crawlers.db");
 
  boolean conectar() {
    try {
      Class.forName("org.sqlite.JDBC");
      conexion = DriverManager.getConnection(url);

      Statement sentencia = conexion.createStatement();
      sentencia.executeUpdate(
        "CREATE TABLE IF NOT EXISTS puntuaciones (" +
        "id INT PRIMARY KEY AUTOINCREMENT, " +
        "nombre TEXT NOT NULL, " +
        "oleada INT NOT NULL, " +
        "dinero INT NOT NULL, " +
        "puntaje INT NOT NULL)"
      );
      sentencia.close();

      println("Base de datos conectada correctamente.");
      return true;

    } catch (Exception e) {
      println("Error al conectar con SQLite: " + e.getMessage());
      return false;
    }
  }

  boolean guardarPuntuacion(String nombre, int oleada, int dineroTotal) {
    if (conexion == null) {
      return false;
    }

    String nombreFinal = nombre.trim().equals("") ? "Anonimo" : nombre.trim();
    int puntajeTotal = (oleada * 100) + dineroTotal;

    String consulta = "INSERT INTO puntuaciones (nombre, oleada, dinero, puntaje) VALUES (?, ?, ?, ?)";

    try (PreparedStatement sentencia = conexion.prepareStatement(consulta)) {
      sentencia.setString(1, nombreFinal);
      sentencia.setInt(2, oleada);
      sentencia.setInt(3, dineroTotal);
      sentencia.setInt(4, puntajeTotal);

      return sentencia.executeUpdate() > 0;

    } catch (SQLException e) {
      println("Error al guardar la puntuación: " + e.getMessage());
      return false;
    }
  }

  ArrayList<String> obtenerTopPuntuaciones(int limite) {
    ArrayList<String> lista = new ArrayList<String>();

    if (conexion == null) {
      return lista;
    }

    String consulta = "SELECT nombre, oleada, dinero, puntaje FROM puntuaciones ORDER BY puntaje DESC LIMIT ?";

    try (PreparedStatement sentencia = conexion.prepareStatement(consulta)) {
      sentencia.setInt(1, limite);

      try (ResultSet resultado = sentencia.executeQuery()) {
        int puesto = 1;
        while (resultado.next()) {
          String nom = resultado.getString("nombre");
          int ol = resultado.getInt("oleada");
          int din = resultado.getInt("dinero");
          int pts = resultado.getInt("puntaje");

          lista.add("#" + puesto + "  " + nom + " | Oleada " + ol + " | $" + din + " | " + pts + " pts");
          puesto++;
        }
      }
    } catch (SQLException e) {
      println("Error al consultar los récords: " + e.getMessage());
    }

    return lista;
  }
}
