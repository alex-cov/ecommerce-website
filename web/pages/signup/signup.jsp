<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page info="Signup Page" %>
<%@page contentType="text/html" %>
<%@page session="false" %>
<%@page buffer="30kb" %>
<%@page errorPage="/ErrorPage.jsp" %>

<%@ page import="services.session.*" %>

<jsp:useBean id="loginManagement" scope="page" class="bflows.LoginManagement" />
<jsp:setProperty name="loginManagement" property="*" />

<%
  Cookie[] cookies=null;
  cookies=request.getCookies();
  
  String status = request.getParameter("status");
  if (status == null) status="view";

  util.Debug.println("status: "+status);
    
  if(status.equals("signup")) {
      loginManagement.signup();
  }
%>

<html>
  <head>
    <title>Registrazione</title>

    <!-- comprende css e script del framework, header e footer -->
    <%@ include file="../../shared/head-common.html" %>

    <!-- carica i tuoi file css qui -->
    <link href="signup.css" rel="stylesheet" type="text/css" />

    <!-- carica i tuoi file js qui -->
    <script type="text/javascript" src="signup.js"></script>

  </head>
    
  <body>
    <!-- header -->
    <div class="header">
      <%@ include file="../../shared/header/header.jsp" %>
    </div>
    
    <!-- sotto-header -->
    <div class="sotto-header">
      <%@ include file="../../shared/sotto-header/sotto-header.jsp" %>
    </div>

    <!-- content-area -->
    <div class="container content-area">
      
      <% if(status.equals("view")) {%>
        
      <h4>Registrati</h4>

      <div class="divider-horizontal"></div>

      <form class="form-horizontal" method='post' action="signup.jsp">

        <!--
        <div class="form-group">
          <label class="control-label col-sm-4" for="signup-first-name">Nome</label>
          <div class="col-sm-4">
            <input type="text" class="form-control" id="signup-first-name" placeholder="Inserisci il tuo nome">
          </div>
        </div>

        <div class="form-group">
          <label class="control-label col-sm-4" for="signup-last-name">Cognome</label>
          <div class="col-sm-4">
            <input type="text" class="form-control" id="signup-last-name" placeholder="Inserisci il tuo cognome">
          </div>
        </div>
        -->

        <div class="form-group">
          <label class="control-label col-sm-4" for="signup-email">Email</label>
          <div class="col-sm-4">
            <input required type="email" name='email' class="form-control" id="signup-email" placeholder="Inserisci la tua email">
          </div>
        </div>

        <div class="form-group">
          <label class="control-label col-sm-4" for="signup-password">Password</label>
          <div class="col-sm-4">
            <input required type="password" name='password' minlength="6" class="form-control" id="signup-password" placeholder="Inserisci la tua password">
          </div>
        </div>
        
        <!--
        <div class="form-group">
          <label class="control-label col-sm-4" for="signup-confirm-password">Conferma password</label>
          <div class="col-sm-4">
            <input required type="password" minlength="6" class="form-control" id="signup-confirm-password" placeholder="Reinserisci la tua password">
          </div>
        </div>
        -->

        <div class="form-group"> 
          <div class="col-sm-offset-4 col-sm-4">
            <input type="hidden" name="status" value="signup"/>
            <button type="submit" class="btn btn-default">Registrati</button>
          </div>
          <div class="col-sm-offset-4 col-sm-4" style="margin-top: 16px;">
            Sei già registrato? 
            <a href="../login/login.jsp">Accedi ora.</a>
          </div>
        </div>

      </form>
      
      <%} else if(status.equals("signup")) {%>
      
      Registrazione avvenuta con successo. <a href="../login/login.jsp">Effettua l'accesso</a>
      
      <%}%>
      
    </div>

    <!-- footer -->
    <div class="footer">
      <%@ include file="../../shared/footer/footer.jsp" %>
    </div>

  </body>
</html>

