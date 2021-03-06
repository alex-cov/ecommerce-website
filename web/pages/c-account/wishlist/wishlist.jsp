<%@page import="blogics.Book"%>
<%@page import="bflows.AccountManagement"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page info="Wishlist Page" %>
<%@page session="false" %>
<%@page buffer="30kb" %>
<%@page errorPage="../../ErrorPage.jsp" %>

<%@ page import="services.session.*" %>

<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="accountManagement" scope="page" class="bflows.AccountManagement" />
<jsp:setProperty name="accountManagement" property="*" />

<%
  Cookie[] cookies = request.getCookies();
  accountManagement.setCookies(cookies);
  boolean loggedIn = Session.isUserLoggedIn(cookies);
  boolean admin = Session.isUserAdmin(cookies);
  
  String action = request.getParameter("action");
  if (action == null) action = "view";
  
  if(action.equals("view")) {
    accountManagement.wishlistView();
  } else if(action.equals("add")) {
    accountManagement.addToWishlist();
  } else if(action.equals("remove")) {
    accountManagement.removeFromWishlist();
  }
  
  String message = accountManagement.getErrorMessage();
  if(message != null) action = "view";
%>

<html>
  <head>
    <title>La mia lista desideri</title>
    
    <!-- Se l'utente non è loggato o è un admin ritorno alla homepage immantinente -->
    <% if(!loggedIn | admin) { %>
      <script language="javascript">
        location.replace("../../c-search/homepage/homepage.jsp");
      </script>
    <% } %>

    <!-- comprende css e script del framework, header e footer -->
    <%@ include file="../../../shared/head-common.html" %>

    <!-- carica i tuoi file css qui -->
    <link href="cart.css" rel="stylesheet" type="text/css" />
    <link href="../../../shared/wishlist-book/wishlist-book.css" rel="stylesheet" type="text/css" />

    <!-- carica i tuoi file js qui -->
    <script type="text/javascript" src="wishlist.js"></script>
    <script type="text/javascript" src="../../../shared/wishlist-book/wishlist-book.js"></script>

  </head>
    
  <body>
    <!-- header -->
    <div class="header">
      <%@ include file="../../../shared/header/header.jsp" %>
    </div>
    
    <!-- sotto-header -->
    <div class="sotto-header">
      <%@ include file="../../../shared/sotto-header/account-sotto-header.jsp" %>
    </div>

    <!-- content-area -->
    <div class="container content-area">
      
      <% if(action.equals("add")) { %>
        <h4>
        <a class="book-title" href="../../c-search/book-page/book-page.jsp?isbn=<%=accountManagement.getIsbn()%>">
           <%=accountManagement.getTitle()%>
        </a> aggiunto alla lista desideri!
        </h4>
      <% } else if(action.equals("remove")) { %>
        <h4>
        <a class="book-title" href="../../c-search/book-page/book-page.jsp?isbn=<%=accountManagement.getIsbn()%>">
           <%=accountManagement.getTitle()%>
        </a> rimosso dalla lista desideri
        </h4>
      <% } %>
      
      <h3>La mia Lista Desideri</h3>

      <div class="divider-horizontal"></div>

      <div class="row">
        
        <% if(accountManagement.getWishlist().isEmpty()) { %>
          <div class=col-xs-12>Non hai nessun libro nei tuoi desideri!</div>
        <% } else { %>
          <% for(Book book : accountManagement.getWishlist()) { %>
            <% request.setAttribute("book", book); %>
            <jsp:include page="../../../shared/wishlist-book/wishlist-book.jsp" />
          <% } %>
        <% } %>
        
        
        <div class='col-xs-12' style='margin-top: 12px;'>
          <a href='../account/account.jsp'>Torna all'account</a>
        </div>

      </div>
        
    </div>

    <!-- footer -->
    <div class="footer">
      <%@ include file="../../../shared/footer/footer.jsp" %>
    </div>

    <%if (message != null) {%>
      <script>alert("<%=message%>");</script>
    <%}%>
    
  </body>
</html>
