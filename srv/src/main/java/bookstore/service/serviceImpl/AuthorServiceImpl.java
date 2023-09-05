package bookstore.service.serviceImpl;

import bookstore.service.AuthorService;
import cds.gen.bookstore.Authors;
import cds.gen.bookstore.Authors_;
import cds.gen.booksservice.Author;
import com.sap.cds.ql.Select;
import com.sap.cds.ql.cqn.CqnSelect;
import com.sap.cds.services.ErrorStatuses;
import com.sap.cds.services.ServiceException;
import com.sap.cds.services.persistence.PersistenceService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
@Slf4j
public class AuthorServiceImpl implements AuthorService {

  private final PersistenceService service;

  @Override
  public Authors getAuthorById(String id) {
    CqnSelect sel = Select.from(Authors_.class).where(a -> a.ID().eq(id));
    return service.run(sel).first(Authors.class).orElseThrow(
        () -> new ServiceException(ErrorStatuses.NOT_FOUND, "Author does not exist"));
  }

  @Override
  public Author getAuthorByQuery(CqnSelect select) {
    return service.run(select).first(Author.class)
        .orElseThrow(() -> new ServiceException(ErrorStatuses.NOT_FOUND, "Author does not exist"));
  }
}
