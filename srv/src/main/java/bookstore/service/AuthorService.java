package bookstore.service;

import cds.gen.bookstore.Authors;
import cds.gen.booksservice.Author;
import com.sap.cds.ql.cqn.CqnSelect;


public interface AuthorService {

  Authors getAuthorById(String id);

  Author getAuthorByQuery(CqnSelect select);

}
