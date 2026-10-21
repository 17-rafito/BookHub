<%@page import="java.util.List"%>
<%@page import="beans.Libro"%>
<%@page import="beans.Autor"%>
<%@page import="beans.Categoria"%>
<%@page import="dao.AutorDAO"%>
<%@page import="dao.CategoriaDAO"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    AutorDAO autorDAO = new AutorDAO();
    CategoriaDAO categoriaDAO = new CategoriaDAO();
    List<Autor> listaAutores = autorDAO.listar();
    List<Categoria> listaCategorias = categoriaDAO.listar();
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <title>Gestión de Libros - BOOKHUB</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
              rel="stylesheet">
    </head>

    <body class="bg-light">


        <!-- ==================== NAVBAR ==================== -->

        <nav class="navbar navbar-dark bg-dark">

            <div class="container">

                <a class="navbar-brand fw-bold" href="dashboard.jsp">
                    BOOKHUB
                </a>

                <a href="dashboard.jsp" class="btn btn-outline-light">
                    Volver al Dashboard
                </a>

            </div>

        </nav>



        <!-- ==================== CONTENIDO ==================== -->

        <div class="container mt-5">


            <!-- TÍTULO -->

            <div class="mb-4">

                <h1>Gestión de Libros</h1>

                <p class="text-muted">
                    Administra el catálogo de libros de la biblioteca.
                </p>

            </div>



            <!-- ==================== DETERMINAR SI ESTAMOS EDITANDO ==================== -->

            <%
                Libro libroEditar = (Libro) request.getAttribute("libroEditar");

                boolean editando = libroEditar != null;
            %>



            <!-- ==================== FORMULARIO ==================== -->

            <div class="card shadow-sm mb-5">


                <div class="card-header bg-primary text-white">

                    <h5 class="mb-0">

                        <%= editando ? "Editar libro" : "Agregar nuevo libro"%>

                    </h5>

                </div>



                <div class="card-body">


                    <form action="LibroServlet" method="POST">


                        <!-- Si estamos editando -->

                        <% if (editando) {%>

                        <input type="hidden"
                               name="accion"
                               value="actualizar">

                        <input type="hidden"
                               name="id"
                               value="<%= libroEditar.getIdLibro()%>">

                        <% }%>



                        <div class="row">


                            <!-- TÍTULO -->

                            <div class="col-md-6 mb-3">

                                <label class="form-label">
                                    Título
                                </label>

                                <input type="text"
                                       name="titulo"
                                       class="form-control"
                                       value="<%= editando ? libroEditar.getTitulo() : ""%>"
                                       required>

                            </div>



                            <!-- ISBN -->

                            <div class="col-md-6 mb-3">

                                <label class="form-label">
                                    ISBN
                                </label>

                                <input type="text"
                                       name="isbn"
                                       class="form-control"
                                       value="<%= editando ? libroEditar.getIsbn() : ""%>"
                                       required>

                            </div>


                            <!-- AUTOR -->

                            <div class="col-md-6 mb-3">

                                <label class="form-label">
                                    Autor
                                </label>

                                <select name="idAutor" class="form-select" required>
                                    <% for (Autor a : listaAutores) {
                                           boolean sel = editando && libroEditar.getIdAutor() == a.getIdAutor();
                                    %>
                                        <option value="<%= a.getIdAutor() %>" <%= sel ? "selected" : "" %>>
                                            <%= a.getNombre() %>
                                        </option>
                                    <% } %>
                                </select>

                            </div>


                            <!-- CATEGORÍA -->

                            <div class="col-md-6 mb-3">

                                <label class="form-label">
                                    Categoría
                                </label>

                                <select name="idCategoria" class="form-select" required>
                                    <% for (Categoria c : listaCategorias) {
                                           boolean sel = editando && libroEditar.getIdCategoria() == c.getIdCategoria();
                                    %>
                                        <option value="<%= c.getIdCategoria() %>" <%= sel ? "selected" : "" %>>
                                            <%= c.getNombre() %>
                                        </option>
                                    <% } %>
                                </select>

                            </div>



                            <!-- AÑO -->

                            <div class="col-md-4 mb-3">

                                <label class="form-label">
                                    Año
                                </label>

                                <input type="number"
                                       name="anio"
                                       class="form-control"
                                       value="<%= editando ? libroEditar.getAnio() : ""%>"
                                       required>

                            </div>



                            <!-- STOCK -->

                            <div class="col-md-4 mb-3">

                                <label class="form-label">
                                    Stock
                                </label>

                                <input type="number"
                                       name="stock"
                                       class="form-control"
                                       min="0"
                                       value="<%= editando ? libroEditar.getStock() : ""%>"
                                       required>

                            </div>



                            <!-- DESCRIPCIÓN -->

                            <div class="col-md-12 mb-3">

                                <label class="form-label">
                                    Descripción
                                </label>

                                <textarea name="descripcion"
                                          class="form-control"
                                          rows="3"
                                          required><%= editando ? libroEditar.getDescripcion() : ""%></textarea>

                            </div>


                        </div>



                        <!-- BOTONES -->

                        <button type="submit" class="btn btn-primary">

                            <%= editando ? "Guardar cambios" : "+ Agregar libro"%>

                        </button>



                        <% if (editando) { %>

                        <a href="LibroServlet"
                           class="btn btn-secondary">

                            Cancelar

                        </a>

                        <% } %>


                    </form>


                </div>

            </div>



            <!-- ==================== TABLA DE LIBROS ==================== -->

            <div class="card shadow-sm">


                <div class="card-header">

                    <h5 class="mb-0">
                        Libros registrados
                    </h5>

                </div>



                <div class="card-body">


                    <div class="table-responsive">


                        <table class="table table-hover align-middle">


                            <!-- ENCABEZADO -->

                            <thead class="table-dark">

                                <tr>

                                    <th>ID</th>

                                    <th>Título</th>

                                    <th>Autor</th>

                                    <th>Categoría</th>

                                    <th>ISBN</th>

                                    <th>Año</th>

                                    <th>Stock</th>

                                    <th>Acciones</th>

                                </tr>

                            </thead>



                            <!-- CUERPO -->

                            <tbody>


                                <%

                                    List<Libro> libros
                                            = (List<Libro>) request.getAttribute("libros");

                                    if (libros != null && !libros.isEmpty()) {

                                        for (Libro libro : libros) {

                                %>


                                <tr>


                                    <!-- ID -->

                                    <td>

                                        <%= libro.getIdLibro()%>

                                    </td>



                                    <!-- TÍTULO -->

                                    <td>

                                        <strong>

                                            <%= libro.getTitulo()%>

                                        </strong>

                                    </td>


                                    <!-- AUTOR -->

                                    <td>
                                        <%= libro.getNombreAutor() %>
                                    </td>


                                    <!-- CATEGORÍA -->

                                    <td>
                                        <span class="badge bg-secondary">
                                            <%= libro.getNombreCategoria() %>
                                        </span>
                                    </td>



                                    <!-- ISBN -->

                                    <td>

                                        <%= libro.getIsbn()%>

                                    </td>



                                    <!-- AÑO -->

                                    <td>

                                        <%= libro.getAnio()%>

                                    </td>



                                    <!-- STOCK -->

                                    <td>


                                        <% if (libro.getStock() > 0) {%>


                                        <span class="badge bg-success">

                                            <%= libro.getStock()%>
                                            disponibles

                                        </span>


                                        <% } else { %>


                                        <span class="badge bg-danger">

                                            Sin stock

                                        </span>


                                        <% }%>


                                    </td>



                                    <!-- ACCIONES -->

                                    <td>


                                        <!-- EDITAR -->

                                        <a href="LibroServlet?accion=editar&id=<%= libro.getIdLibro()%>"
                                           class="btn btn-sm btn-warning">

                                            Editar

                                        </a>



                                        <!-- ELIMINAR -->

                                        <a href="LibroServlet?accion=eliminar&id=<%= libro.getIdLibro()%>"
                                           class="btn btn-sm btn-danger"
                                           onclick="return confirm('¿Deseas eliminar este libro?');">

                                            Eliminar

                                        </a>


                                    </td>


                                </tr>


                                <%

                                    }

                                } else {

                                %>


                                <!-- SIN LIBROS -->

                                <tr>

                                    <td colspan="8"
                                        class="text-center text-muted">

                                        No hay libros registrados.

                                    </td>

                                </tr>


                                <%                        }

                                %>


                            </tbody>


                        </table>


                    </div>


                </div>


            </div>


        </div>



        <!-- ==================== FOOTER ==================== -->

        <footer class="text-center text-muted mt-5 mb-4">

            BOOKHUB © 2026 — Sistema de Gestión de Biblioteca

        </footer>


    </body>
</html>
