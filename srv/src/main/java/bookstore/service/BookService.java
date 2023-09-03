package bookstore.service;

import java.util.List;

import cds.gen.bookstore.Books;

public interface BookService {

  List<Books> getAllBooks();

  List<Books> getBookForAuthor(List<Books> bookList,String id);

}
