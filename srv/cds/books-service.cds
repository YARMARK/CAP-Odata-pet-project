using { bookstore as db } from '../../db/schema';

service BooksService{
   @readonly entity Book as projection on db.Books;

   @readonly entity Author as projection on db.Authors;
}
