
DROP VIEW IF EXISTS localized_fr_BooksService_Author;
DROP VIEW IF EXISTS localized_de_BooksService_Author;
DROP VIEW IF EXISTS localized_fr_BooksService_Book;
DROP VIEW IF EXISTS localized_de_BooksService_Book;
DROP VIEW IF EXISTS localized_fr_BooksService_Currencies;
DROP VIEW IF EXISTS localized_de_BooksService_Currencies;
DROP VIEW IF EXISTS localized_fr_bookstore_Stores;
DROP VIEW IF EXISTS localized_de_bookstore_Stores;
DROP VIEW IF EXISTS localized_fr_bookstore_BooksStores;
DROP VIEW IF EXISTS localized_de_bookstore_BooksStores;
DROP VIEW IF EXISTS localized_fr_bookstore_Authors;
DROP VIEW IF EXISTS localized_de_bookstore_Authors;
DROP VIEW IF EXISTS localized_fr_bookstore_Books;
DROP VIEW IF EXISTS localized_de_bookstore_Books;
DROP VIEW IF EXISTS localized_fr_sap_common_Currencies;
DROP VIEW IF EXISTS localized_de_sap_common_Currencies;
DROP VIEW IF EXISTS localized_BooksService_Author;
DROP VIEW IF EXISTS localized_BooksService_Book;
DROP VIEW IF EXISTS localized_BooksService_Currencies;
DROP VIEW IF EXISTS localized_bookstore_Stores;
DROP VIEW IF EXISTS localized_bookstore_BooksStores;
DROP VIEW IF EXISTS localized_bookstore_Authors;
DROP VIEW IF EXISTS localized_bookstore_Books;
DROP VIEW IF EXISTS localized_sap_common_Currencies;
DROP VIEW IF EXISTS BooksService_Currencies_texts;
DROP VIEW IF EXISTS BooksService_Currencies;
DROP VIEW IF EXISTS BooksService_Book;
DROP VIEW IF EXISTS BooksService_Author;
DROP TABLE IF EXISTS sap_common_Currencies_texts;
DROP TABLE IF EXISTS sap_common_Currencies;
DROP TABLE IF EXISTS bookstore_BooksStores;
DROP TABLE IF EXISTS bookstore_Stores;
DROP TABLE IF EXISTS bookstore_Books;
DROP TABLE IF EXISTS bookstore_Authors;

CREATE TABLE bookstore_Authors (
  ID NVARCHAR(36) NOT NULL,
  firstname NVARCHAR(111),
  lastname NVARCHAR(111),
  PRIMARY KEY(ID)
); 

CREATE TABLE bookstore_Books (
  ID NVARCHAR(36) NOT NULL,
  name NVARCHAR(111),
  stock INTEGER,
  price DECIMAL(9, 2),
  currency_code NVARCHAR(3),
  "TOP" BOOLEAN DEFAULT FALSE,
  author_ID NVARCHAR(36),
  PRIMARY KEY(ID)
); 

CREATE TABLE bookstore_Stores (
  ID NVARCHAR(36) NOT NULL,
  createdAt TIMESTAMP(7),
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP(7),
  modifiedBy NVARCHAR(255),
  name NVARCHAR(111),
  PRIMARY KEY(ID)
); 

CREATE TABLE bookstore_BooksStores (
  createdAt TIMESTAMP(7),
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP(7),
  modifiedBy NVARCHAR(255),
  book_ID NVARCHAR(36) NOT NULL,
  store_ID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(book_ID, store_ID)
); 

CREATE TABLE sap_common_Currencies (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(3) NOT NULL,
  symbol NVARCHAR(5),
  minorUnit SMALLINT,
  PRIMARY KEY(code)
); 

CREATE TABLE sap_common_Currencies_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(3) NOT NULL,
  PRIMARY KEY(locale, code)
); 

CREATE VIEW BooksService_Author AS SELECT
  Authors_0.ID,
  Authors_0.firstname,
  Authors_0.lastname
FROM bookstore_Authors AS Authors_0; 

CREATE VIEW BooksService_Book AS SELECT
  Books_0.ID,
  Books_0.name,
  Books_0.stock,
  Books_0.price,
  Books_0.currency_code,
  Books_0."TOP",
  Books_0.author_ID
FROM bookstore_Books AS Books_0; 

CREATE VIEW BooksService_Currencies AS SELECT
  Currencies_0.name,
  Currencies_0.descr,
  Currencies_0.code,
  Currencies_0.symbol,
  Currencies_0.minorUnit
FROM sap_common_Currencies AS Currencies_0; 

CREATE VIEW BooksService_Currencies_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM sap_common_Currencies_texts AS texts_0; 

CREATE VIEW localized_sap_common_Currencies AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code,
  L_0.symbol,
  L_0.minorUnit
FROM (sap_common_Currencies AS L_0 LEFT JOIN sap_common_Currencies_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = @locale); 

CREATE VIEW localized_bookstore_Books AS SELECT
  L.ID,
  L.name,
  L.stock,
  L.price,
  L.currency_code,
  L."TOP",
  L.author_ID
FROM bookstore_Books AS L; 

CREATE VIEW localized_bookstore_Authors AS SELECT
  L.ID,
  L.firstname,
  L.lastname
FROM bookstore_Authors AS L; 

CREATE VIEW localized_bookstore_BooksStores AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.book_ID,
  L.store_ID
FROM bookstore_BooksStores AS L; 

CREATE VIEW localized_bookstore_Stores AS SELECT
  L.ID,
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.name
FROM bookstore_Stores AS L; 

CREATE VIEW localized_BooksService_Currencies AS SELECT
  Currencies_0.name,
  Currencies_0.descr,
  Currencies_0.code,
  Currencies_0.symbol,
  Currencies_0.minorUnit
FROM localized_sap_common_Currencies AS Currencies_0; 

CREATE VIEW localized_BooksService_Book AS SELECT
  Books_0.ID,
  Books_0.name,
  Books_0.stock,
  Books_0.price,
  Books_0.currency_code,
  Books_0."TOP",
  Books_0.author_ID
FROM localized_bookstore_Books AS Books_0; 

CREATE VIEW localized_BooksService_Author AS SELECT
  Authors_0.ID,
  Authors_0.firstname,
  Authors_0.lastname
FROM localized_bookstore_Authors AS Authors_0; 

CREATE VIEW localized_de_sap_common_Currencies AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code,
  L_0.symbol,
  L_0.minorUnit
FROM (sap_common_Currencies AS L_0 LEFT JOIN sap_common_Currencies_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = @locale); 

CREATE VIEW localized_fr_sap_common_Currencies AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code,
  L_0.symbol,
  L_0.minorUnit
FROM (sap_common_Currencies AS L_0 LEFT JOIN sap_common_Currencies_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = @locale); 

CREATE VIEW localized_de_bookstore_Books AS SELECT
  L.ID,
  L.name,
  L.stock,
  L.price,
  L.currency_code,
  L."TOP",
  L.author_ID
FROM bookstore_Books AS L; 

CREATE VIEW localized_fr_bookstore_Books AS SELECT
  L.ID,
  L.name,
  L.stock,
  L.price,
  L.currency_code,
  L."TOP",
  L.author_ID
FROM bookstore_Books AS L; 

CREATE VIEW localized_de_bookstore_Authors AS SELECT
  L.ID,
  L.firstname,
  L.lastname
FROM bookstore_Authors AS L; 

CREATE VIEW localized_fr_bookstore_Authors AS SELECT
  L.ID,
  L.firstname,
  L.lastname
FROM bookstore_Authors AS L; 

CREATE VIEW localized_de_bookstore_BooksStores AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.book_ID,
  L.store_ID
FROM bookstore_BooksStores AS L; 

CREATE VIEW localized_fr_bookstore_BooksStores AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.book_ID,
  L.store_ID
FROM bookstore_BooksStores AS L; 

CREATE VIEW localized_de_bookstore_Stores AS SELECT
  L.ID,
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.name
FROM bookstore_Stores AS L; 

CREATE VIEW localized_fr_bookstore_Stores AS SELECT
  L.ID,
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.name
FROM bookstore_Stores AS L; 

CREATE VIEW localized_de_BooksService_Currencies AS SELECT
  Currencies_0.name,
  Currencies_0.descr,
  Currencies_0.code,
  Currencies_0.symbol,
  Currencies_0.minorUnit
FROM localized_de_sap_common_Currencies AS Currencies_0; 

CREATE VIEW localized_fr_BooksService_Currencies AS SELECT
  Currencies_0.name,
  Currencies_0.descr,
  Currencies_0.code,
  Currencies_0.symbol,
  Currencies_0.minorUnit
FROM localized_fr_sap_common_Currencies AS Currencies_0; 

CREATE VIEW localized_de_BooksService_Book AS SELECT
  Books_0.ID,
  Books_0.name,
  Books_0.stock,
  Books_0.price,
  Books_0.currency_code,
  Books_0."TOP",
  Books_0.author_ID
FROM localized_de_bookstore_Books AS Books_0; 

CREATE VIEW localized_fr_BooksService_Book AS SELECT
  Books_0.ID,
  Books_0.name,
  Books_0.stock,
  Books_0.price,
  Books_0.currency_code,
  Books_0."TOP",
  Books_0.author_ID
FROM localized_fr_bookstore_Books AS Books_0; 

CREATE VIEW localized_de_BooksService_Author AS SELECT
  Authors_0.ID,
  Authors_0.firstname,
  Authors_0.lastname
FROM localized_de_bookstore_Authors AS Authors_0; 

CREATE VIEW localized_fr_BooksService_Author AS SELECT
  Authors_0.ID,
  Authors_0.firstname,
  Authors_0.lastname
FROM localized_fr_bookstore_Authors AS Authors_0; 

