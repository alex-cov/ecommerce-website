<%@page import="services.session.Session"%>

<nav id="navbar-shared" class="navbar navbar-default navbar-fixed-top">
  <div class="container-fluid">
    
    <div class="navbar-header">
      
      <a class="navbar-brand" href="../../c-search/homepage/homepage.jsp">Libreria Sant'Ale</a>
      
      <button style="padding: 6px 10px;" type="button" class="navbar-toggle" data-toggle="collapse" data-target="#menu-right" aria-expanded="false" aria-controls="menu-right">
        <span class="sr-only">Toggle Navigation</span>
        <i class="glyphicon glyphicon-menu-down"></i>
      </button>
      <button style="padding: 6px 10px;" type="button" class="navbar-toggle" data-toggle="collapse" data-target="#search-bar" aria-expanded="false" aria-controls="search-bar">
        <span class="sr-only">Toggle Navigation</span>
        <i class="glyphicon glyphicon-search"></i>
      </button>
      
    </div>

    <% if(loggedIn && !Session.isUserAdmin(cookies)) {%>
      <!-- menu a destra (logged in) -->
      <div id="menu-right" class="collapse navbar-collapse navbar-right">
        <ul class="nav navbar-nav">
          <li title="Il mio account: <%=Session.getUserFullName(cookies)%>">
            <a href="../../c-account/account/account.jsp"><i class="glyphicon glyphicon-user"></i>
              <span class="visible-xs-inline" style="padding-left:16px;">Il mio account: <%=Session.getUserFullName(cookies)%></span>
            </a>
          </li>
          <li title="Carrello">
            <a href="../../c-account/cart/cart.jsp"><i class="glyphicon glyphicon-shopping-cart"></i>
            <span class="visible-xs-inline" style="padding-left:16px;">Carrello</span>
            <!--<span class="badge">4</span>-->
            </a>
          </li>
          <li title="Lista desideri">
            <a href="../../c-account/wishlist/wishlist.jsp"><i class="glyphicon glyphicon-heart"></i>
            <span class="visible-xs-inline" style="padding-left:16px;">Lista desideri</span>
            </a>
          </li>
        </ul>
      </div> <!-- menu a destra (logged in) -->
    
    <% } else if(loggedIn && Session.isUserAdmin(cookies)) { %>
      <!-- menu a destra (admin) -->
      <div id="menu-right" class="collapse navbar-collapse navbar-right">
        <ul class="nav navbar-nav">
          <li title="Account Amministratore: <%= Session.getUserName(cookies) %> <%= Session.getUserSurname(cookies) %>">
            <a href="../../c-admin/admin-account/admin.jsp"><i class="glyphicon glyphicon-user"></i>
            <span class="visible-xs-inline" style="padding-left:16px;">Account Amministratore: <%= Session.getUserName(cookies) %> <%= Session.getUserSurname(cookies) %></span>
            </a>
          </li>
          <li title="Aggiungi libro">
            <a href="../../c-admin/add-book/add-book.jsp"><i class="glyphicon glyphicon-book"></i>
            <span class="visible-xs-inline" style="padding-left:16px;">Aggiungi libro</span>
            </a>
          </li>
          <li title="Lista ordini">
            <a href="../../c-admin/admin-orders/admin-orders.jsp"><i class="glyphicon glyphicon-list"></i>
            <span class="visible-xs-inline" style="padding-left:16px;">Lista ordini</span>
            </a>
          </li>
        </ul>
      </div> <!-- menu a destra (admin) -->
    
    <%} else {%>
      <!-- menu a destra (logged out) -->
      <div id="menu-right" class="navbar-right navbar-collapse collapse">
          <ul class="nav navbar-nav">
            <li>
              <a href="../../c-login/login/login.jsp">Accedi</a>
            </li>
            <li>
              <a href="../../c-login/signup/signup.jsp">Registrati</a>
            </li>
          </ul>
      </div> <!-- menu a destra (logged out) -->
    <% } %>

    <!-- barra di ricerca -->
    <div id="search-bar" class="navbar-collapse collapse">
      <form id="search-form" class="navbar-form" action="../../c-search/search/search.jsp" method="post">

        <div id="search-form-group" class="form-group">
          <div id="search-input-group" class="input-group">
            <div class="input-group-btn" style="width:1%;">
              <button class="btn btn-default" type="button" style="font-size: 12px; height: 34px;" onclick="gotoAdvancedSearch()">
                Ricerca avanzata
              </button>
            </div>
            <input id="search-input" name="search" type="text" class="form-control" placeholder="Cerca">
            <div class="input-group-btn" style="width:1%;">
              <button class="btn btn-default" type="submit" style="height: 34px;">
                <i class="glyphicon glyphicon-search"></i>
              </button>
            </div>
          </div>
        </div>
      </form>
    </div> <!-- barra di ricerca -->
    
  </div>
</nav>