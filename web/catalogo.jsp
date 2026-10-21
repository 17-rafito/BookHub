<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="beans.Libro"%>
<%@page import="beans.Categoria"%>
<%@page import="beans.Usuario"%>

<%
    List<Libro> libros =
            (List<Libro>) request.getAttribute("libros");

    List<Categoria> categorias =
            (List<Categoria>) request.getAttribute("categorias");

    String busqueda =
            (String) request.getAttribute("busqueda");
    if (busqueda == null) {
        busqueda = "";
    }

    String categoriaSeleccionada =
            (String) request.getAttribute("categoriaSeleccionada");
    if (categoriaSeleccionada == null) {
        categoriaSeleccionada = "";
    }

    Usuario usuarioSesion =
            (Usuario) session.getAttribute("usuario");
%>

<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Catálogo - BOOKHUB</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <style>

        body {
            background-color: #f8f9fa;
        }

        .hero {
            background: linear-gradient(135deg, #0d6efd, #084298);
            color: white;
            padding: 50px 0;
        }

        .book-card {
            transition: transform 0.2s;
        }

        .book-card:hover {
            transform: translateY(-5px);
        }

        .badge-ods {
            background-color: #fd6925;
            color: #ffffff;
        }

        .ods-banner {
            border-left: 5px solid #fd6925;
        }

    </style>

</head>

<body>


<!-- NAVBAR -->

<nav class="navbar navbar-dark bg-primary">

    <div class="container">

        <a class="navbar-brand fw-bold"
           href="index.html">
            📚 BOOKHUB
        </a>

        <div class="d-flex align-items-center flex-wrap gap-2">

            <a href="index.html"
               class="btn btn-outline-light btn-sm">
                Inicio
            </a>

            <% if (usuarioSesion != null) { %>

                <% if ("ADMIN".equals(usuarioSesion.getRol())) { %>
                    <a href="dashboard.jsp"
                       class="btn btn-light btn-sm">
                        Panel Admin
                    </a>
                <% } else { %>
                    <a href="usuario.jsp"
                       class="btn btn-light btn-sm">
                        Mi cuenta (<%= usuarioSesion.getNombre() %>)
                    </a>
                    <a href="MisPrestamosServlet"
                       class="btn btn-outline-light btn-sm">
                        Mis préstamos
                    </a>
                <% } %>

                <a href="LogoutServlet"
                   class="btn btn-dark btn-sm">
                    Cerrar sesión
                </a>

            <% } else { %>

                <a href="registro.jsp"
                   class="btn btn-outline-light btn-sm">
                    Registrarse
                </a>

                <a href="login.jsp"
                   class="btn btn-light btn-sm">
                    Iniciar sesión
                </a>

            <% } %>

        </div>

    </div>

</nav>


<!-- HERO -->

<section class="hero">

    <div class="container text-center">

        <h1 class="fw-bold">
            Catálogo de libros
        </h1>

        <p class="lead mb-0">
            Encuentra los libros disponibles en BOOKHUB y filtra por autor, categoría u ODS 09
        </p>

    </div>

</section>


<!-- CONTENIDO -->

<div class="container py-5">


    <!-- BANNER DESTACADO ODS 09 -->

    <div class="card ods-banner shadow-sm mb-4">
        <div class="card-body d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
            <div>
                <span class="badge badge-ods mb-1">ODS 09 - AGENDA 2030</span>
                <h5 class="fw-bold mb-1">
                    🏗️ Colección Especial: Industria, Innovación e Infraestructura
                </h5>
                <p class="text-muted small mb-0">
                    Explora nuestra bibliografía sobre transformación digital, infraestructura resiliente e innovación tecnológica sostenible.
                </p>
            </div>
            <div class="d-flex gap-2">
                <a href="CatalogoServlet?categoria=ODS+09+-+Innovaci%C3%B3n+e+Infraestructura"
                   class="btn btn-sm btn-primary">
                    Filtrar libros ODS 09
                </a>
                <% if (!categoriaSeleccionada.isEmpty() || !busqueda.isEmpty()) { %>
                    <a href="CatalogoServlet"
                       class="btn btn-sm btn-outline-secondary">
                        Ver todos
                    </a>
                <% } %>
            </div>
        </div>
    </div>


    <!-- BUSCADOR Y FILTROS -->

    <div class="card shadow-sm mb-5">

        <div class="card-body">

            <h5 class="fw-bold mb-3">
                🔎 Buscar y filtrar libros
            </h5>

            <form action="CatalogoServlet" method="get" class="row g-3">

                <div class="col-md-5">
                    <label class="form-label small text-muted mb-1">Búsqueda por título, autor o ISBN</label>
                    <input type="text"
                           id="buscador"
                           name="busqueda"
                           value="<%= busqueda %>"
                           class="form-control"
                           placeholder="Escribe título, autor o ISBN...">
                </div>

                <div class="col-md-4">
                    <label class="form-label small text-muted mb-1">Categoría</label>
                    <select name="categoria"
                            id="filtroCategoria"
                            class="form-select">
                        <option value="">Todas las categorías</option>
                        <% if (categorias != null) {
                               for (Categoria cat : categorias) {
                                   boolean sel = cat.getNombre().equalsIgnoreCase(categoriaSeleccionada);
                        %>
                            <option value="<%= cat.getNombre() %>" <%= sel ? "selected" : "" %>>
                                <%= cat.getNombre() %>
                            </option>
                        <%     }
                           } %>
                    </select>
                </div>

                <div class="col-md-3 d-flex align-items-end gap-2">
                    <button type="submit" class="btn btn-primary w-100">
                        Aplicar filtro
                    </button>
                    <a href="CatalogoServlet" class="btn btn-outline-secondary">
                        Limpiar
                    </a>
                </div>

            </form>

        </div>

    </div>


    <!-- LIBROS -->

    <div class="row g-4"
         id="listaLibros">


        <% if (libros != null && !libros.isEmpty()) { %>


            <% for (Libro libro : libros) {
                   boolean esOds = libro.getNombreCategoria() != null
                           && libro.getNombreCategoria().toUpperCase().contains("ODS 09");
            %>

                <div class="col-md-4 libro-item">

                    <div class="card book-card shadow-sm h-100">

                        <div class="card-body d-flex flex-column">

                            <div class="d-flex justify-content-between align-items-center mb-3">

                                <span class="badge <%= esOds ? "badge-ods" : "bg-primary" %>">
                                    <%= libro.getNombreCategoria() %>
                                </span>

                                <span class="text-muted small">
                                    Año: <%= libro.getAnio() %>
                                </span>

                            </div>

                            <h4 class="card-title">
                                <%= libro.getTitulo() %>
                            </h4>

                            <p class="mb-1">
                                <strong>Autor:</strong>
                                <%= libro.getNombreAutor() %>
                            </p>

                            <p class="text-muted small mb-2">
                                ISBN: <%= libro.getIsbn() %>
                            </p>

                            <p class="card-text text-muted">
                                <%= libro.getDescripcion() %>
                            </p>


                            <div class="mt-auto pt-3">

                                <% if (libro.getStock() > 0) { %>

                                    <div class="mb-3">
                                        <span class="badge bg-success">
                                            Disponible (<%= libro.getStock() %> ejemplares)
                                        </span>
                                    </div>

                                <% } else { %>

                                    <div class="mb-3">
                                        <span class="badge bg-danger">
                                            No disponible
                                        </span>
                                    </div>

                                <% } %>


                                <div class="d-grid gap-2">

                                    <a href="DetalleLibroServlet?id=<%= libro.getIdLibro() %>"
                                       class="btn btn-primary">
                                        Ver detalles
                                    </a>

                                    <% if (libro.getStock() > 0) { %>
                                        <a href="SolicitarPrestamoServlet?idLibro=<%= libro.getIdLibro() %>"
                                           class="btn btn-outline-primary btn-sm">
                                            Solicitar préstamo
                                        </a>
                                    <% } %>

                                </div>

                            </div>

                        </div>

                    </div>

                </div>

            <% } %>


        <% } else { %>

            <div class="col-12">

                <div class="alert alert-info text-center">

                    No se encontraron libros con los criterios seleccionados.
                    <a href="CatalogoServlet" class="alert-link ms-2">Ver todo el catálogo</a>

                </div>

            </div>

        <% } %>


    </div>

</div>


<!-- FOOTER -->

<footer class="bg-dark text-white text-center py-4 mt-5">

    <p class="mb-1">
        © 2026 BOOKHUB - Sistema de Gestión de Biblioteca Universitaria
    </p>
    <p class="small text-secondary mb-0">
        ODS 09: Industria, Innovación e Infraestructura
    </p>

</footer>


<!-- BUSCADOR EN TIEMPO REAL -->

<script>

    const buscador = document.getElementById("buscador");
    const librosItems = document.querySelectorAll(".libro-item");

    buscador.addEventListener("keyup", function () {

        const texto = buscador.value.toLowerCase();

        librosItems.forEach(function (libro) {

            const contenido = libro.textContent.toLowerCase();

            if (contenido.includes(texto)) {
                libro.style.display = "block";
            } else {
                libro.style.display = "none";
            }

        });

    });

</script>


</body>

</html>
