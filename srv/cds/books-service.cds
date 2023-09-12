using { bookstore as db } from '../../db/schema';
using { Currency } from '@sap/cds/common';

@path: 'BookCase'
service BooksService{

   @(requires: 'Admin')
   @readonly
   entity Author as projection on db.Authors
     actions{
       action totalProfitForEachBook (extra: Integer) returns array of Book;
   };

   entity Book as projection on db.Books;

   @(requires: 'Display')
   function getAllBooksByAuthor (id: String) returns many BookDto;

   type BookDto {
        name: String;
        price : Decimal(9,2);
        currency : Currency;
   }

}
