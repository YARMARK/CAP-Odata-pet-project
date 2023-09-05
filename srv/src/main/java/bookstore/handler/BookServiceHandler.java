package bookstore.handler;

import static java.math.BigDecimal.*;

import bookstore.service.AuthorService;
import bookstore.service.BookService;
import cds.gen.booksservice.BookDto;
import cds.gen.booksservice.Book_;
import cds.gen.booksservice.BooksService_;
import cds.gen.booksservice.GetAllBooksByAuthorContext;
import cds.gen.booksservice.TotalProfitForEachBookContext;
import cds.gen.booksservice.Author;
import cds.gen.bookstore.Authors;
import cds.gen.bookstore.Books;
import cds.gen.booksservice.Book;
import com.sap.cds.ql.cqn.CqnSelect;
import com.sap.cds.services.ErrorStatuses;
import com.sap.cds.services.ServiceException;
import com.sap.cds.services.cds.CdsReadEventContext;
import com.sap.cds.services.cds.CqnService;
import com.sap.cds.services.handler.EventHandler;
import com.sap.cds.services.handler.annotations.Before;
import com.sap.cds.services.handler.annotations.On;
import com.sap.cds.services.handler.annotations.ServiceName;
import java.math.BigDecimal;
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
          String.format("Author name %s %s, author id &s", author.getFirstname(),
              author.getLastname(),
              author.getId()));
    }
  }

  @On(event = CqnService.EVENT_READ, entity = Book_.CDS_NAME)
  public void read(CdsReadEventContext context) {
    List<Book> byRequest = bookService.getByRequest(context.getCqn());
    byRequest.forEach(book -> book.setTotalProfit(valueOf(0.00)));
    context.setResult(byRequest);
    context.setCompleted();
  }
  /////

  @Before(event = GetAllBooksByAuthorContext.CDS_NAME)
  public void BeforeSortByStock() {
    List<Books> allBooks = bookService.getAllBooks();
    if (allBooks.isEmpty()) {
      throw new ServiceException(ErrorStatuses.NOT_FOUND, "Book list is empty!");
    }
  }
  @On(event = GetAllBooksByAuthorContext.CDS_NAME)
  public void onGetAllBooks(GetAllBooksByAuthorContext context) {
    List<Books> allBooks = bookService.getAllBooks();
    Collection<BookDto> books = bookService.getBooksForAuthor(allBooks, context.getId()).stream()
        .map(this::mapToBookDto).collect(Collectors.toList());
    context.setResult(books);
    context.setCompleted();
  }

  @On(event = TotalProfitForEachBookContext.CDS_NAME)
  public void onTotalProfitForEachBook(TotalProfitForEachBookContext context) {
    Author authorByQuery = authorService.getAuthorByQuery(context.getCqn());
    List<Book> bookForAuthor = bookService.getBookForAuthor(bookService.getAllBook(),
        authorByQuery.getId());
    bookForAuthor.forEach(books -> books.setTotalProfit(books.getPrice()
        .multiply(valueOf(books.getStock()))
        .multiply(valueOf(context.getExtra()))));
    for (Book book : bookForAuthor) {
      Boolean flag = checkTopFlag(book);
      if (flag) {
        book.setTop(flag);
        bookService.save(book);
      }
    }
    context.setResult(bookForAuthor);
    context.setCompleted();
  }

  private BookDto mapToBookDto(Books book) {
    BookDto bookDto = BookDto.create();
    bookDto.setName(book.getName());
    bookDto.setPrice(book.getPrice());
    bookDto.setCurrencyCode(book.getCurrencyCode());
    return bookDto;
  }

  private Boolean checkTopFlag(Book book) {
    int i = book.getTotalProfit().compareTo(valueOf(35));
    return i > 0;
  }

}
