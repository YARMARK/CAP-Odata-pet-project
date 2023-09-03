namespace bookstore;

using { Currency, cuid, managed } from '@sap/cds/common';

  entity Authors : cuid {
    firstname : String(111);
    lastname  : String(111);
    books     : Association to many Books on books.author = $self;
    }

  entity Books : cuid {
    name    : String(111) @mandatory;
    stock   : Integer @assert.range: [ 1, 20 ];
    price   : Decimal(9,2);
    currency : Currency;
    author  : Association to Authors;
    stores  : Association to many BooksStores on stores.book = $self;
  }

  entity Stores : cuid, managed{
    name : String(111) @mandatory;
    books: Association to many BooksStores on books.store = $self;
  }

  entity BooksStores : managed{
    key book  : Association to Books @mandatory @assert.target;
    key store : Association to Stores @mandatory @assert.target;
  }