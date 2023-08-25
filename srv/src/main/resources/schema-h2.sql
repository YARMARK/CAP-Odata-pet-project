
DROP VIEW IF EXISTS CatalogService_Books;
DROP TABLE IF EXISTS my_bookshop_Books;

CREATE TABLE my_bookshop_Books (
  ID INTEGER NOT NULL,
  title NVARCHAR(255),
  stock INTEGER,
  PRIMARY KEY(ID)
); 

CREATE VIEW CatalogService_Books AS SELECT
  Books_0.ID,
  Books_0.title,
  Books_0.stock
FROM my_bookshop_Books AS Books_0; 

