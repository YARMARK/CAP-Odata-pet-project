package bookstore.service.serviceImpl;

import bookstore.service.BookService;
import cds.gen.bookstore.Books_;
import cds.gen.booksservice.Book;
import cds.gen.booksservice.Book_;
import com.sap.cds.Result;
import com.sap.cds.ql.Select;
import com.sap.cds.ql.Update;
import com.sap.cds.ql.cqn.CqnSelect;
import com.sap.cds.ql.cqn.CqnUpdate;
import com.sap.cds.services.persistence.PersistenceService;
import java.util.List;
import cds.gen.bookstore.Books;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
@Slf4j
public class BookServiceImpl implements BookService {

  private final PersistenceService service;

  @Override
  public List<Books> getAllBooks() {
    return service.run(
        Select.from(Books_.class)).listOf(cds.gen.bookstore.Books.class);

  }

  @Override
  public List<Book> getBookForAuthor(List<Book> bookList, String id) {
    return service.run(
        Select.from(Book_.class)
            .where(book -> book.author_ID().eq(id))).listOf(Book.class);
  }

  @Override
  public List<Books> getBooksForAuthor(List<Books> bookList, String authorId) {
    return service.run(Select.from(cds.gen.bookstore.Books_.class)
        .where(book -> book.author_ID().eq(authorId))).listOf(Books.class);
  }

  @Override
  public List<Book> getAllBook() {
    return service.run(
        Select.from(Book_.class)).listOf(Book.class);
  }


  @Override
  public void save(Book book) {
    CqnUpdate update = Update.entity(Books_.class).data(book);
    service.run(update);
  }

  @Override
  public List<Book> getByRequest(CqnSelect cqn) {
    return service.run(cqn).listOf(Book.class);
  }
}
