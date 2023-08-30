using { bookstore as db } from '../../db/schema';

service BooksService{
   @readonly entity Book as projection on db.Books excluding{
      createAt,
      modifiedBy}

   @readonly entity Author as projection on db.Authors
}
