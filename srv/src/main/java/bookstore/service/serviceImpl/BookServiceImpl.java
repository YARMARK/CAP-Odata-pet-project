package bookstore.service.serviceImpl;

import bookstore.service.BookService;
import cds.gen.bookstore.Books_;
import com.sap.cds.ql.Select;
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
  public List<Books> getBookForAuthor(List<Books> bookList, String authorId) {
    return service.run(Select.from(cds.gen.bookstore.Books_.class)
        .where(book -> book.author_ID().eq(authorId))).listOf(Books.class);
  }


}
