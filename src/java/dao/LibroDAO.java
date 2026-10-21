package dao;

import beans.Libro;
import conexion.Conexion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class LibroDAO {

    private static List<Libro> libros = new ArrayList<>();
    private static int contadorId = 1;

    static {
        libros.add(new Libro(
                contadorId++,
                "Cien años de soledad",
                "9780307474728",
                1967,
                "Novela cumbre del realismo mágico escrita por el colombiano Gabriel García Márquez.",
                5,
                1,
                "Gabriel García Márquez",
                1,
                "Novela"
        ));

        libros.add(new Libro(
                contadorId++,
                "Don Quijote de la Mancha",
                "9788420412146",
                1605,
                "Obra clásica universal de la literatura española escrita por Miguel de Cervantes.",
                3,
                2,
                "Miguel de Cervantes",
                1,
                "Novela"
        ));

        libros.add(new Libro(
                contadorId++,
                "El Principito",
                "9780156012195",
                1943,
                "Obra literaria y filosófica de Antoine de Saint-Exupéry sobre la amistad y el sentido de la vida.",
                7,
                3,
                "Antoine de Saint-Exupéry",
                1,
                "Novela"
        ));

        libros.add(new Libro(
                contadorId++,
                "Clean Code: Manual de desarrollo ágil de software",
                "9780132350884",
                2008,
                "Principios, patrones y buenas prácticas para escribir código limpio y mantenible.",
                4,
                4,
                "Robert C. Martin",
                2,
                "Programación"
        ));

        libros.add(new Libro(
                contadorId++,
                "La Cuarta Revolución Industrial y la Innovación Sostenible (ODS 09)",
                "9788499926995",
                2020,
                "Análisis sobre cómo la transformación digital, la industria 4.0 y la innovación impulsan el Objetivo de Desarrollo Sostenible 9.",
                6,
                5,
                "Klaus Schwab",
                4,
                "ODS 09 - Innovación e Infraestructura"
        ));

        libros.add(new Libro(
                contadorId++,
                "Infraestructura Resiliente e Industrialización Inclusiva - Agenda 2030 (ODS 09)",
                "9789211219876",
                2023,
                "Guía académica sobre conectividades digitales universitarias, investigación científica e infraestructura sostenible en América Latina.",
                5,
                6,
                "ONU Hábitat / CEPAL",
                4,
                "ODS 09 - Innovación e Infraestructura"
        ));
    }

    // ============================
    // LISTAR
    // ============================

    public List<Libro> listar() {
        String sql = "SELECT l.id_libro, l.titulo, l.isbn, l.anio, l.descripcion, l.stock, "
                + "l.id_autor, COALESCE(a.nombre, 'Autor General') AS nombre_autor, "
                + "l.id_categoria, COALESCE(c.nombre, 'General') AS nombre_categoria "
                + "FROM libros l "
                + "LEFT JOIN autores a ON l.id_autor = a.id_autor "
                + "LEFT JOIN categorias c ON l.id_categoria = c.id_categoria "
                + "ORDER BY l.id_libro ASC";

        try (Connection con = Conexion.conectar()) {
            if (con != null) {
                try (PreparedStatement ps = con.prepareStatement(sql);
                     ResultSet rs = ps.executeQuery()) {
                    List<Libro> listaBD = new ArrayList<>();
                    while (rs.next()) {
                        listaBD.add(new Libro(
                                rs.getInt("id_libro"),
                                rs.getString("titulo"),
                                rs.getString("isbn"),
                                rs.getInt("anio"),
                                rs.getString("descripcion"),
                                rs.getInt("stock"),
                                rs.getInt("id_autor"),
                                rs.getString("nombre_autor"),
                                rs.getInt("id_categoria"),
                                rs.getString("nombre_categoria")
                        ));
                    }
                    if (!listaBD.isEmpty()) {
                        return listaBD;
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Usando datos en memoria para LibroDAO: " + e.getMessage());
        }

        return libros;
    }

    // ============================
    // OBTENER POR ID
    // ============================

    public Libro obtenerPorId(int id) {
        String sql = "SELECT l.id_libro, l.titulo, l.isbn, l.anio, l.descripcion, l.stock, "
                + "l.id_autor, COALESCE(a.nombre, 'Autor General') AS nombre_autor, "
                + "l.id_categoria, COALESCE(c.nombre, 'General') AS nombre_categoria "
                + "FROM libros l "
                + "LEFT JOIN autores a ON l.id_autor = a.id_autor "
                + "LEFT JOIN categorias c ON l.id_categoria = c.id_categoria "
                + "WHERE l.id_libro = ?";

        try (Connection con = Conexion.conectar()) {
            if (con != null) {
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, id);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            return new Libro(
                                    rs.getInt("id_libro"),
                                    rs.getString("titulo"),
                                    rs.getString("isbn"),
                                    rs.getInt("anio"),
                                    rs.getString("descripcion"),
                                    rs.getInt("stock"),
                                    rs.getInt("id_autor"),
                                    rs.getString("nombre_autor"),
                                    rs.getInt("id_categoria"),
                                    rs.getString("nombre_categoria")
                            );
                        }
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Error obtenerPorId LibroDAO: " + e.getMessage());
        }

        for (Libro libro : libros) {
            if (libro.getIdLibro() == id) {
                return libro;
            }
        }
        return null;
    }

    // ============================
    // BUSCAR / FILTRAR CATÁLOGO
    // ============================

    public List<Libro> buscar(String termino, String categoriaFiltro) {
        List<Libro> base = listar();
        List<Libro> resultado = new ArrayList<>();

        String q = (termino != null) ? termino.trim().toLowerCase() : "";
        String cat = (categoriaFiltro != null) ? categoriaFiltro.trim().toLowerCase() : "";

        for (Libro libro : base) {
            boolean coincideTexto = q.isEmpty()
                    || (libro.getTitulo() != null && libro.getTitulo().toLowerCase().contains(q))
                    || (libro.getNombreAutor() != null && libro.getNombreAutor().toLowerCase().contains(q))
                    || (libro.getNombreCategoria() != null && libro.getNombreCategoria().toLowerCase().contains(q))
                    || (libro.getIsbn() != null && libro.getIsbn().toLowerCase().contains(q))
                    || (libro.getDescripcion() != null && libro.getDescripcion().toLowerCase().contains(q));

            boolean coincideCategoria = cat.isEmpty()
                    || "todas".equals(cat)
                    || (libro.getNombreCategoria() != null && libro.getNombreCategoria().toLowerCase().contains(cat));

            if (coincideTexto && coincideCategoria) {
                resultado.add(libro);
            }
        }
        return resultado;
    }

    // ============================
    // AGREGAR
    // ============================

    public void agregar(Libro libro) {
        if (libro.getNombreAutor() == null || libro.getNombreAutor().isEmpty()) {
            libro.setNombreAutor("Autor General");
        }
        if (libro.getNombreCategoria() == null || libro.getNombreCategoria().isEmpty()) {
            libro.setNombreCategoria("General");
        }

        String sql = "INSERT INTO libros (titulo, isbn, anio, descripcion, stock, id_autor, id_categoria) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = Conexion.conectar()) {
            if (con != null) {
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setString(1, libro.getTitulo());
                    ps.setString(2, libro.getIsbn());
                    ps.setInt(3, libro.getAnio());
                    ps.setString(4, libro.getDescripcion());
                    ps.setInt(5, libro.getStock());
                    ps.setInt(6, libro.getIdAutor() > 0 ? libro.getIdAutor() : 1);
                    ps.setInt(7, libro.getIdCategoria() > 0 ? libro.getIdCategoria() : 1);
                    ps.executeUpdate();
                }
            }
        } catch (SQLException e) {
            System.out.println("Error agregar LibroDAO: " + e.getMessage());
        }

        libro.setIdLibro(contadorId++);
        libros.add(libro);
    }

    // ============================
    // ACTUALIZAR
    // ============================

    public void actualizar(Libro libro) {
        String sql = "UPDATE libros SET titulo = ?, isbn = ?, anio = ?, descripcion = ?, stock = ? WHERE id_libro = ?";
        try (Connection con = Conexion.conectar()) {
            if (con != null) {
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setString(1, libro.getTitulo());
                    ps.setString(2, libro.getIsbn());
                    ps.setInt(3, libro.getAnio());
                    ps.setString(4, libro.getDescripcion());
                    ps.setInt(5, libro.getStock());
                    ps.setInt(6, libro.getIdLibro());
                    ps.executeUpdate();
                }
            }
        } catch (SQLException e) {
            System.out.println("Error actualizar LibroDAO: " + e.getMessage());
        }

        for (int i = 0; i < libros.size(); i++) {
            if (libros.get(i).getIdLibro() == libro.getIdLibro()) {
                Libro actual = libros.get(i);
                if (libro.getNombreAutor() == null || libro.getNombreAutor().isEmpty()) {
                    libro.setIdAutor(actual.getIdAutor());
                    libro.setNombreAutor(actual.getNombreAutor());
                }
                if (libro.getNombreCategoria() == null || libro.getNombreCategoria().isEmpty()) {
                    libro.setIdCategoria(actual.getIdCategoria());
                    libro.setNombreCategoria(actual.getNombreCategoria());
                }
                libros.set(i, libro);
                break;
            }
        }
    }

    // ============================
    // ELIMINAR
    // ============================

    public void eliminar(int id) {
        String sql = "DELETE FROM libros WHERE id_libro = ?";
        try (Connection con = Conexion.conectar()) {
            if (con != null) {
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setInt(1, id);
                    ps.executeUpdate();
                }
            }
        } catch (SQLException e) {
            System.out.println("Error eliminar LibroDAO: " + e.getMessage());
        }

        libros.removeIf(libro -> libro.getIdLibro() == id);
    }
}
