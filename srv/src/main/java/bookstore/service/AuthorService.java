package bookstore.service;

import cds.gen.bookstore.Authors;


public interface AuthorService {

  Authors getAuthorById(String id);

}
