<%@page import="blogics.Genre"%>
<%@page import="java.util.List"%>
<%@page import="util.Conversion"%>
<%@page import="util.Logger"%>
<%@page import="blogics.Review"%>
<%@page import="blogics.Book"%>
<%@page import="bflows.SearchManagement"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page info="Book Page" %>
<%@page session="false" %>
<%@page buffer="30kb" %>
<%@page errorPage="../../ErrorPage.jsp" %>

<%@ page import="services.session.*" %>
<%@ page import="global.Constants" %>

<% request.setCharacterEncoding("UTF-8"); %>

<jsp:useBean id="searchManagement" scope="page" class="bflows.SearchManagement" />
<jsp:setProperty name="searchManagement" property="*" />

<%
  Cookie[] cookies = request.getCookies();
  searchManagement.setCookies(cookies);
  boolean loggedIn = Session.isUserLoggedIn(cookies);
  boolean admin = Session.isUserAdmin(cookies);
  
  String action = request.getParameter("action");
  if (action == null) action="view";
  
  if(action.equals("view")) {
    searchManagement.bookView();
  } else if(action.equals("review")) {
    searchManagement.bookReview();
  } else if(action.equals("edit_review")) {
    searchManagement.bookEditReview();
  } else if(action.equals("remove_review")) {
    searchManagement.bookRemoveReview();
  }
  
  String message = searchManagement.getErrorMessage();
  if(message != null) action="view";
%>

<html>
  <head>
    <title>Dettagli libro</title>

    <!-- comprende css e script del framework, header e footer -->
    <%@ include file="../../../shared/head-common.html" %>

    <!-- carica i tuoi file css qui -->
    <link href="book-page.css" rel="stylesheet" type="text/css" />
    <link href="../../../shared/review/review.css" rel="stylesheet" type="text/css" />

    <!-- carica i tuoi file js qui -->
    <script type="text/javascript" src="book-page.js"></script>

    <script>
      function setReviewAction(a) {
        document.getElementById("input-action").value = a;
        return;
      }
      
    </script>
  </head>
    
  <body>
    <!-- header -->
    <div class="header">
      <%@ include file="../../../shared/header/header.jsp" %>
    </div>
    
    <!-- sotto-header -->
    <div class="sotto-header">
      <%@ include file="../../../shared/sotto-header/sotto-header.jsp" %>
    </div>

    <!-- content-area -->
    <div class="container content-area">
      
      <% if(action.equals("view")) { %>
        
      <!-- Torna alla pagina di ricerca se non è stato trovato nessun libro con l'isbn specificato -->
      <% if(searchManagement.getBook() == null) { %>
        <script language="javascript">
          location.replace('../search/search.jsp');
        </script>
      <% } else { %>

      <div class="row" id="copertina-info">

        <div class="col-sm-3" id="div_copertina">
          <div id="copertina-book-page">
            <img class="copertina"
              src="<%= searchManagement.getBook().getCover() %>"
              onerror="this.src='<%= Constants.DEFAULT_COVER %>'"
            />
          </div>
        </div>

        <div class="col-sm-6" id="informazioni">
          <h2><%=searchManagement.getBook().getTitle()%></h2>

          <h4><small>di</small> <%=searchManagement.getBook().getAuthors().get(0).getName()%>
            <% for(int i=1; i<searchManagement.getBook().getAuthors().size(); i++) { %>
              , <%=searchManagement.getBook().getAuthors().get(i).getName()%>
            <% } %>
          </h4>

          <p><b>ISBN:</b> <%=searchManagement.getBook().getIsbn()%></p>
          
          <p><b>Genere:</b>
            <% List<Genre> genres = searchManagement.getBook().getGenres(); %>
            <% for(int i=0; i<genres.size(); i++) { %>
              <% if(i>0) { %> , <% } %>
              <%=genres.get(i).getName()%>
            <% } %>
          </p>
          
          <p><b>Pagine:</b>
            <% if(searchManagement.getBook().getPages() > 0) { %>
              <%=searchManagement.getBook().getPages()%>
            <% } else { %>
              <small>Dato non disponibile</small>
            <% } %>
          </p>
          
          <p><b>Editore:</b> <%=searchManagement.getBook().getPublisher() %></p>
          
          <p><b>Data di pubblicazione:</b>
            <% if(searchManagement.getBook().getPublicationDate() != null) { %>
              <%=Conversion.getDateAsString(searchManagement.getBook().getPublicationDate())%>
            <% } else { %>
            <small>Dato non disponibile</small>
            <% } %>
          </p>
          
          <p><b>Lingua:</b> <%=searchManagement.getBook().getLanguage() %></p>
          <p><b><a href="#valutazioni_altri_utenti">Voto</a></b>: <%=searchManagement.getBook().getVotePercent()%>% <small>(<%=searchManagement.getBook().getNVotes()%> voti)</small></p>
        </div>

        <div class="col-sm-3" id="prezzo">
          <h3 class="price"><b><%= Conversion.getPriceAsString(searchManagement.getBook().getPrice()) %> &euro;</b></h3>
          Venduto e spedito da Libreria Sant'Ale
          <div style="margin-bottom: 15px;"></div>

          <% if(searchManagement.getBook().getStock() > 0) { %>
            <p style="color: green;">Prodotto disponibile</p>
          <% } else { %>
            <p style="color: red;">Prodotto non disponibile</p>
          <% } %>

          <% if(!admin) { %>
            <div id="carrello-desideri">
              
              <form id="add-to-cart-form" action="../../c-account/cart/cart.jsp" method="post">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="isbn" value="<%=searchManagement.getBook().getIsbn()%>">
                <input type="hidden" name="title" value="<%=searchManagement.getBook().getTitle()%>">
                <button type="button" title="Aggiungi al carrello" class="btn btn-default" onclick="submitAddToCartForm(<%=loggedIn%>)"
                        <% if(searchManagement.getBook().getStock() < 1) { %>disabled<% } %> >
                  <i class="glyphicon glyphicon-shopping-cart"></i>
                  Aggiungi al carrello
                </button>
              </form>
              
              <form id="add-to-wishlist-form" action="../../c-account/wishlist/wishlist.jsp" method="post">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="isbn" value="<%=searchManagement.getBook().getIsbn()%>">
                <input type="hidden" name="title" value="<%=searchManagement.getBook().getTitle()%>">
                <button type="button" title="Aggiungi ai desideri" class="btn btn-default" onclick="submitAddToWishlistForm(<%=loggedIn%>)">
                  <i class="glyphicon glyphicon-heart"></i>
                  Aggiungi ai desideri
                </button>
              </form>
                
            </div>
          <% } else { %>
          
            <div style="margin-bottom: 15px;"></div>
            <div id="carrello-desideri">
              <button title="Modifica" class="btn btn-primary" type="button" onclick="submitAdminLibroForm('view')">
                <i class="glyphicon glyphicon-edit"></i> Modifica
              </button>
              <br/><div style="margin-bottom: 15px;"></div>
              <button title="Rimuovi" class="btn btn-danger" type="button" onclick="submitAdminLibroForm('remove')">
                <i class="glyphicon glyphicon-remove"></i> Rimuovi
              </button>
            </div>

            <form name="adminLibroForm" action="../../c-admin/add-book/add-book.jsp">
              <input type="hidden" name="action">
              <input type="hidden" name="isbn" value="<%= searchManagement.getBook().getIsbn() %>">
            </form>

          <% } %>
        </div>
      </div>

      <div class="horiz-divider"></div>

      <div class="my-jumbotron sezione-bookpage">
          <button id="btn_descrizione" class="btn btn-primary btn_bookpage" type="button" data-toggle="collapse"
                  data-target="#descrizione" aria-expanded="false" aria-controls="descrizione">
              <b>DESCRIZIONE</b> <i class="glyphicon glyphicon-chevron-down"></i>
          </button>

          <div class="collapse" id="descrizione">
            <% if(!searchManagement.getBook().getDescription().equals("-")) { %>
            <%=searchManagement.getBook().getDescription()%>
            <% } else { %>
            Descrizione non disponibile
            <% } %>
              
          </div>
      </div>


      <div id="consigliati_div" class="my-jumbotron sezione-bookpage">
        <button class="btn btn-primary btn_bookpage" type="button" data-toggle="collapse"
                data-target="#consigliati" aria-expanded="false" aria-controls="consigliati">
            Sant'Ale Ti Consiglia Anche <i class="glyphicon glyphicon-chevron-down"></i>
        </button>

        <div class="container-fluid">
          <div id="consigliati" class="carousel slide collapse" data-ride="carousel">
        
            <div class="carousel-inner" role="listbox">

              <% for(int i=0; i<searchManagement.getSuggestedBooks().size(); i+=3) { %>
                <div class="item col-sm-10 col-sm-offset-1 <%if(i==0) { %> active <% } %>">
                  <%for(int j=0; j<3; j++) {%>
                    <%if(searchManagement.getSuggestedBooks().size()>i+j) {
                        Book book = searchManagement.getSuggestedBooks().get(i+j); %>
                          <% request.setAttribute("book", book); %>
                          <jsp:include page="../../../shared/homepage-book/homepage-book.jsp" />
                    <% } %>
                  <% } %>
                </div>
              <% } %>

            </div>

            <a class="left carousel-control" href="#consigliati" role="button" data-slide="prev" style="background-image: none;">
                <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
                <span class="sr-only">Previous</span>
            </a>
            <a class="right carousel-control" href="#consigliati" role="button" data-slide="next" style="background-image: none;">
                <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
                <span class="sr-only">Next</span>
            </a>
          </div><!-- /.carousel -->
        </div>
              
      </div>

      <!-- è possibile mettere una valutazione solo se non si è admin -->
      <% if(!admin) { %>
      <div class="my-jumbotron" id="valutazione">
          <h3>La tua valutazione</h3>
          
          <form name="valutazione_libro" method="post">
            <input id="input-action" type='hidden' name='action' value='view'>
            <input type='hidden' name='isbn' value='<%=searchManagement.getIsbn()%>' />
              <table>
                  <tr>
                      <th>
                          <div id="voto" class="btn-group-vertical" data-toggle="buttons">
                              <label title="Lo Consiglio" class="vote-label btn btn-default">
                                  <input type="radio" name="thumbUp" value='true' id="option1" required>
                                  <i class="glyphicon glyphicon-thumbs-up"></i>
                              </label>
                              <label title="Non lo Consiglio" class="vote-label btn btn-default">
                                  <input type="radio" name="thumbUp" value='false' id="option2" required>
                                  <i class="glyphicon glyphicon-thumbs-down"></i>
                              </label>
                            
                              <% if(searchManagement.getUserBookReview() != null) { %>
                                <% if(searchManagement.getUserBookReview().isThumbUp()) { %>
                                <script>
                                  document.getElementById("option1").click();
                                </script>
                                <% } else {%>
                                <script>
                                  document.getElementById("option2").click();
                                </script>
                                <% } %>
                              <% } %>
                          </div>
                      </th>
                      <td>
                          <textarea name='comment' id="recensione" class="form-control"
                                  placeholder="Scrivi la tua recensione... (facoltativo)"
                                  cols="100" rows="3"></textarea>
                        <% if(searchManagement.getUserBookReview() != null) { %>
                          <% if(searchManagement.getUserBookReview().getComment() != null) { %>
                            <script>
                              document.getElementById("recensione").value = '<%=searchManagement.getUserBookReview().getComment()%>';
                            </script>
                          <% } %>
                        <% } %>
                      </td>
                  </tr>
              </table>
            
              <% if(loggedIn) { %>
              <% if(searchManagement.getUserBookReview() == null && !Session.isUserBlocked(cookies)) { %>
                  <button id="submit_voto" class="btn btn-primary" type="submit"
                          onclick='setReviewAction("review")'>
                      <i class="glyphicon glyphicon-ok"></i>
                      Invia valutazione
                  </button>
                  <% } else if(searchManagement.getUserBookReview() == null && Session.isUserBlocked(cookies)) { %>
                  </br>
                  <b>In quanto utente bloccato, non puoi scrivere nuove recensioni!</b>
                <% } else { %>
                  <button id="submit_voto" class="btn btn-primary" type="submit"
                          onclick='setReviewAction("edit_review")'>
                      <i class="glyphicon glyphicon-ok"></i>
                    Modifica valutazione
                  </button>
                  <button id="remove_voto" class="btn btn-danger" type="submit"
                          onclick='setReviewAction("remove_review")'>
                      <i class="glyphicon glyphicon-remove"></i>
                    Rimuovi valutazione
                  </button>
                <% } %>
              <% } else { %>
                </br>
                Devi essere registrato per valutare questo libro!
                <a href="../../c-login/login/login.jsp">Accedi</a>
              <% } %>
          </form>
          
          </BR>
      </div>
          
      <% } %>

      <div class="my-jumbotron" id="valutazioni_altri_utenti">
          <h3>Gli altri utenti la pensano così...</h3>
          
          <% if(searchManagement.getBookReviews().size() == 0) { %>
            Non c'è nessuna recensione
          <% } %>
          
          <% for(Review review : searchManagement.getBookReviews()) { %>
            <% request.setAttribute("review", review); %>
            <% request.setAttribute("admin", admin); %>
            <jsp:include page="../../../shared/review/review.jsp" />
          <% } %>
      </div>
      <% } %>
      
    <% } else if(action.equals("review")) { %>
      La tua recensione è stata inserita, grazie del contributo! </br>
      <a href='book-page.jsp?isbn=<%=searchManagement.getIsbn()%>'>Ritorna al libro</a>
    <% } else if(action.equals("edit_review")) { %>
      La tua recensione è stata modificata! </br>
      <a href='book-page.jsp?isbn=<%=searchManagement.getIsbn()%>'>Ritorna al libro</a>
    <% } else if(action.equals("remove_review") && !admin) { %>
      La tua recensione è stata cancellata! </br>
      <a href='book-page.jsp?isbn=<%=searchManagement.getIsbn()%>'>Ritorna al libro</a>
    <% } else { %>
      La recensione è stata cancellata! </br>
      <a href='book-page.jsp?isbn=<%=searchManagement.getIsbn()%>'>Ritorna al libro</a>
    <% } %>
        
        
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