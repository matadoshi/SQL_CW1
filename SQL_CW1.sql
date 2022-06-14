CREATE DATABASE [LibraryClassWork]
USE LibraryClassWork

CREATE TABLE Books(
Id int PRIMARY KEY IDENTITY,
FullName nvarchar(255) NOT NULL CHECK (LEN(FullName)>2 AND LEN(FullName)<100) ,
PageCount int CHECK (PageCount>10)
)

CREATE TABLE Authors(
Id int PRIMARY KEY IDENTITY,
Name nvarchar(255) NOT NULL,
Surname nvarchar(255) NOT NULL
)
ALTER TABLE Books
ADD AuthorsId int FOREIGN KEY REFERENCES Authors(Id)

CREATE VIEW usv_GetAll AS 
SELECT b.Id,b.FullName,b.PageCount,(a.Name+' '+a.Surname) 'AuthorName' 
FROM Books b JOIN Authors a ON a.Id=b.AuthorsId

Select * FROM usv_GetAll

Create PROCEDURE usp_GetByName
@name nvarchar(255)
As
Begin
	Select * From usv_GetAll a 
	WHERE a.AuthorName Like '%'+@name+'%'
End

DROP PROCEDURE usp_GetByName

Create Procedure usp_AddAuthor
@Name nvarchar(255),
@Surname nvarchar(255)
As
Begin
	INSERT INTO Authors VALUES (@Name,@Surname)
End

Create Procedure usp_UpdateData
@Name nvarchar(255),
@Surname nvarchar(255)
As
Begin
	UPDATE Authors
	SET Name=@Name,Surname=@Surname
End

Create Procedure usp_DeleteData
@id int
As
Begin
	DELETE FROM Authors WHERE Id=@id
End

Create VIEW usv_GetByAuthor
As
SELECT a.Id,(a.Name+' '+a.Surname) 'FullName',Count(*) 'BooksCount',MAX(b.PageCount) 'MaxPageCount'FROM Authors a
JOIN Books b On a.Id=b.AuthorsId Group By a.Id,a.Name,a.Surname

SELECT * FROM usv_GetByAuthor