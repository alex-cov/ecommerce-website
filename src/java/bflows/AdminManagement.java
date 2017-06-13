package bflows;

import blogics.AuthorService;
import blogics.Book;
import blogics.BookHasAuthor;
import blogics.BookHasAuthorService;
import blogics.BookHasGenre;
import blogics.BookHasGenreService;
import blogics.BookService;
import blogics.GenreService;
import java.io.Serializable;
import services.database.*;
import services.database.exception.*;

public class AdminManagement extends AbstractManagement implements Serializable {
	
  private int userId;
  
  /* Servono per i libri */
  private String titolo;
  private String descrizione;
  private String autore[];
  private String isbn = "null";
  private int pagine = -1;
  private String editore;
  private String[] bookGeneri; /* Serve per salvare i generi selezionati del libro */
  private String dataPubbl;
  private String lingua;
  private float prezzo;
  private int stock;
  
  private String[] generi; /* Serve per scrivere i generi salvati nel DB */
  
  
  
  
	/* users.jsp -> users.jsp : block */
	public void blockUser() {
		
	}
	
	/* admins.jsp -> admins-jsp : remove */
	public void removeAdmin() {
		
	}
	
	/* signup.jsp -> admins.jsp : add */
	public void signupAdmin() {
		
	}
	
	/* admin-orders.jsp -> admin-orders.jsp : change-state */
	public void changeOrderState() {
		
	}
	
	/* add-coupon.jsp -> coupons.jsp : add */
	public void addCoupon() {
		
	}
	
	/* coupons.jsp -> coupons.jsp : disable */
	public void disableCoupon() {
		
	}
	
  /* add-book.jsp : view */
  /* azione per view senza isbn */
  public void visualizza() throws UnrecoverableDBException {
    Database database = DBService.getDataBase();
    
    try {
      /* Recupero i generi dal DB */
      this.recuperaGeneri(database);
      
      /* FINITO! */
      database.commit();
    } catch (RecoverableDBException ex) {
      database.rollBack();
      setErrorMessage(ex.getMsg());
		} finally {
      database.close();
    }
  }
  
  /* search-jsp/book-page.jsp -> add-book.jsp : view */
	/* manda anche isbn libro come parametro */
	public void recuperaInfo() throws UnrecoverableDBException {
		Database database = DBService.getDataBase();
    
    try {
      
      /* Recupero i generi dal DB */
      this.recuperaGeneri(database);
      
      /* Recuperiamo tutto le info del libro */
      Book libro = BookService.getBookFromIsbn(database, isbn);
      
      titolo = libro.getTitle();
      descrizione = libro.getDescription();
      pagine = libro.getPages();
      editore = libro.getPublisher();
      dataPubbl = libro.getPublicationDate();
      lingua = libro.getLanguage();
      prezzo = libro.getPrice();
      stock = libro.getStock();
      
      /* Per l'autore e i generi funziona un po' diversamente... */
      BookHasAuthor[] autori = BookHasAuthorService.getAuthorsFromIsbn(database, isbn);
       
      autore = new String[autori.length];
      for(int i = 0; i < autore.length; i++)
        autore[i] = AuthorService.getAuthorFromId(database, autori[i].getAuthorId());
        
      this.recuperaGeneri(database);
      
      BookHasGenre[] bookHasGenre = BookHasGenreService.getGenresFromIsbn(database, isbn);
      
      bookGeneri = new String[bookHasGenre.length];
      for(int i = 0; i < bookGeneri.length; i++)
        bookGeneri[i] = GenreService.getGenreFromId(database, bookHasGenre[i].getGenreId());
      
      /* FINITO! */
      database.commit();
    } catch (RecoverableDBException ex) {
      database.rollBack();
      setErrorMessage(ex.getMsg());
		} finally {
      database.close();
    }
	}
  
	/* add-book.jsp -> add-book.jsp : add */
	public void addBook() throws UnrecoverableDBException {
    
		Database database = DBService.getDataBase();
    
    try {
      
      /* Recupero i generi dal DB */
      this.recuperaGeneri(database);
      
      /* Inserisco il libro */
      System.out.println("");
      System.out.println("----- addBook -----");
      System.out.println("Inserimento del libro...");
      BookService.insertNewBook(database, titolo, descrizione, pagine, prezzo, dataPubbl, stock, isbn, lingua, editore);
      System.out.println("Libro inserito!");
      
      /* Cerco l'ID degli autori */
      System.out.println("Ricerca dell'autore...");
      int idAutore[] = new int[autore.length];
      for(int i = 0; i < idAutore.length; i++)
        idAutore[i] = AuthorService.searchFromName(database, autore[i]);
      
      /* Se l'autore non esiste, inserisco un nuovo autore con il nome indicato */
      for(int i = 0; i < idAutore.length; i++) {
        if(idAutore[i] == -1) {
          System.out.println("Inserimento dell'autore...");
          idAutore[i] = AuthorService.insertNewAuthor(database, autore[i]);
          System.out.println("Autore inserito!");
        }
      }
      
      /* Inserisco il legame tra libro e autore */
      System.out.println("Scrittura del autore del libro...");
      for(int i = 0; i < idAutore.length; i++)
        BookHasAuthorService.insertAuthorOfBook(database, isbn, idAutore[i]);
      System.out.println("Scritto!");
      
      /* Cerco gli ID dei generi selezionati, poi inserisco i legami tra libro e generi */
      for(int i = 0; i < bookGeneri.length; i++)
        System.out.println(bookGeneri[i]);
      
      System.out.println("");
      
      System.out.println("Cerco gli id dei generi indicati...");
      int[] idGeneri = GenreService.getIds(database, bookGeneri);
      for(int i = 0; i < idGeneri.length; i++)
        System.out.println("Id del bookGeneri " + bookGeneri[i] + ": " + idGeneri[i]);
      
      System.out.println("Scrittura dei generi del libro...");
      BookHasGenreService.insertGenresOfBook(database, isbn, idGeneri);
      System.out.println("Scritti!");
      
      /* FINITO! */
      database.commit();
      System.out.println("Stato: committed");
      
    } catch (RecoverableDBException ex) {
      System.out.println("Oh, cavolo! Qualcosa è andato storto!");
      database.rollBack();
      setErrorMessage(ex.getMsg());
		} finally {
      database.close();
      System.out.println("Chiusura del database... Fatto!");
    }
    
    System.out.println("Abbiamo finito, penso!");
	}
	
	/* add-book.jsp -> add-book.jsp : modify */
	public void modifyBook() {
		
	}
  
  /* Funzioni utili */
  public boolean checkGenere(String bookGeneri) {
    if(isbn.equals("null"))
      return false;
    
    for(int j = 0; j < this.bookGeneri.length; j++)
      if(this.bookGeneri[j].equals(bookGeneri)) 
        return true;
    
    return false;
  }
  
  public void recuperaGeneri(Database database) throws RecoverableDBException {
    generi = GenreService.getGeneri(database);
  }
  
  /* Getters */
  public int getUserId() {
    return userId;
  }
  
  public String getTitolo() {
    return titolo;
  }
  
  public String getDescrizione() {
    return descrizione;
  }
  
  public String[] getAutore() {
    return autore;
  }
  
  public String getAutore(int index) {
    return this.autore[index];
  }
  
  public String getIsbn() {
    return isbn;
  }
  
  public int getPagine() {
    return pagine;
  }
  
  public String getEditore() {
    return editore;
  }
  
  public String[] getBookGeneri() {
    return bookGeneri;
  }
  
  public String getBookGeneri(int index) {
    return this.bookGeneri[index];
  }
  
  public String getDataPubbl() {
    return dataPubbl;
  }
  
  public String getLingua() {
    return lingua;
  }
  
  public float getPrezzo() {
    return prezzo;
  }
  
  public int getStock() {
    return stock;
  }
  
  public String[] getGeneri() {
    return generi;
  }
  
  public String getGeneri(int index) {
    return this.generi[index];
  }
  
  /* Setters */
  public void setUserId(int userId) {
    this.userId = userId;
  }
  
  public void setTitolo(String titolo) {
    this.titolo = titolo;
  }
  
  public void setDescrizione(String descrizione) {
    this.descrizione = descrizione;
  }
  
  public void setAutore(String[] autore) {
    this.autore = autore;
  }
  
  public void setAutore(int index, String autore) {
    this.autore[index] = autore;
  }
  
  public void setIsbn(String isbn) {
    this.isbn = isbn;
  }
  
  public void setPagine(int pagine) {
    this.pagine = pagine;
  }
  
  public void setEditore(String editore) {
    this.editore = editore;
  }
  
  public void setBookGeneri(String[] bookGeneri) {
    this.bookGeneri = bookGeneri;
  }

  public void setBookGeneri(int index, String bookGeneri) {
    this.bookGeneri[index] = bookGeneri;
  }
  
  public void setDataPubbl(String dataPubbl) {
    this.dataPubbl = dataPubbl;
  }
  
  public void setLingua(String lingua) {
    this.lingua = lingua;
  }
  
  public void setPrezzo(float prezzo) {
    this.prezzo = prezzo;
  }
  
  public void setStock(int stock) {
    this.stock = stock;
  }
  
  public void setGeneri(String[] generi) {
    this.generi = generi;
  }
  
  public void setGeneri(int index, String generi) {
    this.generi[index] = generi;
  }
}
