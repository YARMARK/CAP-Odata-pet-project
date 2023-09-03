using { bookstore as db } from '../../db/schema';
using { Currency } from '@sap/cds/common';

@path: 'BookCase'
service BooksService{

   @readonly
   entity Author as projection on db.Authors;

   @readonly
   entity Book as projection on db.Books;

   function getAllBooks (id: String) returns many BookDto;

   type BookDto {
        name: String;
        price : Decimal;
        currency : Currency;
   }

}
