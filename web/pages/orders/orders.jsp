<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>
 
<t:base-layout title="I miei ordini">
  
  <jsp:attribute name="sotto_header">
    <%@ include file="../../shared/account-sotto-header/account-sotto-header.jsp" %>
  </jsp:attribute>
  
  <jsp:attribute name="content_area">
    <!-- metti qui il contenuto della pagina -->
    <h4>I miei ordini</h4>

    <div class="divider-horizontal"></div>
    
    <div style="margin-top: 16px;">
      <%@ include file="../../shared/order/order.jsp" %>
      <%@ include file="../../shared/order/order.jsp" %>
      <%@ include file="../../shared/order/order.jsp" %>
    </div>
    
  </jsp:attribute>
    
  <jsp:attribute name="css_imports">
    <!-- metti qui i css da importare -->
    <link href="orders.css" rel="stylesheet" type="text/css" />
    <link href="../../shared/account-sotto-header/account-sotto-header.css" rel="stylesheet" type="text/css" />
    <link href="../../shared/order/order.css" rel="stylesheet" type="text/css" />
  </jsp:attribute>
  
  <jsp:attribute name="js_imports">
    <!-- metti qui i js da importare -->
    <script type="text/javascript" src="orders.js"></script>
    <script type="text/javascript" src="../../shared/account-sotto-header/account-sotto-header.js"></script>
    <script type="text/javascript" src="../../shared/order/order.js"></script>
  </jsp:attribute>
 
</t:base-layout>
