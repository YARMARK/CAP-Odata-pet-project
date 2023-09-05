package bookstore.service;

import com.sap.cds.ql.cqn.CqnSelect;
import java.util.List;

import cds.gen.bookstore.Books;
import cds.gen.booksservice.Book;

public interface BookService {

  List<Books> getAllBooks();

  List<Books> getBooksForAuthor(List<Books> bookList,String id);

  List<Book> getBookForAuthor(List<Book> bookList,String id);

  List<Book> getAllBook();

  void save(Book book);

  List<Book> getByRequest(CqnSelect cqn);

}
