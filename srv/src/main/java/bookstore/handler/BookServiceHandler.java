package bookstore.handler;

import bookstore.service.AuthorService;
import bookstore.service.BookService;
import cds.gen.bookstore.Authors;
import cds.gen.bookstore.Books;
import cds.gen.booksservice.BookDto;
import cds.gen.booksservice.Book_;
import cds.gen.booksservice.BooksService_;
import cds.gen.booksservice.GetAllBooksContext;
import com.sap.cds.services.ErrorStatuses;
import com.sap.cds.services.ServiceException;
import com.sap.cds.services.cds.CqnService;
import com.sap.cds.services.handler.EventHandler;
import com.sap.cds.services.handler.annotations.Before;
import com.sap.cds.services.handler.annotations.On;
import com.sap.cds.services.handler.annotations.ServiceName;
import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
@ServiceName(BooksService_.CDS_NAME)
public class BookServiceHandler implements EventHandler {

  private final BookService bookService;

  private final AuthorService authorService;

  // TEST handler
  @Before(event = CqnService.EVENT_CREATE, entity = Book_.CDS_NAME)
  public void validateBookAuthor(List<Books> books) {
    for (Books book : books) {
      String authorId = book.getAuthorId();
      Authors author = authorService.getAuthorById(authorId);
      log.info(
          String.format("Author name %s %s, author id &s", author.getFirstname(), author.getLastname(),
              author.getId()));
    }

  }

  @Before(event = GetAllBooksContext.CDS_NAME)
  public void BeforeSortByStock() {
    List<Books> allBooks = bookService.getAllBooks();
    if (allBooks.isEmpty()) {
      throw new ServiceException(ErrorStatuses.NOT_FOUND, "Book list is empty!");
    }
  }

  @On(event = GetAllBooksContext.CDS_NAME)
  public void onSortByStock(GetAllBooksContext context) {
    List<Books> allBooks = bookService.getAllBooks();
    Collection<BookDto> books = bookService.getBookForAuthor(allBooks, context.getId()).stream()
        .map(this::mapToBookDto).collect(Collectors.toList());
    context.setResult(books);
    context.setCompleted();
  }

  private BookDto mapToBookDto(Books book) {
    BookDto bookDto = BookDto.create();
    bookDto.setName(book.getName());
    bookDto.setPrice(book.getPrice());
    bookDto.setCurrencyCode(book.getCurrencyCode());
    return bookDto;
  }

}
